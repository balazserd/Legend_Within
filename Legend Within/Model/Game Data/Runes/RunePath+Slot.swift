//
//  RunePath+Slot.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 06..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

struct Slot: Codable {

    let runes: [Rune]

    private enum CodingKeys: String, CodingKey {
        case runes = "runes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        runes = try values.decode([Rune].self, forKey: .runes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(runes, forKey: .runes)
    }

}
