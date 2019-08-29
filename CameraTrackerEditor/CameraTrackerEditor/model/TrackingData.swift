//
//  TrackingData.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

enum TrackingDataError : Error, CustomStringConvertible {
    case CloneArgumentError
    
    var description: String {
        switch self {
        case .CloneArgumentError:
            return "Can't clone tracking data with zero or negative interval."
        }
    }
}

struct TrackingEntry {
    let timeStamp: Double
    let position: Vec3
    let rotation: Vec3
}

enum InterpolationMethod {
    case NearestNeighbor
    case Linear
    case Cubic
}

enum TrackingComponent {
    case PositionX
    case PositionY
    case PositionZ
    case RotationX
    case RotationY
    case RotationZ
}

class TrackingData {
    // range type for Vec3
    private typealias Vec3Range = (min: Vec3, max: Vec3)
    
    // container for interpolation values
    internal typealias DataForInterpolation = (
        normalizedTime: Float,
        entries: [TrackingEntry]
    )
    
    private var m_entries: Array<TrackingEntry>
    private var m_duration: Double
    private var m_positionRanges: Vec3Range
    private var m_rotationRanges: Vec3Range
    
    
    var duration: Double { get { return m_duration } }
    var isEmpty: Bool { get { return m_entries.isEmpty } }
    var numberOfEntries: Int { get { return m_entries.count } }
    var minPositionValues: Vec3 { get { return m_positionRanges.min } }
    var maxPositionValues: Vec3 { get { return m_positionRanges.max } }
    var minRotationValues: Vec3 { get { return m_rotationRanges.min } }
    var maxRotationValues: Vec3 { get { return m_rotationRanges.max } }
    
    
    init() {
        m_entries = []
        m_duration = 0
        m_positionRanges = (
            min: Vec3(.greatestFiniteMagnitude, .greatestFiniteMagnitude, .greatestFiniteMagnitude),
            max: Vec3(-.greatestFiniteMagnitude, -.greatestFiniteMagnitude, -.greatestFiniteMagnitude)
        )
        m_rotationRanges = (
            min: Vec3(.greatestFiniteMagnitude, .greatestFiniteMagnitude, .greatestFiniteMagnitude),
            max: Vec3(-.greatestFiniteMagnitude, -.greatestFiniteMagnitude, -.greatestFiniteMagnitude)
        )
    }
    
    
    func pushEntry(deltaTime: Double, position: Vec3, rotation: Vec3) {
        // add entry
        let entry = TrackingEntry(
            timeStamp: m_duration,
            position: position,
            rotation: rotation
        )
        m_entries.append(entry)
        
        // update ranges
        m_positionRanges = updateRange(newValues: position, oldRange: m_positionRanges)
        m_rotationRanges = updateRange(newValues: rotation, oldRange: m_rotationRanges)
        
        // update duration
        m_duration += deltaTime
    }
    
    func getEntryIndex(fromTime time: Double) -> Int {
        if isEmpty {
            return 0
        }
        return findIndexAtTimeRec(time, start: 0, end: numberOfEntries)
    }
    
    func getData(atIndex index: Int) -> TrackingEntry? {
        if isIndexOutOfRange(index: index) {
            return nil
        }
        let entry = m_entries[index]
        return TrackingEntry(
            timeStamp: entry.timeStamp,
            position: entry.position,
            rotation: entry.rotation
        )
    }
    
    func getData( atTime time: Double,
                  withInterpolation interpolationMethod: InterpolationMethod = .Cubic ) -> TrackingEntry? {
        if isEmpty {
            return nil
        }
        let index = findIndexAtTimeRec(time, start: 0, end: numberOfEntries)
        return getData(atTime: time, atIndex: index, interpolationMethod: interpolationMethod)
    }
    
    func getData( atIndex index: Int,
                  forComponent component: TrackingComponent) -> Float? {
        if isIndexOutOfRange(index: index) {
            return nil
        }
        return getComponentValues(entries: [m_entries[index]], forComponent: component).first
    }
    
    func getData( atTime time: Double,
                  forComponent component: TrackingComponent,
                  withInterpolation interpolationMethod: InterpolationMethod = .Cubic) -> Float? {
        return getDataValue(atTime: time, forComponent: component, withInterpolation: interpolationMethod)
    }
    
    func getData( fromIndex index0: Int,
                  toIndex index1: Int,
                  withSubdivisions subdivisions: Int = 4,
                  withInterpolation interpolationMethod: InterpolationMethod = .Cubic) -> Array<TrackingEntry> {
        if isEmpty {
            return []
        }
        let i0 = conformIndexToEntryRange(index: index0)
        let i1 = conformIndexToEntryRange(index: index1)
        return getData(
            fromTime: m_entries[i0].timeStamp,
            toTime: m_entries[i1].timeStamp,
            withSubdivisions: subdivisions,
            withInterpolation: interpolationMethod
        )
    }
    
