//
//  ChampionDetails+Data.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension ChampionDetails {
    final class Data : Codable {
        let id: String
        let key: String
        let name: String
        let title: String
        let image: Image
        let skins: [Skin]
        let lore: String
        let blurb: String
        let allytips: [String]
        let enemytips: [String]
        let tags: [String]
        let partype: String
        let info: Info
        let stats: Stats
        let spells: [Spell]
        let passive: Passive
        let recommended: [Recommended]

        private enum CodingKeys: String, CodingKey {
            case id = "id"
            case key = "key"
            case name = "name"
            case title = "title"
            case image = "image"
            case skins = "skins"
            case lore = "lore"
            case blurb = "blurb"
            case allytips = "allytips"
            case enemytips = "enemytips"
            case tags = "tags"
            case partype = "partype"
            case info = "info"
            case stats = "stats"
            case spells = "spells"
            case passive = "passive"
            case recommended = "recommended"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(String.self, forKey: .id)
            key = try values.decode(String.self, forKey: .key)
            name = try values.decode(String.self, forKey: .name)
            title = try values.decode(String.self, forKey: .title)
            image = try values.decode(Image.self, forKey: .image)
            skins = try values.decode([Skin].self, forKey: .skins)
            lore = try values.decode(String.self, forKey: .lore)
            blurb = try values.decode(String.self, forKey: .blurb)
            allytips = try values.decode([String].self, forKey: .allytips)
            enemytips = try values.decode([String].self, forKey: .enemytips)
            tags = try values.decode([String].self, forKey: .tags)
            partype = try values.decode(String.self, forKey: .partype)
            info = try values.decode(Info.self, forKey: .info)
            stats = try values.decode(Stats.self, forKey: .stats)
            spells = try values.decode([Spell].self, forKey: .spells)
            passive = try values.decode(Passive.self, forKey: .passive)
            recommended = try values.decode([Recommended].self, forKey: .recommended)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(key, forKey: .key)
            try container.encode(name, forKey: .name)
            try container.encode(title, forKey: .title)
            try container.encode(image, forKey: .image)
            try container.encode(skins, forKey: .skins)
            try container.encode(lore, forKey: .lore)
            try container.encode(blurb, forKey: .blurb)
            try container.encode(allytips, forKey: .allytips)
            try container.encode(enemytips, forKey: .enemytips)
            try container.encode(tags, forKey: .tags)
            try container.encode(partype, forKey: .partype)
            try container.encode(info, forKey: .info)
            try container.encode(stats, forKey: .stats)
            try container.encode(spells, forKey: .spells)
            try container.encode(passive, forKey: .passive)
            try container.encode(recommended, forKey: .recommended)
        }
    }
}
