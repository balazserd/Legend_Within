//
//  Champion+Info.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension Champion {
    final class Info: Codable {

        let attack: Int
        let defense: Int
        let magic: Int
        let difficulty: Int

        private enum CodingKeys: String, CodingKey {
            case attack = "attack"
            case defense = "defense"
            case magic = "magic"
            case difficulty = "difficulty"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            attack = try values.decode(Int.self, forKey: .attack)
            defense = try values.decode(Int.self, forKey: .defense)
            magic = try values.decode(Int.self, forKey: .magic)
            difficulty = try values.decode(Int.self, forKey: .difficulty)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(attack, forKey: .attack)
            try container.encode(defense, forKey: .defense)
            try container.encode(magic, forKey: .magic)
            try container.encode(difficulty, forKey: .difficulty)
        }

    }
}
