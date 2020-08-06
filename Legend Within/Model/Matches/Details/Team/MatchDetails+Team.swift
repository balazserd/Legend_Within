//
//  MatchDetails+Team.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchDetails {
    struct Team: Codable {

        let teamId: Int
        let win: String
        let firstBlood: Bool
        let firstTower: Bool
        let firstInhibitor: Bool
        let firstBaron: Bool
        let firstDragon: Bool
        let firstRiftHerald: Bool
        let towerKills: Int
        let inhibitorKills: Int
        let baronKills: Int
        let dragonKills: Int
        let vilemawKills: Int
        let riftHeraldKills: Int
        let dominionVictoryScore: Int
        let bans: [Ban]

        private enum CodingKeys: String, CodingKey {
            case teamId = "teamId"
            case win = "win"
            case firstBlood = "firstBlood"
            case firstTower = "firstTower"
            case firstInhibitor = "firstInhibitor"
            case firstBaron = "firstBaron"
            case firstDragon = "firstDragon"
            case firstRiftHerald = "firstRiftHerald"
            case towerKills = "towerKills"
            case inhibitorKills = "inhibitorKills"
            case baronKills = "baronKills"
            case dragonKills = "dragonKills"
            case vilemawKills = "vilemawKills"
            case riftHeraldKills = "riftHeraldKills"
            case dominionVictoryScore = "dominionVictoryScore"
            case bans = "bans"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            teamId = try values.decode(Int.self, forKey: .teamId)
            win = try values.decode(String.self, forKey: .win)
            firstBlood = try values.decode(Bool.self, forKey: .firstBlood)
            firstTower = try values.decode(Bool.self, forKey: .firstTower)
            firstInhibitor = try values.decode(Bool.self, forKey: .firstInhibitor)
            firstBaron = try values.decode(Bool.self, forKey: .firstBaron)
            firstDragon = try values.decode(Bool.self, forKey: .firstDragon)
            firstRiftHerald = try values.decode(Bool.self, forKey: .firstRiftHerald)
            towerKills = try values.decode(Int.self, forKey: .towerKills)
            inhibitorKills = try values.decode(Int.self, forKey: .inhibitorKills)
            baronKills = try values.decode(Int.self, forKey: .baronKills)
            dragonKills = try values.decode(Int.self, forKey: .dragonKills)
            vilemawKills = try values.decode(Int.self, forKey: .vilemawKills)
            riftHeraldKills = try values.decode(Int.self, forKey: .riftHeraldKills)
            dominionVictoryScore = try values.decode(Int.self, forKey: .dominionVictoryScore)
            bans = try values.decode([Ban].self, forKey: .bans)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(teamId, forKey: .teamId)
            try container.encode(win, forKey: .win)
            try container.encode(firstBlood, forKey: .firstBlood)
            try container.encode(firstTower, forKey: .firstTower)
            try container.encode(firstInhibitor, forKey: .firstInhibitor)
            try container.encode(firstBaron, forKey: .firstBaron)
            try container.encode(firstDragon, forKey: .firstDragon)
            try container.encode(firstRiftHerald, forKey: .firstRiftHerald)
            try container.encode(towerKills, forKey: .towerKills)
            try container.encode(inhibitorKills, forKey: .inhibitorKills)
            try container.encode(baronKills, forKey: .baronKills)
            try container.encode(dragonKills, forKey: .dragonKills)
            try container.encode(vilemawKills, forKey: .vilemawKills)
            try container.encode(riftHeraldKills, forKey: .riftHeraldKills)
            try container.encode(dominionVictoryScore, forKey: .dominionVictoryScore)
            try container.encode(bans, forKey: .bans)
        }
    }
}

