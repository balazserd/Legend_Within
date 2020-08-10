//
//  SummonerSpell+Image.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 10..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
extension SummonerSpell {
    struct Image: Codable {

        let full: String
        let sprite: String
        let group: String
        let x: Int
        let y: Int
        let w: Int
        let h: Int

        private enum CodingKeys: String, CodingKey {
            case full = "full"
            case sprite = "sprite"
            case group = "group"
            case x = "x"
            case y = "y"
            case w = "w"
            case h = "h"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            full = try values.decode(String.self, forKey: .full)
            sprite = try values.decode(String.self, forKey: .sprite)
            group = try values.decode(String.self, forKey: .group)
            x = try values.decode(Int.self, forKey: .x)
            y = try values.decode(Int.self, forKey: .y)
            w = try values.decode(Int.self, forKey: .w)
            h = try values.decode(Int.self, forKey: .h)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(full, forKey: .full)
            try container.encode(sprite, forKey: .sprite)
            try container.encode(group, forKey: .group)
            try container.encode(x, forKey: .x)
            try container.encode(y, forKey: .y)
            try container.encode(w, forKey: .w)
            try container.encode(h, forKey: .h)
        }

    }
}
