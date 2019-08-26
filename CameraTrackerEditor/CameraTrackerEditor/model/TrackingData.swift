//
//  TrackingData.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Darwin

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

class TrackingData {
    private var m_entries: Array<TrackingEntry>
    private var m_duration: Double
    private var m_positionRanges: (min: Vec3, max: Vec3)
    private var m_rotationRanges: (min: Vec3, max: Vec3)
    
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
            min: (x: -.greatestFiniteMagnitude, y: -.greatestFiniteMagnitude, z: -.greatestFiniteMagnitude),
            max: (x: .greatestFiniteMagnitude, y: .greatestFiniteMagnitude, z: .greatestFiniteMagnitude)
        )
        m_rotationRanges = (
            min: (x: -.greatestFiniteMagnitude, y: -.greatestFiniteMagnitude, z: -.greatestFiniteMagnitude),
            max: (x: .greatestFiniteMagnitude, y: .greatestFiniteMagnitude, z: .greatestFiniteMagnitude)
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
        m_positionRanges = (
            min: min(m_positionRanges.min, entry.position),
            max: max(m_positionRanges.max, entry.position)
        )
        m_rotationRanges = (
            min: min(m_rotationRanges.min, entry.rotation),
            max: max(m_rotationRanges.max, entry.rotation)
        )
        
        // update duration
        m_duration += deltaTime
    }
    
    func getDataAtIndex(_ index: Int) -> TrackingEntry? {
        if index < 0 || index >= numberOfEntries {
            return nil
        }
        let entry = m_entries[index]
        return TrackingEntry(
            timeStamp: entry.timeStamp,
            position: entry.position,
            rotation: entry.rotation
        )
    }
    
    func getDataAtTime(_ time: Double, interpolationMethod: InterpolationMethod = InterpolationMethod.NearestNeighbor) -> TrackingEntry? {
        if isEmpty {
            return nil
        }
        let index = findIndexAtTimeRec(time, start: 0, end: numberOfEntries)
        return getDataAtTimeAndIndex(time, index, interpolationMethod: interpolationMethod)
    }
    
    func cloneDataWithConstantInterval(_ interval: Double, interpolationMethod: InterpolationMethod = .Cubic) throws -> TrackingData {
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
            if let entry = getDataAtTimeAndIndex(time, index, interpolationMethod: interpolationMethod) {
                result.pushEntry(deltaTime: interval, position: entry.position, rotation: entry.rotation)
            }
            
            // advance time to next interval
            time += interval
        }
        return result
    }
    
    
    private func getDataAtTimeAndIndex(_ time: Double, _ index: Int, interpolationMethod: InterpolationMethod) -> TrackingEntry? {
        switch interpolationMethod {
        case .NearestNeighbor:
            return getDataNearestNeighborAtIndex(index, time: time)
        case .Linear:
            return getDataLinearAtIndex(index, time: time)
        case .Cubic:
            return getDataCubicAtIndex(index, time: time)
        }
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
    
    private func getIndexPairFromIndex(_ index: Int) -> (Int, Int) {
        // special case for a single entry
        if numberOfEntries == 1 {
            return (0, 0)
        }
        // if first index is at the end, then shift backwards
        if index == numberOfEntries - 1 {
            return (index - 1, index)
        }
        else {
            return (index, index + 1)
        }
    }
    
    private func getIndexQuadFromIndex(_ index: Int) -> (Int, Int, Int, Int) {
        // get middle pair
        let pair = getIndexPairFromIndex(index)
        
        // get ending indexes
        let p0 = pair.0 == 0 ? 0 : pair.0 - 1
        let p3 = pair.1 == numberOfEntries - 1 ? pair.1 : pair.1 + 1
        
        // return quad
        return (p0, pair.0, pair.1, p3)
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
    
    private func getDataNearestNeighborAtIndex(_ index: Int, time: Double) -> TrackingEntry {
        let pair = getIndexPairFromIndex(index)
        let entries = (m_entries[pair.0], m_entries[pair.1])
        let t = normalizeTimeAtRange(time: time, start: entries.0.timeStamp, end: entries.1.timeStamp)
        return TrackingEntry(
            timeStamp: time,
            position: nearestNeighborInterpolation(a: entries.0.position, b: entries.1.position, t: t),
            rotation: nearestNeighborInterpolation(a: entries.0.rotation, b: entries.1.rotation, t: t)
        )
    }
    
    private func getDataLinearAtIndex(_ index: Int, time: Double) -> TrackingEntry {
        let pair = getIndexPairFromIndex(index)
        let entries = (m_entries[pair.0], m_entries[pair.1])
        let t = normalizeTimeAtRange(time: time, start: entries.0.timeStamp, end: entries.1.timeStamp)
        return TrackingEntry(
            timeStamp: time,
            position: linearInterpolation(a: entries.0.position, b: entries.1.position, t: t),
            rotation: linearInterpolation(a: entries.0.rotation, b: entries.1.rotation, t: t)
        )
    }
    
    private func getDataCubicAtIndex(_ index: Int, time: Double) -> TrackingEntry {
        let quad = getIndexQuadFromIndex(index)
        let entries = (m_entries[quad.0], m_entries[quad.1], m_entries[quad.2], m_entries[quad.3])
        let t = normalizeTimeAtRange(time: time, start: entries.1.timeStamp, end: entries.2.timeStamp)
        return TrackingEntry(
            timeStamp: time,
            position: cubicInterpolation(
                p: (entries.0.position, entries.1.position, entries.2.position, entries.3.position),
                t: t
            ),
            rotation: cubicInterpolation(
                p: (entries.0.rotation, entries.1.rotation, entries.2.rotation, entries.3.rotation),
                t: t
            )
        )
    }
}
