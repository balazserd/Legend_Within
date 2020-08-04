//
//  ItemsJSON.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

final class ItemsJSON : Codable {
    let type: String
    let version: String
    let data: [String : Item]

    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case format = "format"
        case version = "version"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        version = try values.decode(String.self, forKey: .version)
        data = try values.decode([String : Item].self, forKey: .data)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(version, forKey: .version)
        try container.encode(data, forKey: .data)
    }
}
