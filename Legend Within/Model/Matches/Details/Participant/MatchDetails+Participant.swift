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

        var firstThreeItemIds: [Int] {
            [self.stats.item0, self.stats.item1, self.stats.item2]
        }

        var secondThreeItemIds: [Int] {
            [self.stats.item3, self.stats.item4, self.stats.item5]
        }

        var allItems: [Int] {
            [self.stats.item0, self.stats.item1, self.stats.item2, self.stats.item3, self.stats.item4, self.stats.item5, self.stats.item6]
        }

        func primaryRunePath() -> RunePath? {
            return GameData.shared.runePaths[self.stats.perkPrimaryStyle]
        }
        func keyStone() -> Rune? {
            let primaryRunePath = self.primaryRunePath()
            return primaryRunePath?.slots[0].runes.first { $0.id == self.stats.perk0 }
        }
        func primaryRunes() -> [Rune?] {
            let primaryRunePath = self.primaryRunePath()
            let rune1 = primaryRunePath?.slots[1].runes.first { $0.id == self.stats.perk1 }
            let rune2 = primaryRunePath?.slots[2].runes.first { $0.id == self.stats.perk2 }
            let rune3 = primaryRunePath?.slots[3].runes.first { $0.id == self.stats.perk3 }

            return [rune1, rune2, rune3]
        }

        func secondaryRunePath() -> RunePath? {
            return GameData.shared.runePaths[self.stats.perkSubStyle]
        }
        func secondaryRunes() -> [Rune?] {
            let secondaryRunePath = self.secondaryRunePath()
            var endResult = [Rune?]()

            endResult.append(secondaryRunePath?.slots[1].runes.first { $0.id == self.stats.perk4 })
            endResult.append(secondaryRunePath?.slots[1].runes.first { $0.id == self.stats.perk5 })
            endResult.append(secondaryRunePath?.slots[2].runes.first { $0.id == self.stats.perk4 })
            endResult.append(secondaryRunePath?.slots[2].runes.first { $0.id == self.stats.perk5 })
            endResult.append(secondaryRunePath?.slots[3].runes.first { $0.id == self.stats.perk4 })
            endResult.append(secondaryRunePath?.slots[3].runes.first { $0.id == self.stats.perk5 })

            endResult = endResult.filter { $0 != nil }
            return endResult.count == 2 ? endResult : [nil, nil]
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

extension Array where Element == MatchDetails.Participant {
    func sortedByLanes() -> Self {
        self.sorted {
            if $0.timeline.lane.rankedPosition != $1.timeline.lane.rankedPosition {
                return $0.timeline.lane.rankedPosition < $1.timeline.lane.rankedPosition
            }

            return $0.timeline.role.positionId < $1.timeline.role.positionId
        }
    }
}
