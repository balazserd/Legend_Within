//
//  MatchDetails+Participant+Timeline.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchDetails.Participant {
    final class Timeline: Codable {
        let participantId: Int
        let creepsPerMinDeltas: [String : Double]?
        let csDiffPerMinDeltas: [String : Double]?
        let damageTakenPerMinDeltas: [String : Double]?
        let damageTakenDiffPerMinDeltas: [String : Double]?
        let xpPerMinDeltas: [String : Double]?
        let xpDiffPerMinDeltas: [String : Double]?
        let goldPerMinDeltas: [String : Double]?
        let role: String
        let lane: String

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
            role = try values.decode(String.self, forKey: .role)
            lane = try values.decode(String.self, forKey: .lane)
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
            try container.encode(role, forKey: .role)
            try container.encode(lane, forKey: .lane)
        }
    }
}
