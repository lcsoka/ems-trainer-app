//
//  Achievement.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 25..
//

import Foundation

struct Achievement: Codable {
    var id: Int
    var className: String
    var createdAt: Date
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case className = "class_name"
        case createdAt = "created_at"
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
        if let cName = try jsonValues.decode(String.self, forKey: .className).split(separator: "\\").last {
            className = String(cName)
        } else {
            className = "ERROR"
        }
        let isoCreatedDate = try jsonValues.decode(String.self, forKey: .createdAt)
        if let realDate = isoDateFormatter.date(from: isoCreatedDate) {
            createdAt = realDate
        } else {
            createdAt = Date()
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        //2021-04-18T21:08:09.000000Z
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let formatted = formatter.string(from: createdAt)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(className, forKey: .className)
        try container.encode(formatted, forKey: .createdAt)
    }
    
}
