//
//  ChampionDetails+Data+Skin.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension ChampionDetails.Data {
    final class Skin: Codable {

        let id: String
        let num: Int
        let name: String
        let chromas: Bool

        private enum CodingKeys: String, CodingKey {
            case id = "id"
            case num = "num"
            case name = "name"
            case chromas = "chromas"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(String.self, forKey: .id)
            num = try values.decode(Int.self, forKey: .num)
            name = try values.decode(String.self, forKey: .name)
            chromas = try values.decode(Bool.self, forKey: .chromas)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(num, forKey: .num)
            try container.encode(name, forKey: .name)
            try container.encode(chromas, forKey: .chromas)
        }

    }
}