    func getData( fromTime time0: Double,
                  toTime time1: Double,
                  withSubdivisions subdivisions: Int = 4,
                  withInterpolation interpolationMethod: InterpolationMethod = .Cubic) -> Array<TrackingEntry> {
        let t0 = min(time0, time1)
        let t1 = max(time0, time1)
        let interval = (t1 - t0) / Double(subdivisions)
        
        var result: Array<TrackingEntry> = []
        var t = t0
        while t < t1 {
            if let data = getData(atTime: t, withInterpolation: interpolationMethod) {
                result.append(data)
            }
            t = t + interval
        }
        return result
    }
    
    func getData( fromIndex index0: Int,
                  toIndex index1: Int,
                  forComponent component: TrackingComponent,
                  withSubdivisions subdivisions: Int = 4,
                  withInterpolation interpolationMethod: InterpolationMethod = .Cubic) -> Array<Float> {
        if isEmpty {
            return []
        }
        let i0 = conformIndexToEntryRange(index: index0)
        let i1 = conformIndexToEntryRange(index: index1)
        return getData(
            fromTime: m_entries[i0].timeStamp,
            toTime: m_entries[i1].timeStamp,
            forComponent: component,
            withSubdivisions: subdivisions,
            withInterpolation: interpolationMethod
        )
    }
    
    func getData( fromTime time0: Double,
                  toTime time1: Double,
                  forComponent component: TrackingComponent,
                  withSubdivisions subdivisions: Int = 4,
                  withInterpolation interpolationMethod: InterpolationMethod = .Cubic) -> Array<Float> {
        let t0 = min(time0, time1)
        let t1 = max(time0, time1)
        let interval = (t1 - t0) / Double(subdivisions)
        
        var result: Array<Float> = []
        var t = t0
        while t < t1 {
            if let data = getData(atTime: t, forComponent: component, withInterpolation: interpolationMethod) {
                result.append(data)
            }
            t = t + interval
        }
        return result
    }
    
    func cloneData( withInterval interval: Double,
                    withInterpolation interpolationMethod: InterpolationMethod = .Cubic ) throws -> TrackingData {
        // interval must be positive
        guard interval > 0.0 else {
            throw TrackingDataError.CloneArgumentError
        }
        
        // create clone data container and add entries based on interval
        let result = TrackingData()
        var time = 0.0
        var index = 0
        while time < duration {
            // update index to the correct entry we should work off of at the given time
            while index < numberOfEntries && time >= m_entries[index].timeStamp {
                index += 1
            }
            
            // build entry and add it to the new data
            let entry = getData(atTime: time, atIndex: index, interpolationMethod: interpolationMethod)
            result.pushEntry(deltaTime: interval, position: entry.position, rotation: entry.rotation)
            
            // advance time to next interval
            time += interval
        }
        return result
    }
    
    
    private func isIndexOutOfRange(index: Int) -> Bool {
        return index < 0 || index >= numberOfEntries
    }
    
    private func updateRange(newValues: Vec3, oldRange: Vec3Range) -> Vec3Range {
        return Vec3Range(
            min: min(newValues, oldRange.min),
            max: max(newValues, oldRange.max)
        )
    }
    
    private func findIndexAtTimeRec(_ time: Double, start: Int, end: Int) -> Int {
        // base case - we've narrowed down the range
        if end - start == 1 {
            return start
        }
        
        // get middle index
        let middle = start + (end - start) / 2
        let entry = m_entries[middle]
        
        // which way should we go
        if time == entry.timeStamp {
            return middle
        }
        else if time < entry.timeStamp {
            return findIndexAtTimeRec(time, start: start, end: middle)
        }
        else {
            return findIndexAtTimeRec(time, start: middle, end: end)
        }
    }
    
    private func conformIndexToEntryRange(index: Int) -> Int {
        var result = index >= numberOfEntries ? numberOfEntries - 1 : index
        result = result < 0 ? 0 : result
        return result
    }
    
    private func buildDataForInterpolation( time: Double,
                                            index: Int,
                                            interpolationMethod: InterpolationMethod) -> DataForInterpolation {
        let indices = getInterpolationIndices(index: index, interpolationMethod: interpolationMethod)
        let entries = getEntriesFromIndices(indices: indices)
        return DataForInterpolation(
            normalizedTime: calculateNormalizedTime(
                time: time,
                entries: entries,
                interpolationMethod: interpolationMethod),
            entries: entries
        )
    }
    
    private func getInterpolationIndices(index: Int, interpolationMethod: InterpolationMethod) -> [Int] {
        switch interpolationMethod {
        case .NearestNeighbor, .Linear:
            return getIndexPairFromIndex(index)
        case .Cubic:
            return getIndexQuadFromIndex(index)
        }
    }
    
    private func getIndexPairFromIndex(_ index: Int) -> [Int] {
        // special case for a single entry
        if numberOfEntries == 1 {
            return [0, 0]
        }
        // if first index is at the end, then shift backwards
        if index == numberOfEntries - 1 {
            return [index - 1, index]
        }
        else {
            return [index, index + 1]
        }
    }
    
