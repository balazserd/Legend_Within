//
//  MatchDetails+Participant.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchDetails {
    struct Participant: Codable {
        let participantId: Int
        let teamId: Int
        let championId: Int
        let spell1Id: Int
        let spell2Id: Int
        var stats: Stats
        let timeline: Timeline

        private enum CodingKeys: String, CodingKey {
            case participantId = "participantId"
            case teamId = "teamId"
            case championId = "championId"
            case spell1Id = "spell1Id"
            case spell2Id = "spell2Id"
            case stats = "stats"
            case timeline = "timeline"
        }

        var firstThreeItemIds: [Int?] {
            [self.stats.item0, self.stats.item1, self.stats.item2]
        }

        var secondThreeItemIds: [Int?] {
            [self.stats.item3, self.stats.item4, self.stats.item5]
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            participantId = try values.decode(Int.self, forKey: .participantId)
            teamId = try values.decode(Int.self, forKey: .teamId)
            championId = try values.decode(Int.self, forKey: .championId)
            spell1Id = try values.decode(Int.self, forKey: .spell1Id)
            spell2Id = try values.decode(Int.self, forKey: .spell2Id)
            stats = try values.decode(Stats.self, forKey: .stats)
            timeline = try values.decode(Timeline.self, forKey: .timeline)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(participantId, forKey: .participantId)
            try container.encode(teamId, forKey: .teamId)
            try container.encode(championId, forKey: .championId)
            try container.encode(spell1Id, forKey: .spell1Id)
            try container.encode(spell2Id, forKey: .spell2Id)
            try container.encode(stats, forKey: .stats)
            try container.encode(timeline, forKey: .timeline)
        }
    }
}
