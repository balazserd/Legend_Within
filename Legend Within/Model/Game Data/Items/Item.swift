//
//  Item.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

final class Item: Codable {

    let name: String
    let description: String
    let colloq: String
    let plaintext: String
    let from: [String]?
    let image: Image
    let gold: Gold
    let tags: [String]
    let maps: Maps
    let stats: Stats
    let depth: Int?

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case colloq = "colloq"
        case plaintext = "plaintext"
        case from = "from"
        case image = "image"
        case gold = "gold"
        case tags = "tags"
        case maps = "maps"
        case stats = "stats"
        case depth = "depth"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        colloq = try values.decode(String.self, forKey: .colloq)
        plaintext = try values.decode(String.self, forKey: .plaintext)
        from = try values.decodeIfPresent([String].self, forKey: .from)
        image = try values.decode(Image.self, forKey: .image)
        gold = try values.decode(Gold.self, forKey: .gold)
        tags = try values.decode([String].self, forKey: .tags)
        maps = try values.decode(Maps.self, forKey: .maps)
        stats = try values.decode(Stats.self, forKey: .stats)
        depth = try values.decodeIfPresent(Int.self, forKey: .depth)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(colloq, forKey: .colloq)
        try container.encode(plaintext, forKey: .plaintext)
        try container.encodeIfPresent(from, forKey: .from)
        try container.encode(image, forKey: .image)
        try container.encode(gold, forKey: .gold)
        try container.encode(tags, forKey: .tags)
        try container.encode(maps, forKey: .maps)
        try container.encode(stats, forKey: .stats)
        try container.encodeIfPresent(depth, forKey: .depth)
    }

}
