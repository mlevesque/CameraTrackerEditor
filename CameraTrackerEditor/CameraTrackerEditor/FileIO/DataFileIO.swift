//
//  DataFileLoader.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/12/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Foundation

enum DataFileIOError: Error {
    case FailedToOpen
    case FailedToDecodeJson
    case FailedToEncodeJson
    case FailedToSave
}

class DataFileIO {
    private let m_url: URL
    
    init(url: URL) {
        m_url = url
    }
    
    func loadDataModelFromFile() throws -> TrackingDataJsonSchema {
        // attempt to open file
        var data: Data
        do {
            let fileHandle = try FileHandle(forReadingFrom: m_url)
            data = fileHandle.readDataToEndOfFile()
        }
        catch {
            throw DataFileIOError.FailedToOpen
        }
        
        // attempt to decode
        let parsedDataOptional = try? JSONDecoder().decode(TrackingDataJsonSchema.self, from: data)
        guard let parsedData = parsedDataOptional else {
            throw DataFileIOError.FailedToDecodeJson
        }
        
        // return the data
        return parsedData
    }
    
    func saveDataModelToFile(url: URL, jsonSchema: TrackingDataJsonSchema) throws {
        // attempt to encode
        var data: Data
        do {
            data = try JSONEncoder().encode(jsonSchema)
        }
        catch {
            throw DataFileIOError.FailedToEncodeJson
        }
        
        // attempt to save
        do {
            let fileHandle = try FileHandle(forWritingTo: url)
            fileHandle.write(data)
            fileHandle.closeFile()
        }
        catch {
            throw DataFileIOError.FailedToSave
        }
    }
}
