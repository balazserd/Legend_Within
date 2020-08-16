//
//  Match.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

final class Match: Codable, ObservableObject {
    let platformId: String
    let gameId: Int
    let champion: Int
    let queue: Int
    let season: Int
    let timestamp: Int
    let role: String
    let lane: String
    @Published var details: MatchDetails?

    func details(for summoner: Summoner?) -> MatchDetails.Participant? {
        guard
            let summoner = summoner,
            let details = self.details
        else { return nil }

        let usersParticipantIdentity = details.participantIdentities.first { $0.player.summonerId == summoner.id }!
        let usersParticipant = details.participants.first { $0.participantId == usersParticipantIdentity.participantId }!

        return usersParticipant
    }

    //MARK:- Teams and team members
    func team(for participant: MatchDetails.Participant?) -> MatchDetails.Team? {
        if let participant = participant {
            return self.details?.teams.first { $0.teamId == participant.teamId }
        }

        return nil
    }

    var winnerTeam: MatchDetails.Team? {
        return self.details?.teams.first { $0.win == "Win" }
    }

    /* will attempt to return in this order: top - jungle - mid - adc - support */
    var winnerTeamParticipants: [MatchDetails.Participant]? {
        if let winningTeamId = self.winnerTeam?.teamId {
            return self.details?.participants
                .filter { $0.teamId == winningTeamId }
//                .sortedByLanes()
        }
        return nil
    }

    var winnerTeamParticipantIdentities: [MatchDetails.ParticipantIdentity]? {
        if let winningTeamMembers = self.winnerTeamParticipants {
            return self.details?.participantIdentities
                .filter { identity in winningTeamMembers.map { $0.participantId }.contains(identity.participantId) }
                .sorted { $0.participantId < $1.participantId }
        }
        return nil
    }

    var loserTeam: MatchDetails.Team? {
        return self.details?.teams.first { $0.win == "Fail" }
    }

    /* will attempt to return in this order: top - jungle - mid - adc - support */
    var loserTeamParticipants: [MatchDetails.Participant]? {
        if let losingTeamId = self.loserTeam?.teamId {
            return self.details?.participants
                .filter { $0.teamId == losingTeamId }
//                .sortedByLanes()
        }
        return nil
    }

    var loserTeamParticipantIdentities: [MatchDetails.ParticipantIdentity]? {
        if let losingTeamMembers = self.loserTeamParticipants {
            return self.details?.participantIdentities
                .filter { identity in losingTeamMembers.map { $0.participantId }.contains(identity.participantId) }
                .sorted { $0.participantId < $1.participantId }
        }
        return nil
    }

    //MARK:- Codable protocol conformance
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
