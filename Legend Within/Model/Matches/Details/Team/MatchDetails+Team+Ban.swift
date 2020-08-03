//
//  MatchDetails+Team+Ban.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

final class Ban: Codable {
    let championId: Int
    let pickTurn: Int

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        championId = try values.decode(Int.self, forKey: .championId)
        pickTurn = try values.decode(Int.self, forKey: .pickTurn)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(championId, forKey: .championId)
        try container.encode(pickTurn, forKey: .pickTurn)
    }
}

extension Ban {
    private enum CodingKeys: String, CodingKey {
        case championId = "championId"
        case pickTurn = "pickTurn"
    }
}
