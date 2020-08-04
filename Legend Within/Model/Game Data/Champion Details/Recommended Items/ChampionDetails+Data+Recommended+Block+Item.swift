//
//  ChampionDetails+Data+Recommended+Block+Item.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension ChampionDetails.Data.Recommended.Block {
    final class Item: Codable {

        let id: String
        let count: Int
        let hideCount: Bool?

        private enum CodingKeys: String, CodingKey {
            case id = "id"
            case count = "count"
            case hideCount = "hideCount"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(String.self, forKey: .id)
            count = try values.decode(Int.self, forKey: .count)
            hideCount = try values.decodeIfPresent(Bool.self, forKey: .hideCount)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(count, forKey: .count)
            try container.encodeIfPresent(hideCount, forKey: .hideCount)
        }
    }
}
