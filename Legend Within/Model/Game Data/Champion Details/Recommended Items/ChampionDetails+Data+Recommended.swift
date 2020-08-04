//
//  ChampionDetails+Data+Recommended.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension ChampionDetails.Data {
    final class Recommended: Codable {

        let champion: String
        let title: String
        let map: String
        let mode: String
        let type: String
        let customTag: String?
        let sortrank: Int?
        let extensionPage: Bool?
        let useObviousCheckmark: Bool?
        let customPanel: Any?
        let blocks: [Block]

        private enum CodingKeys: String, CodingKey {
            case champion = "champion"
            case title = "title"
            case map = "map"
            case mode = "mode"
            case type = "type"
            case customTag = "customTag"
            case sortrank = "sortrank"
            case extensionPage = "extensionPage"
            case useObviousCheckmark = "useObviousCheckmark"
            case customPanel = "customPanel"
            case blocks = "blocks"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            champion = try values.decode(String.self, forKey: .champion)
            title = try values.decode(String.self, forKey: .title)
            map = try values.decode(String.self, forKey: .map)
            mode = try values.decode(String.self, forKey: .mode)
            type = try values.decode(String.self, forKey: .type)
            customTag = try values.decodeIfPresent(String.self, forKey: .customTag)
            sortrank = try values.decodeIfPresent(Int.self, forKey: .sortrank)
            extensionPage = try values.decodeIfPresent(Bool.self, forKey: .extensionPage)
            useObviousCheckmark = try values.decodeIfPresent(Bool.self, forKey: .useObviousCheckmark)
            customPanel = nil // TODO: Add code for decoding `customPanel`, It was null at the time of model creation.
            blocks = try values.decode([Block].self, forKey: .blocks)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(champion, forKey: .champion)
            try container.encode(title, forKey: .title)
            try container.encode(map, forKey: .map)
            try container.encode(mode, forKey: .mode)
            try container.encode(type, forKey: .type)
            try container.encodeIfPresent(customTag, forKey: .customTag)
            try container.encodeIfPresent(sortrank, forKey: .sortrank)
            try container.encodeIfPresent(extensionPage, forKey: .extensionPage)
            try container.encodeIfPresent(useObviousCheckmark, forKey: .useObviousCheckmark)
            // TODO: Add code for encoding `customPanel`, It was null at the time of model creation.
            try container.encode(blocks, forKey: .blocks)
        }

    }
}
