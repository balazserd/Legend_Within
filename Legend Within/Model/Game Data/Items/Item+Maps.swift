//
//  Item+Maps.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension Item {
    final class Maps: Codable {

        let summonersRiftCurrent: Bool
        let howlingAbyss: Bool

        private enum CodingKeys: String, CodingKey {
            case summonersRiftCurrent = "11"
            case howlingAbyss = "12"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            summonersRiftCurrent = try values.decode(Bool.self, forKey: .summonersRiftCurrent)
            howlingAbyss = try values.decode(Bool.self, forKey: .howlingAbyss)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(summonersRiftCurrent, forKey: .summonersRiftCurrent)
            try container.encode(howlingAbyss, forKey: .howlingAbyss)
        }
    }
}
