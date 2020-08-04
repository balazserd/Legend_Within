//
//  ChampionDetails+Data+Recommended+Block.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension ChampionDetails.Data.Recommended {
    final class Block: Codable {

        let type: String
        let recMath: Bool?
        let recSteps: Bool?
        let minSummonerLevel: Int?
        let maxSummonerLevel: Int?
        let showIfSummonerSpell: String?
        let hideIfSummonerSpell: String?
        let appendAfterSection: String?
        let visibleWithAllOf: [String]?
        let hiddenWithAnyOf: [String]?
        let items: [Item]

        private enum CodingKeys: String, CodingKey {
            case type = "type"
            case recMath = "recMath"
            case recSteps = "recSteps"
            case minSummonerLevel = "minSummonerLevel"
            case maxSummonerLevel = "maxSummonerLevel"
            case showIfSummonerSpell = "showIfSummonerSpell"
            case hideIfSummonerSpell = "hideIfSummonerSpell"
            case appendAfterSection = "appendAfterSection"
            case visibleWithAllOf = "visibleWithAllOf"
            case hiddenWithAnyOf = "hiddenWithAnyOf"
            case items = "items"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            type = try values.decode(String.self, forKey: .type)
            recMath = try values.decodeIfPresent(Bool.self, forKey: .recMath)
            recSteps = try values.decodeIfPresent(Bool.self, forKey: .recSteps)
            minSummonerLevel = try values.decodeIfPresent(Int.self, forKey: .minSummonerLevel)
            maxSummonerLevel = try values.decodeIfPresent(Int.self, forKey: .maxSummonerLevel)
            showIfSummonerSpell = try values.decodeIfPresent(String.self, forKey: .showIfSummonerSpell)
            hideIfSummonerSpell = try values.decodeIfPresent(String.self, forKey: .hideIfSummonerSpell)
            appendAfterSection = try values.decodeIfPresent(String.self, forKey: .appendAfterSection)
            visibleWithAllOf = try values.decodeIfPresent([String].self, forKey: .visibleWithAllOf)
            hiddenWithAnyOf = try values.decodeIfPresent([String].self, forKey: .hiddenWithAnyOf)
            items = try values.decode([Item].self, forKey: .items)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encodeIfPresent(recMath, forKey: .recMath)
            try container.encodeIfPresent(recSteps, forKey: .recSteps)
            try container.encodeIfPresent(minSummonerLevel, forKey: .minSummonerLevel)
            try container.encodeIfPresent(maxSummonerLevel, forKey: .maxSummonerLevel)
            try container.encodeIfPresent(showIfSummonerSpell, forKey: .showIfSummonerSpell)
            try container.encodeIfPresent(hideIfSummonerSpell, forKey: .hideIfSummonerSpell)
            try container.encodeIfPresent(appendAfterSection, forKey: .appendAfterSection)
            try container.encodeIfPresent(visibleWithAllOf, forKey: .visibleWithAllOf)
            try container.encodeIfPresent(hiddenWithAnyOf, forKey: .hiddenWithAnyOf)
            try container.encode(items, forKey: .items)
        }

    }
}
