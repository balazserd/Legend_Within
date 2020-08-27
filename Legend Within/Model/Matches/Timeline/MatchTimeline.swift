//
//  MatchTimeline.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

struct MatchTimeline: Codable {

    //MARK:- properties
    let frames: [Frame]
    let frameInterval: Int

    //MARK:- public functions
    func getGoldValues() -> [Int : [Int : Int]] { //[ParticipantId : [TimeStamp : Gold]]
        var result = Dictionary<Int, Dictionary<Int, Int>>(uniqueKeysWithValues: (1...10).map { ($0, [:]) })

        let participantFrames = self.getParticipantFrames()
        for pf in participantFrames {
            for frameUnit in pf.value {
                result[frameUnit.participantId]![pf.key] = frameUnit.totalGold
            }
        }

        return result
    }

    //MARK:- private functions

    private func getEvents(for participant: MatchDetails.Participant? = nil, typed type: Frame.Event.Kind? = nil) -> [Frame.Event] {
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

    private func getParticipantFrames(for participant: MatchDetails.Participant? = nil) -> [Int : [Frame.ParticipantFrame]] {
        let minuteCount = self.frames.map { Int($0.timestamp / 60000) }.max()!
        var participantFrames = Dictionary<Int, [Frame.ParticipantFrame]>(uniqueKeysWithValues: (0...minuteCount).map { ($0, []) })

        for frame in frames {
            for participantFrame in frame.participantFrames {
                if (participant == nil || participantFrame.key == participant!.participantId) {
                    participantFrames[Int(frame.timestamp / 60000)]!.append(participantFrame.value)
                }
            }
        }

        return participantFrames
    }

    //MARK:- Codable

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

extension MatchTimeline {
    enum TimelineStatType {
        case gold
        case minions
        case damage

    }
}
