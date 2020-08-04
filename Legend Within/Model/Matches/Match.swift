//
//  Match.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

public final class Match: Codable, ObservableObject {
    let platformId: String
    let gameId: Int
    let champion: Int
    let queue: Int
    let season: Int
    let timestamp: Int
    let role: String
    let lane: String
    @Published var details: MatchDetails?

    func kdaForUser() -> [String : Int] {
        guard
            let user = Summoner.getCurrent(),
            let details = self.details
        else { return [:] }

        let usersParticipantIdentity = details.participantIdentities.first { $0.player.summonerId == user.id }!
        let usersParticipant = details.participants.first { $0.participantId == usersParticipantIdentity.participantId }!
        let kills = usersParticipant.stats.kills
        let deaths = usersParticipant.stats.deaths
        let assists = usersParticipant.stats.assists

        return ["k" : kills, "d" : deaths, "a" : assists]
    }

    func kda(for participant: MatchDetails.Participant) -> [String : Int] {
        let kills = participant.stats.kills
        let deaths = participant.stats.deaths
        let assists = participant.stats.assists

        return ["k" : kills, "d" : deaths, "a" : assists]
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        platformId = try values.decode(String.self, forKey: .platformId)
        gameId = try values.decode(Int.self, forKey: .gameId)
        champion = try values.decode(Int.self, forKey: .champion)
        queue = try values.decode(Int.self, forKey: .queue)
        season = try values.decode(Int.self, forKey: .season)
        timestamp = try values.decode(Int.self, forKey: .timestamp)
        role = try values.decode(String.self, forKey: .role)
        lane = try values.decode(String.self, forKey: .lane)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(platformId, forKey: .platformId)
        try container.encode(gameId, forKey: .gameId)
        try container.encode(champion, forKey: .champion)
        try container.encode(queue, forKey: .queue)
        try container.encode(season, forKey: .season)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(role, forKey: .role)
        try container.encode(lane, forKey: .lane)
    }
}

extension Match {
    private enum CodingKeys: String, CodingKey {
        case platformId = "platformId"
        case gameId = "gameId"
        case champion = "champion"
        case queue = "queue"
        case season = "season"
        case timestamp = "timestamp"
        case role = "role"
        case lane = "lane"
    }
}
