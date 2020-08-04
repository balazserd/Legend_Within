//
//  Item+Gold.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension Item {
    final class Gold: Codable {

        let base: Int
        let purchasable: Bool
        let total: Int
        let sell: Int

        private enum CodingKeys: String, CodingKey {
            case base = "base"
            case purchasable = "purchasable"
            case total = "total"
            case sell = "sell"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            base = try values.decode(Int.self, forKey: .base)
            purchasable = try values.decode(Bool.self, forKey: .purchasable)
            total = try values.decode(Int.self, forKey: .total)
            sell = try values.decode(Int.self, forKey: .sell)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base, forKey: .base)
            try container.encode(purchasable, forKey: .purchasable)
            try container.encode(total, forKey: .total)
            try container.encode(sell, forKey: .sell)
        }

    }
}
