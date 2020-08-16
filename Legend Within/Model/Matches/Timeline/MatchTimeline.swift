//
//  MatchTimeline.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

struct MatchTimeline: Codable {

    let frames: [Frame]
    let frameInterval: Int

    func getEvents(for participant: MatchDetails.Participant? = nil, typed type: Frame.Event.Kind? = nil) -> [Frame.Event] {
        var events = [Frame.Event]()

        for frame in frames {
            for event in frame.events {
                if (participant == nil || event.participantId == participant!.participantId)
                    && (type == nil || event.type == type!) {
                    events.append(event)
                }
            }
        }

        return events
    }

    private enum CodingKeys: String, CodingKey {
        case frames = "frames"
        case frameInterval = "frameInterval"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        frames = try values.decode([Frame].self, forKey: .frames)
        frameInterval = try values.decode(Int.self, forKey: .frameInterval)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(frames, forKey: .frames)
        try container.encode(frameInterval, forKey: .frameInterval)
    }

}
