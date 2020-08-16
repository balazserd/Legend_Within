//
//  MatchTimeline+Frame.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchTimeline {
    struct Frame: Codable {

        let participantFrames: [Int : ParticipantFrame]
        let events: [Event]
        let timestamp: Int

        private enum CodingKeys: String, CodingKey {
            case participantFrames = "participantFrames"
            case events = "events"
            case timestamp = "timestamp"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            participantFrames = try values.decode([Int : ParticipantFrame].self, forKey: .participantFrames)
            events = try values.decode([Event].self, forKey: .events)
            timestamp = try values.decode(Int.self, forKey: .timestamp)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(participantFrames, forKey: .participantFrames)
            try container.encode(events, forKey: .events)
            try container.encode(timestamp, forKey: .timestamp)
        }

    }
}
