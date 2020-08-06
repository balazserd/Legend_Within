//
//  Map.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 06..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

struct Map: Codable {

    let mapId: Int
    let mapName: String
    let notes: String

    private enum CodingKeys: String, CodingKey {
        case mapId = "mapId"
        case mapName = "mapName"
        case notes = "notes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mapId = try values.decode(Int.self, forKey: .mapId)
        mapName = try values.decode(String.self, forKey: .mapName)
        notes = try values.decode(String.self, forKey: .notes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mapId, forKey: .mapId)
        try container.encode(mapName, forKey: .mapName)
        try container.encode(notes, forKey: .notes)
    }

}
