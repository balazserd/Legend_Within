//
//  League.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

public final class League: Codable {

    let tier: String
    let leagueId: String
    let queue: String
    let name: String
    let entries: [Entry]

    private enum CodingKeys: String, CodingKey {
        case tier = "tier"
        case leagueId = "leagueId"
        case queue = "queue"
        case name = "name"
        case entries = "entries"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tier = try values.decode(String.self, forKey: .tier)
        leagueId = try values.decode(String.self, forKey: .leagueId)
        queue = try values.decode(String.self, forKey: .queue)
        name = try values.decode(String.self, forKey: .name)
        entries = try values.decode([Entry].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tier, forKey: .tier)
        try container.encode(leagueId, forKey: .leagueId)
        try container.encode(queue, forKey: .queue)
        try container.encode(name, forKey: .name)
        try container.encode(entries, forKey: .entries)
    }

    public final class Entry: Codable {

        let summonerId: String
        let summonerName: String
        let leaguePoints: Int
        let rank: String
        let wins: Int
        let losses: Int
        let veteran: Bool
        let inactive: Bool
        let freshBlood: Bool
        let hotStreak: Bool

        private enum CodingKeys: String, CodingKey {
            case summonerId = "summonerId"
            case summonerName = "summonerName"
            case leaguePoints = "leaguePoints"
            case rank = "rank"
            case wins = "wins"
            case losses = "losses"
            case veteran = "veteran"
            case inactive = "inactive"
            case freshBlood = "freshBlood"
            case hotStreak = "hotStreak"
        }

        public required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            summonerId = try values.decode(String.self, forKey: .summonerId)
            summonerName = try values.decode(String.self, forKey: .summonerName)
            leaguePoints = try values.decode(Int.self, forKey: .leaguePoints)
            rank = try values.decode(String.self, forKey: .rank)
            wins = try values.decode(Int.self, forKey: .wins)
            losses = try values.decode(Int.self, forKey: .losses)
            veteran = try values.decode(Bool.self, forKey: .veteran)
            inactive = try values.decode(Bool.self, forKey: .inactive)
            freshBlood = try values.decode(Bool.self, forKey: .freshBlood)
            hotStreak = try values.decode(Bool.self, forKey: .hotStreak)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(summonerId, forKey: .summonerId)
            try container.encode(summonerName, forKey: .summonerName)
            try container.encode(leaguePoints, forKey: .leaguePoints)
            try container.encode(rank, forKey: .rank)
            try container.encode(wins, forKey: .wins)
            try container.encode(losses, forKey: .losses)
            try container.encode(veteran, forKey: .veteran)
            try container.encode(inactive, forKey: .inactive)
            try container.encode(freshBlood, forKey: .freshBlood)
            try container.encode(hotStreak, forKey: .hotStreak)
        }
    }
}