    private func getIndexQuadFromIndex(_ index: Int) -> [Int] {
        // get middle pair
        let pair = getIndexPairFromIndex(index)
        
        // get ending indexes
        let p0 = pair[0] == 0 ? 0 : pair[0] - 1
        let p3 = pair[1] == numberOfEntries - 1 ? pair[1] : pair[1] + 1
        
        // return quad
        return [p0, pair[0], pair[1], p3]
    }
    
    private func getEntriesFromIndices(indices: [Int]) -> [TrackingEntry] {
        return indices.map { m_entries[$0] }
    }
    
    private func calculateNormalizedTime( time: Double,
                                          entries: [TrackingEntry],
                                          interpolationMethod: InterpolationMethod) -> Float {
        switch interpolationMethod {
        case .NearestNeighbor, .Linear:
            return normalizeTimeAtRange(
                time: time,
                start: entries[0].timeStamp,
                end: entries[1].timeStamp
            )
        case .Cubic:
            return normalizeTimeAtRange(
                time: time,
                start: entries[1].timeStamp,
                end: entries[2].timeStamp
            )
        }
    }
    
    private func normalizeTimeAtRange(time: Double, start: Double, end: Double) -> Float {
        let diff = end - start
        if diff == 0 {
            return 0
        }
        else {
            return Float((time - start) / diff)
        }
    }
    
    private func getData( atTime time: Double,
                          atIndex index: Int,
                          interpolationMethod: InterpolationMethod) -> TrackingEntry {
        let data = buildDataForInterpolation(
            time: time,
            index: index,
            interpolationMethod: interpolationMethod
        )
        return TrackingEntry(
            timeStamp: time,
            position: Vec3(
                x: performInterpolation(
                    values: data.entries.map {$0.position.x},
                    normalizedTime: data.normalizedTime,
                    interpolationMethod: interpolationMethod
                ),
                y: performInterpolation(
                    values: data.entries.map {$0.position.y},
                    normalizedTime: data.normalizedTime,
                    interpolationMethod: interpolationMethod
                ),
                z: performInterpolation(
                    values: data.entries.map {$0.position.z},
                    normalizedTime: data.normalizedTime,
                    interpolationMethod: interpolationMethod
                )
            ),
            rotation: Vec3(
                x: performInterpolation(
                    values: data.entries.map {$0.rotation.x},
                    normalizedTime: data.normalizedTime,
                    interpolationMethod: interpolationMethod
                ),
                y: performInterpolation(
                    values: data.entries.map {$0.rotation.y},
                    normalizedTime: data.normalizedTime,
                    interpolationMethod: interpolationMethod
                ),
                z: performInterpolation(
                    values: data.entries.map {$0.rotation.z},
                    normalizedTime: data.normalizedTime,
                    interpolationMethod: interpolationMethod
                )
            )
        )
    }
    
    private func getDataValue( atTime time: Double,
                               forComponent component: TrackingComponent,
                               withInterpolation interpolationMethod: InterpolationMethod) -> Float? {
        if isEmpty {
            return nil
        }
        let index = findIndexAtTimeRec(time, start: 0, end: numberOfEntries)
        return getDataValue(
            atTime: time,
            atIndex: index,
            forComponent: component,
            withInterpolation: interpolationMethod
        )
    }
    
    private func getDataValue( atTime time: Double,
                               atIndex index: Int,
                               forComponent component: TrackingComponent,
                               withInterpolation interpolationMethod: InterpolationMethod) -> Float? {
        let data = buildDataForInterpolation(
            time: time,
            index: index,
            interpolationMethod: interpolationMethod
        )
        return performInterpolation(
            values: getComponentValues(
                entries: data.entries,
                forComponent: component
            ),
            normalizedTime: data.normalizedTime,
            interpolationMethod: interpolationMethod
        )
    }
    
    private func getComponentValues( entries: [TrackingEntry],
                                     forComponent component: TrackingComponent) -> [Float] {
        switch component {
        case .PositionX:
            return entries.map {$0.position.x}
        case .PositionY:
            return entries.map {$0.position.y}
        case .PositionZ:
            return entries.map {$0.position.z}
        case .RotationX:
            return entries.map {$0.rotation.x}
        case .RotationY:
            return entries.map {$0.rotation.y}
        case .RotationZ:
            return entries.map {$0.rotation.z}
        }
    }
    
    private func performInterpolation( values: [Float],
                                       normalizedTime: Float,
                                       interpolationMethod: InterpolationMethod) -> Float {
        switch interpolationMethod {
        case .NearestNeighbor:
            return nearestNeighborInterpolation(a: values[0], b: values[1], t: normalizedTime)
        case .Linear:
            return linearInterpolation(a: values[0], b: values[1], t: normalizedTime)
        case .Cubic:
            return cubicInterpolation(p: (values[0], values[1], values[2], values[3]), t: normalizedTime)
        }
    }
}
