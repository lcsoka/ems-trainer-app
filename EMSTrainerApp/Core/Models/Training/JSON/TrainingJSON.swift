//
//  TrainingJSON.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 07..
//

import Foundation

struct TrainingJSON: Codable {
    var id: Int
    var length: Int
    var createdAt: Date
    var trainingMode: String
    var values: [TrainingValueJSON]
    
    enum CodingKeys: String, CodingKey {
        case id, length
        case createdAt = "created_at"
        case trainingMode = "training_mode"
        case trainingValues = "training_values"
    }
    
    enum AdditionalInfoKeys: String, CodingKey {
        case values
    }
    
    init(from decoder: Decoder) throws {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]
        
        let jsonValues = try decoder.container(keyedBy: CodingKeys.self)
        id = try jsonValues.decode(Int.self, forKey: .id)
        length = try jsonValues.decode(Int.self, forKey: .length)
        trainingMode = try jsonValues.decode(String.self, forKey: .trainingMode)
        
        let isoDate = try jsonValues.decode(String.self, forKey: .createdAt)
        if let realDate = isoDateFormatter.date(from: isoDate) {
            createdAt = realDate
        } else {
            createdAt = Date()
        }
        
        do {
            let jsonTrainingValues = try jsonValues.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .trainingValues)
            let trainingValuesString = try jsonTrainingValues.decode(String.self, forKey: .values)
            values = try JSONDecoder().decode([TrainingValueJSON].self, from: trainingValuesString.data(using: .utf8)!)
        } catch {
            values = []
        }
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(length, forKey: .length)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(trainingMode, forKey: .trainingMode)
        
        var additionalInfo = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .trainingValues)
        try additionalInfo.encode(values, forKey: .values)
    }
}
