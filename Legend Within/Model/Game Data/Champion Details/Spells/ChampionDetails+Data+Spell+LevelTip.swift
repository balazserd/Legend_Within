//
//  ChampionDetails+Data+Spell+LevelTip.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension ChampionDetails.Data.Spell {
    final class LevelTip: Codable {

        let label: [String]
        let effect: [String]

        private enum CodingKeys: String, CodingKey {
            case label = "label"
            case effect = "effect"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            label = try values.decode([String].self, forKey: .label)
            effect = try values.decode([String].self, forKey: .effect)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(label, forKey: .label)
            try container.encode(effect, forKey: .effect)
        }

    }
}
