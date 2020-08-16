//
//  MatchTimeline+Frame+ParticipantFrame.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchTimeline.Frame {
    struct ParticipantFrame: Codable {
        typealias Position = MatchTimeline.Frame.Position

        let participantId: Int
        let position: Position?
        let currentGold: Int
        let totalGold: Int
        let level: Int
        let xp: Int
        let minionsKilled: Int
        let jungleMinionsKilled: Int
        let dominionScore: Int?
        let teamScore: Int?

        private enum CodingKeys: String, CodingKey {
            case participantId = "participantId"
            case position = "position"
            case currentGold = "currentGold"
            case totalGold = "totalGold"
            case level = "level"
            case xp = "xp"
            case minionsKilled = "minionsKilled"
            case jungleMinionsKilled = "jungleMinionsKilled"
            case dominionScore = "dominionScore"
            case teamScore = "teamScore"
        }

        init(from decoder: Decoder) throws {
           let values = try decoder.container(keyedBy: CodingKeys.self)
            participantId = try values.decode(Int.self, forKey: .participantId)
            position = try values.decodeIfPresent(Position.self, forKey: .position)
            currentGold = try values.decode(Int.self, forKey: .currentGold)
            totalGold = try values.decode(Int.self, forKey: .totalGold)
            level = try values.decode(Int.self, forKey: .level)
            xp = try values.decode(Int.self, forKey: .xp)
            minionsKilled = try values.decode(Int.self, forKey: .minionsKilled)
            jungleMinionsKilled = try values.decode(Int.self, forKey: .jungleMinionsKilled)
            dominionScore = try values.decodeIfPresent(Int.self, forKey: .dominionScore)
            teamScore = try values.decodeIfPresent(Int.self, forKey: .teamScore)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(participantId, forKey: .participantId)
            try container.encodeIfPresent(position, forKey: .position)
            try container.encode(currentGold, forKey: .currentGold)
            try container.encode(totalGold, forKey: .totalGold)
            try container.encode(level, forKey: .level)
            try container.encode(xp, forKey: .xp)
            try container.encode(minionsKilled, forKey: .minionsKilled)
            try container.encode(jungleMinionsKilled, forKey: .jungleMinionsKilled)
            try container.encodeIfPresent(dominionScore, forKey: .dominionScore)
            try container.encodeIfPresent(teamScore, forKey: .teamScore)
        }

    }
}
