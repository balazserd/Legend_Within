//
//  MatchHistory.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Combine

struct MatchHistory : Codable {
    var matches: [Match]
    let startIndex: Int
    let endIndex: Int
    let totalGames: Int

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        matches = try values.decode([Match].self, forKey: .matches)
        startIndex = try values.decode(Int.self, forKey: .startIndex)
        endIndex = try values.decode(Int.self, forKey: .endIndex)
        totalGames = try values.decode(Int.self, forKey: .totalGames)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(matches, forKey: .matches)
        try container.encode(startIndex, forKey: .startIndex)
        try container.encode(endIndex, forKey: .endIndex)
        try container.encode(totalGames, forKey: .totalGames)
    }
}

extension MatchHistory {
    private enum CodingKeys: String, CodingKey {
        case matches = "matches"
        case startIndex = "startIndex"
        case endIndex = "endIndex"
        case totalGames = "totalGames"
    }
}
