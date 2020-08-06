//
//  Queue.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 06..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

struct Queue: Codable {

    let queueId: Int
    let map: String
    let description: String?
    let notes: String?

    private enum CodingKeys: String, CodingKey {
        case queueId = "queueId"
        case map = "map"
        case description = "description"
        case notes = "notes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        queueId = try values.decode(Int.self, forKey: .queueId)
        map = try values.decode(String.self, forKey: .map)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        notes = try values.decodeIfPresent(String.self, forKey: .notes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(queueId, forKey: .queueId)
        try container.encode(map, forKey: .map)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(notes, forKey: .notes)
    }

}
