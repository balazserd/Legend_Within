//
//  MatchDetails.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

final class MatchDetails: Codable {

    let gameId: Int
    let platformId: String
    let gameCreation: Int
    let gameDuration: Int
    let queueId: Int
    let mapId: Int
    let seasonId: Int
    let gameVersion: String
    let gameMode: String
    let gameType: String
    let teams: [Team]
    let participants: [Participant]
    let participantIdentities: [ParticipantIdentity]

    class func getPeriodStringRepresentation(lowerEndOfMinutesOfTens: Int) -> String {
        let lowerEndOfMinutesOfTensCorrectedJustToBeSure = lowerEndOfMinutesOfTens - (lowerEndOfMinutesOfTens % 10)
        return "\(lowerEndOfMinutesOfTensCorrectedJustToBeSure)-\(lowerEndOfMinutesOfTensCorrectedJustToBeSure + 10)"
    }

    private enum CodingKeys: String, CodingKey {
        case gameId = "gameId"
        case platformId = "platformId"
        case gameCreation = "gameCreation"
        case gameDuration = "gameDuration"
        case queueId = "queueId"
        case mapId = "mapId"
        case seasonId = "seasonId"
        case gameVersion = "gameVersion"
        case gameMode = "gameMode"
        case gameType = "gameType"
        case teams = "teams"
        case participants = "participants"
        case participantIdentities = "participantIdentities"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameId = try values.decode(Int.self, forKey: .gameId)
        platformId = try values.decode(String.self, forKey: .platformId)
        gameCreation = try values.decode(Int.self, forKey: .gameCreation)
        gameDuration = try values.decode(Int.self, forKey: .gameDuration)
        queueId = try values.decode(Int.self, forKey: .queueId)
        mapId = try values.decode(Int.self, forKey: .mapId)
        seasonId = try values.decode(Int.self, forKey: .seasonId)
        gameVersion = try values.decode(String.self, forKey: .gameVersion)
        gameMode = try values.decode(String.self, forKey: .gameMode)
        gameType = try values.decode(String.self, forKey: .gameType)
        teams = try values.decode([Team].self, forKey: .teams)
        participants = try values.decode([Participant].self, forKey: .participants)
        participantIdentities = try values.decode([ParticipantIdentity].self, forKey: .participantIdentities)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gameId, forKey: .gameId)
        try container.encode(platformId, forKey: .platformId)
        try container.encode(gameCreation, forKey: .gameCreation)
        try container.encode(gameDuration, forKey: .gameDuration)
        try container.encode(queueId, forKey: .queueId)
        try container.encode(mapId, forKey: .mapId)
        try container.encode(seasonId, forKey: .seasonId)
        try container.encode(gameVersion, forKey: .gameVersion)
        try container.encode(gameMode, forKey: .gameMode)
        try container.encode(gameType, forKey: .gameType)
        try container.encode(teams, forKey: .teams)
        try container.encode(participants, forKey: .participants)
        try container.encode(participantIdentities, forKey: .participantIdentities)
    }
}
