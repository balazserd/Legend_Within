//
//  RunePath.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 06..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

struct RunePath: Codable {

    let id: Int
    let key: String
    let icon: String
    let name: String
    let slots: [Slot]

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case key = "key"
        case icon = "icon"
        case name = "name"
        case slots = "slots"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        key = try values.decode(String.self, forKey: .key)
        icon = try values.decode(String.self, forKey: .icon)
        name = try values.decode(String.self, forKey: .name)
        slots = try values.decode([Slot].self, forKey: .slots)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(key, forKey: .key)
        try container.encode(icon, forKey: .icon)
        try container.encode(name, forKey: .name)
        try container.encode(slots, forKey: .slots)
    }

}
