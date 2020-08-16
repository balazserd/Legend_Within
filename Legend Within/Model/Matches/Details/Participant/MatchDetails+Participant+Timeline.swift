//
//  MatchDetails+Participant+Timeline.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchDetails.Participant {
    struct Timeline: Codable {
        let participantId: Int
        let creepsPerMinDeltas: [String : Double]?
        let csDiffPerMinDeltas: [String : Double]?
        let damageTakenPerMinDeltas: [String : Double]?
        let damageTakenDiffPerMinDeltas: [String : Double]?
        let xpPerMinDeltas: [String : Double]?
        let xpDiffPerMinDeltas: [String : Double]?
        let goldPerMinDeltas: [String : Double]?
        let role: Role
        let lane: Lane

        private enum CodingKeys: String, CodingKey {
            case participantId = "participantId"
            case creepsPerMinDeltas = "creepsPerMinDeltas"
            case csDiffPerMinDeltas = "csDiffPerMinDeltas"
            case xpPerMinDeltas = "xpPerMinDeltas"
            case xpDiffPerMinDeltas = "xpDiffPerMinDeltas"
            case goldPerMinDeltas = "goldPerMinDeltas"
            case damageTakenPerMinDeltas = "damageTakenPerMinDeltas"
            case damageTakenDiffPerMinDeltas = "damageTakenDiffPerMinDeltas"
            case role = "role"
            case lane = "lane"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            participantId = try values.decode(Int.self, forKey: .participantId)
            creepsPerMinDeltas = try values.decodeIfPresent([String : Double].self, forKey: .creepsPerMinDeltas)
            csDiffPerMinDeltas = try values.decodeIfPresent([String : Double].self, forKey: .csDiffPerMinDeltas)
            xpPerMinDeltas = try values.decodeIfPresent([String : Double].self, forKey: .xpPerMinDeltas)
            xpDiffPerMinDeltas = try values.decodeIfPresent([String : Double].self, forKey: .xpDiffPerMinDeltas)
            goldPerMinDeltas = try values.decodeIfPresent([String : Double].self, forKey: .goldPerMinDeltas)
            damageTakenPerMinDeltas = try values.decodeIfPresent([String : Double].self, forKey: .damageTakenPerMinDeltas)
            damageTakenDiffPerMinDeltas = try values.decodeIfPresent([String : Double].self, forKey: .damageTakenDiffPerMinDeltas)
            role = Role(rawValue: try values.decode(String.self, forKey: .role))!
            lane = Lane(rawValue: try values.decode(String.self, forKey: .lane))!
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(participantId, forKey: .participantId)
            try container.encodeIfPresent(creepsPerMinDeltas, forKey: .creepsPerMinDeltas)
            try container.encodeIfPresent(csDiffPerMinDeltas, forKey: .csDiffPerMinDeltas)
            try container.encodeIfPresent(xpPerMinDeltas, forKey: .xpPerMinDeltas)
            try container.encodeIfPresent(xpDiffPerMinDeltas, forKey: .xpDiffPerMinDeltas)
            try container.encodeIfPresent(goldPerMinDeltas, forKey: .goldPerMinDeltas)
            try container.encodeIfPresent(damageTakenPerMinDeltas, forKey: .damageTakenPerMinDeltas)
            try container.encodeIfPresent(damageTakenDiffPerMinDeltas, forKey: .damageTakenDiffPerMinDeltas)
            try container.encode(role.rawValue, forKey: .role)
            try container.encode(lane.rawValue, forKey: .lane)
        }
    }
}

extension MatchDetails.Participant.Timeline {
    enum Lane : String {
        case middle = "MIDDLE"
        case mid = "MID"
        case top = "TOP"
        case bottom = "BOTTOM"
        case bot = "BOT"
        case jungle = "JUNGLE"
        case none = "NONE"

        var rankedPosition: Int {
            switch self {
                case .top: return 1
                case .jungle: return 2
                case .middle, .mid: return 3
                case .bottom, .bot: return 4
                default: return 5
            }
        }
    }

    enum Role : String {
        case duo = "DUO" //duo lane
        case none = "NONE" //should be jungler
        case solo = "SOLO" //solo lane
        case duoCarry = "DUO_CARRY"
        case duoSupport = "DUO_SUPPORT"

        var positionId: Int {
            switch self {
                case .duoCarry: return 1
                case .duoSupport: return 2
                default: return 3
            }
        }
    }
}
