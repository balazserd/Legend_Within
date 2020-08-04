//
//  ChampionDetails+Data+Spell+Var.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
extension ChampionDetails.Data.Spell {
    final class Var: Codable {

        let key: String
        let link: String
        let coeff: [Double]

        private enum CodingKeys: String, CodingKey {
            case key = "key"
            case link = "link"
            case coeff = "coeff"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            key = try values.decode(String.self, forKey: .key)
            link = try values.decode(String.self, forKey: .link)
            coeff = ((try? values.decode([Double].self, forKey: .coeff)) ?? [try! values.decode(Double.self, forKey: .coeff)])
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(key, forKey: .key)
            try container.encode(link, forKey: .link)
            try container.encode(coeff, forKey: .coeff)
        }

    }
}
