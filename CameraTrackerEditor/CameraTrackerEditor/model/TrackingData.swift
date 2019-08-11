//
//  TrackingData.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Darwin

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
    
    func getDataAtTime(_ time: Double, interpolationMethod: InterpolationMethod = InterpolationMethod.NearestNeighbor) -> TrackingEntry? {
        if isEmpty {
            return nil
        }
        switch interpolationMethod {
        case .NearestNeighbor:
            return getDataNearestNeighborAtTime(time)
        case .Linear:
            return getDataLinearAtTime(time)
        case .Cubic:
            return getDataCubicAtTime(time)
        }
    }
    
    
    private func findEntryAtTimeRec(_ time: Double, start: Int, end: Int) -> Int {
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
            return findEntryAtTimeRec(time, start: start, end: middle)
        }
        else {
            return findEntryAtTimeRec(time, start: middle, end: end)
        }
        
    }
    
    private func getIndexPairAtTime(_ time: Double) -> (Int, Int) {
        // special case for a single entry
        if m_entries.count == 1 {
            return (0, 0)
        }
        
        // find potential starting index for pair
        let firstIndex = findEntryAtTimeRec(time, start: 0, end: m_entries.count)
        
        // if first index is at the end, then shift backwards
        if firstIndex == m_entries.count - 1 {
            return (firstIndex - 1, firstIndex)
        }
        else {
            return (firstIndex, firstIndex + 1)
        }
    }
    
    private func getIndexQuadAtTime(_ time: Double) -> (Int, Int, Int, Int) {
        // get middle pair
        let pair = getIndexPairAtTime(time)
        
        // get ending indexes
        let p0 = pair.0 == 0 ? 0 : pair.0 - 1
        let p3 = pair.1 == m_entries.count - 1 ? pair.1 : pair.1 + 1
        
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
    
    private func getDataNearestNeighborAtTime(_ time: Double) -> TrackingEntry {
        let pair = getIndexPairAtTime(time)
        let entries = (m_entries[pair.0], m_entries[pair.1])
        let t = normalizeTimeAtRange(time: time, start: entries.0.timeStamp, end: entries.1.timeStamp)
        return TrackingEntry(
            timeStamp: time,
            position: nearestNeighborInterpolation(a: entries.0.position, b: entries.1.position, t: t),
            rotation: nearestNeighborInterpolation(a: entries.0.rotation, b: entries.1.rotation, t: t)
        )
    }
    
    private func getDataLinearAtTime(_ time: Double) -> TrackingEntry {
        let pair = getIndexPairAtTime(time)
        let entries = (m_entries[pair.0], m_entries[pair.1])
        let t = normalizeTimeAtRange(time: time, start: entries.0.timeStamp, end: entries.1.timeStamp)
        return TrackingEntry(
            timeStamp: time,
            position: linearInterpolation(a: entries.0.position, b: entries.1.position, t: t),
            rotation: linearInterpolation(a: entries.0.rotation, b: entries.1.rotation, t: t)
        )
    }
    
    private func getDataCubicAtTime(_ time: Double) -> TrackingEntry {
        let quad = getIndexQuadAtTime(time)
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
