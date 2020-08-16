//
//  MatchTimeline+Frame+Event.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchTimeline.Frame {
    struct Event: Codable {
        typealias Position = MatchTimeline.Frame.Position

        let laneType: String?
        let skillSlot: Int?
        let ascendedType: String?
        let creatorId: Int?
        let afterId: Int?
        let eventType: String?
        /*!*/ let type: Kind
        let levelUpType: String?
        let wardType: String?
        let participantId: Int?
        let towerType: String?
        let itemId: Int?
        let beforeId: Int?
        let pointCaptured: String?
        let monsterType: MonsterType?
        let monsterSubType: MonsterSubType?
        let teamId: Int?
        let position: Position?
        let killerId: Int?
        /*!*/ let timestamp: Int
        let assistingParticipantIds: [Int]?
        let buildingType: String?
        let victimId: Int?

        private enum CodingKeys: String, CodingKey {
            case laneType = "laneType"
            case skillSlot = "skillSlot"
            case ascendedType = "ascendedType"
            case creatorId = "creatorId"
            case afterId = "afterId"
            case eventType = "eventType"
            case type = "type"
            case levelUpType = "levelUpType"
            case wardType = "wardType"
            case participantId = "participantId"
            case towerType = "towerType"
            case itemId = "itemId"
            case beforeId = "beforeId"
            case pointCaptured = "pointCaptured"
            case monsterType = "monsterType"
            case monsterSubType = "monsterSubType"
            case teamId = "teamId"
            case position = "position"
            case killerId = "killerId"
            case timestamp = "timestamp"
            case assistingParticipantIds = "assistingParticipantIds"
            case buildingType = "buildingType"
            case victimId = "victimId"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)

            laneType = try values.decodeIfPresent(String.self, forKey: .laneType)
            skillSlot = try values.decodeIfPresent(Int.self, forKey: .skillSlot)
            ascendedType = try values.decodeIfPresent(String.self, forKey: .ascendedType)
            creatorId = try values.decodeIfPresent(Int.self, forKey: .creatorId)
            afterId = try values.decodeIfPresent(Int.self, forKey: .afterId)
            eventType = try values.decodeIfPresent(String.self, forKey: .eventType)
            type = Kind(rawValue: try values.decode(String.self, forKey: .type))!
            levelUpType = try values.decodeIfPresent(String.self, forKey: .levelUpType)
            wardType = try values.decodeIfPresent(String.self, forKey: .wardType)
            participantId = try values.decodeIfPresent(Int.self, forKey: .participantId)
            towerType = try values.decodeIfPresent(String.self, forKey: .towerType)
            itemId = try values.decodeIfPresent(Int.self, forKey: .itemId)
            beforeId = try values.decodeIfPresent(Int.self, forKey: .beforeId)
            pointCaptured = try values.decodeIfPresent(String.self, forKey: .pointCaptured)
            monsterType = MonsterType(rawValue: try values.decodeIfPresent(String.self, forKey: .monsterType) ?? "")
            monsterSubType = MonsterSubType(rawValue: try values.decodeIfPresent(String.self, forKey: .monsterSubType) ?? "")
            teamId = try values.decodeIfPresent(Int.self, forKey: .teamId)
            position = try values.decodeIfPresent(Position.self, forKey: .position)
            killerId = try values.decodeIfPresent(Int.self, forKey: .killerId)
            timestamp = try values.decode(Int.self, forKey: .timestamp)
            assistingParticipantIds = try values.decodeIfPresent([Int].self, forKey: .assistingParticipantIds)
            buildingType = try values.decodeIfPresent(String.self, forKey: .buildingType)
            victimId = try values.decodeIfPresent(Int.self, forKey: .victimId)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(laneType, forKey: .laneType)
            try container.encodeIfPresent(skillSlot, forKey: .skillSlot)
            try container.encodeIfPresent(ascendedType, forKey: .ascendedType)
            try container.encodeIfPresent(creatorId, forKey: .creatorId)
            try container.encodeIfPresent(afterId, forKey: .afterId)
            try container.encodeIfPresent(eventType, forKey: .eventType)
            try container.encode(type.rawValue, forKey: .type)
            try container.encodeIfPresent(levelUpType, forKey: .levelUpType)
            try container.encodeIfPresent(wardType, forKey: .wardType)
            try container.encodeIfPresent(participantId, forKey: .participantId)
            try container.encodeIfPresent(towerType, forKey: .towerType)
            try container.encodeIfPresent(itemId, forKey: .itemId)
            try container.encodeIfPresent(beforeId, forKey: .beforeId)
            try container.encodeIfPresent(pointCaptured, forKey: .pointCaptured)
            try container.encodeIfPresent(monsterType?.rawValue, forKey: .monsterType)
            try container.encodeIfPresent(monsterSubType?.rawValue, forKey: .monsterSubType)
            try container.encodeIfPresent(teamId, forKey: .teamId)
            try container.encodeIfPresent(position, forKey: .position)
            try container.encodeIfPresent(killerId, forKey: .killerId)
            try container.encode(timestamp, forKey: .timestamp)
            try container.encodeIfPresent(assistingParticipantIds, forKey: .assistingParticipantIds)
            try container.encodeIfPresent(buildingType, forKey: .buildingType)
            try container.encodeIfPresent(victimId, forKey: .victimId)
        }

    }
}
