//
//  LeagueEntry.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

//MARK: - Main class declaration
public final class LeagueEntry : Codable {
    public var freshBlood: Bool
    public var hotStreak: Bool
    public var inactive: Bool
    public var leagueId: String
    public var leaguePoints: Int
    public var losses: Int
    public var queueType: QueueType
    public var rank: Rank
    public var summonerId: String
    public var summonerName: String
    public var tier: Tier
    public var veteran: Bool
    public var wins: Int

    public var winRatePercent: Int {
        return Int(Double(wins) / Double(wins + losses) * 100)
    }

    //MARK: - Codable inits
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        freshBlood = try values.decode(Bool.self, forKey: .freshBlood)
        hotStreak = try values.decode(Bool.self, forKey: .hotStreak)
        inactive = try values.decode(Bool.self, forKey: .inactive)
        leagueId = try values.decode(String.self, forKey: .leagueId)
        leaguePoints = try values.decode(Int.self, forKey: .leaguePoints)
        losses = try values.decode(Int.self, forKey: .losses)
        queueType = QueueType.fromNormalizedString(of: try values.decode(String.self, forKey: .queueType))
        rank = Rank.fromNormalizedString(of: try values.decode(String.self, forKey: .rank))
        summonerId = try values.decode(String.self, forKey: .summonerId)
        summonerName = try values.decode(String.self, forKey: .summonerName)
        tier = Tier.fromNormalizedString(of: try values.decode(String.self, forKey: .tier))
        veteran = try values.decode(Bool.self, forKey: .veteran)
        wins = try values.decode(Int.self, forKey: .wins)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.freshBlood, forKey: .freshBlood)
        try container.encode(self.hotStreak, forKey: .hotStreak)
        try container.encode(self.inactive, forKey: .inactive)
        try container.encode(self.leagueId, forKey: .leagueId)
        try container.encode(self.leaguePoints, forKey: .leaguePoints)
        try container.encode(self.losses, forKey: .losses)
        try container.encode(self.queueType.normalizedString, forKey: .queueType)
        try container.encode(self.rank.normalizedString, forKey: .rank)
        try container.encode(self.summonerId, forKey: .summonerId)
        try container.encode(self.summonerName, forKey: .summonerName)
        try container.encode(self.tier.normalizedString, forKey: .tier)
        try container.encode(self.veteran, forKey: .veteran)
        try container.encode(self.wins, forKey: .wins)
    }
}

//MARK: - Queue Types
extension LeagueEntry {
    public enum QueueType : String {
        case rankedSolo
        case rankedFlex
        case other

        static func fromNormalizedString(of string: String) -> QueueType {
            switch string {
                case QueueType.rankedSolo.normalizedString: return self.rankedSolo
                case QueueType.rankedFlex.normalizedString: return self.rankedFlex
                default: return self.other
            }
        }

        var normalizedString: String {
            switch self {
                case .rankedSolo: return "RANKED_SOLO_5x5"
                case .rankedFlex: return "RANKED_FLEX_SR"
                case .other: return "OTHER"
            }
        }
    }
}

//MARK: - Tiers
extension LeagueEntry {
    public enum Tier : String {
        case iron
        case bronze
        case silver
        case gold
        case platinum
        case diamond
        case master
        case grandmaster
        case challenger

        static func fromNormalizedString(of string: String) -> Tier {
            return Tier(rawValue: string.lowercased())!
        }

        var normalizedString: String {
            return self.rawValue.uppercased()
        }
    }
}

//MARK: - Divisions
extension LeagueEntry {
    public enum Rank : String {
        case v
        case iv
        case iii
        case ii
        case i

        static func fromNormalizedString(of string: String) -> Rank {
            return Rank(rawValue: string.lowercased())!
        }

        var normalizedString: String {
            return self.rawValue.uppercased()
        }
    }
}

//MARK: - Positions
extension LeagueEntry {
    public enum Position : String, CaseIterable {
        case top
        case jungle
        case mid
        case bot
        case support

        var normalizedString: String {
            return self.rawValue.localizedCapitalized
        }
    }
}
//MARK: - CodingKeys extension
private extension LeagueEntry {
    enum CodingKeys: String, CodingKey {
        case freshBlood = "freshBlood"
        case hotStreak = "hotStreak"
        case inactive = "inactive"
        case leagueId = "leagueId"
        case leaguePoints = "leaguePoints"
        case losses = "losses"
        case queueType = "queueType"
        case rank = "rank"
        case summonerId = "summonerId"
        case summonerName = "summonerName"
        case tier = "tier"
        case veteran = "veteran"
        case wins = "wins"
    }
}
