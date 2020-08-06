//
//  MatchDetails+ParticipantIdentity.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchDetails {
    struct ParticipantIdentity: Codable {
        let participantId: Int
        let player: Player

        private enum CodingKeys: String, CodingKey {
            case participantId = "participantId"
            case player = "player"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            participantId = try values.decode(Int.self, forKey: .participantId)
            player = try values.decode(Player.self, forKey: .player)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(participantId, forKey: .participantId)
            try container.encode(player, forKey: .player)
        }
    }
}
