//
//  MatchDetails+Participant+Stats.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchDetails.Participant {
    struct Stats: Codable {
        let participantId: Int
        let win: Bool
        var item0: Int
        var item1: Int
        var item2: Int
        var item3: Int
        var item4: Int
        var item5: Int
        var item6: Int
        let kills: Int
        let deaths: Int
        let assists: Int
        let largestKillingSpree: Int
        let largestMultiKill: Int
        let killingSprees: Int
        let longestTimeSpentLiving: Int?
        let doubleKills: Int
        let tripleKills: Int
        let quadraKills: Int
        let pentaKills: Int
        let unrealKills: Int
        let totalDamageDealt: Int
        let magicDamageDealt: Int
        let physicalDamageDealt: Int
        let trueDamageDealt: Int
        let largestCriticalStrike: Int
        let totalDamageDealtToChampions: Int
        let magicDamageDealtToChampions: Int
        let physicalDamageDealtToChampions: Int
        let trueDamageDealtToChampions: Int
        let totalHeal: Int
        let totalUnitsHealed: Int
        let damageSelfMitigated: Int
        let damageDealtToObjectives: Int
        let damageDealtToTurrets: Int
        let visionScore: Int?
        let timeCCingOthers: Int
        let totalDamageTaken: Int
        let magicalDamageTaken: Int
        let physicalDamageTaken: Int
        let trueDamageTaken: Int
        let goldEarned: Int
        let goldSpent: Int
        let turretKills: Int
        let inhibitorKills: Int
        let totalMinionsKilled: Int
        let neutralMinionsKilled: Int?
        let neutralMinionsKilledTeamJungle: Int?
        let neutralMinionsKilledEnemyJungle: Int?
        let totalTimeCrowdControlDealt: Int
        let champLevel: Int
        let visionWardsBoughtInGame: Int?
        let sightWardsBoughtInGame: Int?
        let wardsPlaced: Int?
        let wardsKilled: Int?
        let firstBloodKill: Bool?
        let firstBloodAssist: Bool?
        let firstTowerKill: Bool?
        let firstTowerAssist: Bool?
        let firstInhibitorKill: Bool?
        let firstInhibitorAssist: Bool?
        let combatPlayerScore: Int
        let objectivePlayerScore: Int
        let totalPlayerScore: Int
        let totalScoreRank: Int
        let playerScore0: Int?
        let playerScore1: Int?
        let playerScore2: Int?
        let playerScore3: Int?
        let playerScore4: Int?
        let playerScore5: Int?
        let playerScore6: Int?
        let playerScore7: Int?
        let playerScore8: Int?
        let playerScore9: Int?
        let perk0: Int
        let perk0Var1: Int
        let perk0Var2: Int
        let perk0Var3: Int
        let perk1: Int
        let perk1Var1: Int
        let perk1Var2: Int
        let perk1Var3: Int
        let perk2: Int
        let perk2Var1: Int
        let perk2Var2: Int
        let perk2Var3: Int
        let perk3: Int
        let perk3Var1: Int
        let perk3Var2: Int
        let perk3Var3: Int
        let perk4: Int
        let perk4Var1: Int
        let perk4Var2: Int
        let perk4Var3: Int
        let perk5: Int
        let perk5Var1: Int
        let perk5Var2: Int
        let perk5Var3: Int
        let perkPrimaryStyle: Int
        let perkSubStyle: Int
        let statPerk0: Int
        let statPerk1: Int
        let statPerk2: Int

        private enum CodingKeys: String, CodingKey {
            case participantId = "participantId"
            case win = "win"
            case item0 = "item0"
            case item1 = "item1"
            case item2 = "item2"
            case item3 = "item3"
            case item4 = "item4"
            case item5 = "item5"
            case item6 = "item6"
            case kills = "kills"
            case deaths = "deaths"
            case assists = "assists"
            case largestKillingSpree = "largestKillingSpree"
            case largestMultiKill = "largestMultiKill"
            case killingSprees = "killingSprees"
            case longestTimeSpentLiving = "longestTimeSpentLiving"
            case doubleKills = "doubleKills"
            case tripleKills = "tripleKills"
            case quadraKills = "quadraKills"
            case pentaKills = "pentaKills"
            case unrealKills = "unrealKills"
            case totalDamageDealt = "totalDamageDealt"
            case magicDamageDealt = "magicDamageDealt"
            case physicalDamageDealt = "physicalDamageDealt"
            case trueDamageDealt = "trueDamageDealt"
            case largestCriticalStrike = "largestCriticalStrike"
            case totalDamageDealtToChampions = "totalDamageDealtToChampions"
            case magicDamageDealtToChampions = "magicDamageDealtToChampions"
            case physicalDamageDealtToChampions = "physicalDamageDealtToChampions"
            case trueDamageDealtToChampions = "trueDamageDealtToChampions"
            case totalHeal = "totalHeal"
            case totalUnitsHealed = "totalUnitsHealed"
            case damageSelfMitigated = "damageSelfMitigated"
            case damageDealtToObjectives = "damageDealtToObjectives"
            case damageDealtToTurrets = "damageDealtToTurrets"
            case visionScore = "visionScore"
            case timeCCingOthers = "timeCCingOthers"
            case totalDamageTaken = "totalDamageTaken"
            case magicalDamageTaken = "magicalDamageTaken"
            case physicalDamageTaken = "physicalDamageTaken"
            case trueDamageTaken = "trueDamageTaken"
            case goldEarned = "goldEarned"
            case goldSpent = "goldSpent"
            case turretKills = "turretKills"
            case inhibitorKills = "inhibitorKills"
            case totalMinionsKilled = "totalMinionsKilled"
            case neutralMinionsKilled = "neutralMinionsKilled"
            case neutralMinionsKilledTeamJungle = "neutralMinionsKilledTeamJungle"
            case neutralMinionsKilledEnemyJungle = "neutralMinionsKilledEnemyJungle"
            case totalTimeCrowdControlDealt = "totalTimeCrowdControlDealt"
            case champLevel = "champLevel"
            case visionWardsBoughtInGame = "visionWardsBoughtInGame"
            case sightWardsBoughtInGame = "sightWardsBoughtInGame"
            case wardsPlaced = "wardsPlaced"
            case wardsKilled = "wardsKilled"
            case firstBloodKill = "firstBloodKill"
            case firstBloodAssist = "firstBloodAssist"
            case firstTowerKill = "firstTowerKill"
            case firstTowerAssist = "firstTowerAssist"
            case firstInhibitorKill = "firstInhibitorKill"
            case firstInhibitorAssist = "firstInhibitorAssist"
            case combatPlayerScore = "combatPlayerScore"
            case objectivePlayerScore = "objectivePlayerScore"
            case totalPlayerScore = "totalPlayerScore"
            case totalScoreRank = "totalScoreRank"
            case playerScore0 = "playerScore0"
            case playerScore1 = "playerScore1"
            case playerScore2 = "playerScore2"
            case playerScore3 = "playerScore3"
            case playerScore4 = "playerScore4"
            case playerScore5 = "playerScore5"
            case playerScore6 = "playerScore6"
            case playerScore7 = "playerScore7"
            case playerScore8 = "playerScore8"
            case playerScore9 = "playerScore9"
            case perk0 = "perk0"
            case perk0Var1 = "perk0Var1"
            case perk0Var2 = "perk0Var2"
            case perk0Var3 = "perk0Var3"
            case perk1 = "perk1"
            case perk1Var1 = "perk1Var1"
            case perk1Var2 = "perk1Var2"
            case perk1Var3 = "perk1Var3"
            case perk2 = "perk2"
            case perk2Var1 = "perk2Var1"
            case perk2Var2 = "perk2Var2"
            case perk2Var3 = "perk2Var3"
            case perk3 = "perk3"
            case perk3Var1 = "perk3Var1"
            case perk3Var2 = "perk3Var2"
            case perk3Var3 = "perk3Var3"
            case perk4 = "perk4"
            case perk4Var1 = "perk4Var1"
            case perk4Var2 = "perk4Var2"
            case perk4Var3 = "perk4Var3"
            case perk5 = "perk5"
            case perk5Var1 = "perk5Var1"
            case perk5Var2 = "perk5Var2"
            case perk5Var3 = "perk5Var3"
            case perkPrimaryStyle = "perkPrimaryStyle"
            case perkSubStyle = "perkSubStyle"
            case statPerk0 = "statPerk0"
            case statPerk1 = "statPerk1"
            case statPerk2 = "statPerk2"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            participantId = try values.decode(Int.self, forKey: .participantId)
            win = try values.decode(Bool.self, forKey: .win)
            item0 = try values.decode(Int.self, forKey: .item0)
            item1 = try values.decode(Int.self, forKey: .item1)
            item2 = try values.decode(Int.self, forKey: .item2)
            item3 = try values.decode(Int.self, forKey: .item3)
            item4 = try values.decode(Int.self, forKey: .item4)
            item5 = try values.decode(Int.self, forKey: .item5)
            item6 = try values.decode(Int.self, forKey: .item6)
            kills = try values.decode(Int.self, forKey: .kills)
            deaths = try values.decode(Int.self, forKey: .deaths)
            assists = try values.decode(Int.self, forKey: .assists)
            largestKillingSpree = try values.decode(Int.self, forKey: .largestKillingSpree)
            largestMultiKill = try values.decode(Int.self, forKey: .largestMultiKill)
            killingSprees = try values.decode(Int.self, forKey: .killingSprees)
            longestTimeSpentLiving = try values.decodeIfPresent(Int.self, forKey: .longestTimeSpentLiving)
            doubleKills = try values.decode(Int.self, forKey: .doubleKills)
            tripleKills = try values.decode(Int.self, forKey: .tripleKills)
            quadraKills = try values.decode(Int.self, forKey: .quadraKills)
            pentaKills = try values.decode(Int.self, forKey: .pentaKills)
            unrealKills = try values.decode(Int.self, forKey: .unrealKills)
            totalDamageDealt = try values.decode(Int.self, forKey: .totalDamageDealt)
            magicDamageDealt = try values.decode(Int.self, forKey: .magicDamageDealt)
            physicalDamageDealt = try values.decode(Int.self, forKey: .physicalDamageDealt)
            trueDamageDealt = try values.decode(Int.self, forKey: .trueDamageDealt)
            largestCriticalStrike = try values.decode(Int.self, forKey: .largestCriticalStrike)
            totalDamageDealtToChampions = try values.decode(Int.self, forKey: .totalDamageDealtToChampions)
            magicDamageDealtToChampions = try values.decode(Int.self, forKey: .magicDamageDealtToChampions)
            physicalDamageDealtToChampions = try values.decode(Int.self, forKey: .physicalDamageDealtToChampions)
            trueDamageDealtToChampions = try values.decode(Int.self, forKey: .trueDamageDealtToChampions)
            totalHeal = try values.decode(Int.self, forKey: .totalHeal)
            totalUnitsHealed = try values.decode(Int.self, forKey: .totalUnitsHealed)
            damageSelfMitigated = try values.decode(Int.self, forKey: .damageSelfMitigated)
            damageDealtToObjectives = try values.decode(Int.self, forKey: .damageDealtToObjectives)
            damageDealtToTurrets = try values.decode(Int.self, forKey: .damageDealtToTurrets)
            visionScore = try values.decodeIfPresent(Int.self, forKey: .visionScore)
            timeCCingOthers = try values.decode(Int.self, forKey: .timeCCingOthers)
            totalDamageTaken = try values.decode(Int.self, forKey: .totalDamageTaken)
            magicalDamageTaken = try values.decode(Int.self, forKey: .magicalDamageTaken)
            physicalDamageTaken = try values.decode(Int.self, forKey: .physicalDamageTaken)
            trueDamageTaken = try values.decode(Int.self, forKey: .trueDamageTaken)
            goldEarned = try values.decode(Int.self, forKey: .goldEarned)
            goldSpent = try values.decode(Int.self, forKey: .goldSpent)
            turretKills = try values.decode(Int.self, forKey: .turretKills)
            inhibitorKills = try values.decode(Int.self, forKey: .inhibitorKills)
            totalMinionsKilled = try values.decode(Int.self, forKey: .totalMinionsKilled)
            neutralMinionsKilled = try values.decodeIfPresent(Int.self, forKey: .neutralMinionsKilled)
            neutralMinionsKilledTeamJungle = try values.decodeIfPresent(Int.self, forKey: .neutralMinionsKilledTeamJungle)
            neutralMinionsKilledEnemyJungle = try values.decodeIfPresent(Int.self, forKey: .neutralMinionsKilledEnemyJungle)
            totalTimeCrowdControlDealt = try values.decode(Int.self, forKey: .totalTimeCrowdControlDealt)
            champLevel = try values.decode(Int.self, forKey: .champLevel)
            visionWardsBoughtInGame = try values.decodeIfPresent(Int.self, forKey: .visionWardsBoughtInGame)
            sightWardsBoughtInGame = try values.decodeIfPresent(Int.self, forKey: .sightWardsBoughtInGame)
            wardsPlaced = try values.decodeIfPresent(Int.self, forKey: .wardsPlaced)
            wardsKilled = try values.decodeIfPresent(Int.self, forKey: .wardsKilled)
            firstBloodKill = try values.decodeIfPresent(Bool.self, forKey: .firstBloodKill)
            firstBloodAssist = try values.decodeIfPresent(Bool.self, forKey: .firstBloodAssist)
            firstTowerKill = try values.decodeIfPresent(Bool.self, forKey: .firstTowerKill)
            firstTowerAssist = try values.decodeIfPresent(Bool.self, forKey: .firstTowerAssist)
            firstInhibitorKill = try values.decodeIfPresent(Bool.self, forKey: .firstInhibitorKill)
            firstInhibitorAssist = try values.decodeIfPresent(Bool.self, forKey: .firstInhibitorAssist)
            combatPlayerScore = try values.decode(Int.self, forKey: .combatPlayerScore)
            objectivePlayerScore = try values.decode(Int.self, forKey: .objectivePlayerScore)
            totalPlayerScore = try values.decode(Int.self, forKey: .totalPlayerScore)
            totalScoreRank = try values.decode(Int.self, forKey: .totalScoreRank)
            playerScore0 = try values.decodeIfPresent(Int.self, forKey: .playerScore0)
            playerScore1 = try values.decodeIfPresent(Int.self, forKey: .playerScore1)
            playerScore2 = try values.decodeIfPresent(Int.self, forKey: .playerScore2)
            playerScore3 = try values.decodeIfPresent(Int.self, forKey: .playerScore3)
            playerScore4 = try values.decodeIfPresent(Int.self, forKey: .playerScore4)
            playerScore5 = try values.decodeIfPresent(Int.self, forKey: .playerScore5)
            playerScore6 = try values.decodeIfPresent(Int.self, forKey: .playerScore6)
            playerScore7 = try values.decodeIfPresent(Int.self, forKey: .playerScore7)
            playerScore8 = try values.decodeIfPresent(Int.self, forKey: .playerScore8)
            playerScore9 = try values.decodeIfPresent(Int.self, forKey: .playerScore9)
            perk0 = try values.decode(Int.self, forKey: .perk0)
            perk0Var1 = try values.decode(Int.self, forKey: .perk0Var1)
            perk0Var2 = try values.decode(Int.self, forKey: .perk0Var2)
            perk0Var3 = try values.decode(Int.self, forKey: .perk0Var3)
            perk1 = try values.decode(Int.self, forKey: .perk1)
            perk1Var1 = try values.decode(Int.self, forKey: .perk1Var1)
            perk1Var2 = try values.decode(Int.self, forKey: .perk1Var2)
            perk1Var3 = try values.decode(Int.self, forKey: .perk1Var3)
            perk2 = try values.decode(Int.self, forKey: .perk2)
            perk2Var1 = try values.decode(Int.self, forKey: .perk2Var1)
            perk2Var2 = try values.decode(Int.self, forKey: .perk2Var2)
            perk2Var3 = try values.decode(Int.self, forKey: .perk2Var3)
            perk3 = try values.decode(Int.self, forKey: .perk3)
            perk3Var1 = try values.decode(Int.self, forKey: .perk3Var1)
            perk3Var2 = try values.decode(Int.self, forKey: .perk3Var2)
            perk3Var3 = try values.decode(Int.self, forKey: .perk3Var3)
            perk4 = try values.decode(Int.self, forKey: .perk4)
            perk4Var1 = try values.decode(Int.self, forKey: .perk4Var1)
            perk4Var2 = try values.decode(Int.self, forKey: .perk4Var2)
            perk4Var3 = try values.decode(Int.self, forKey: .perk4Var3)
            perk5 = try values.decode(Int.self, forKey: .perk5)
            perk5Var1 = try values.decode(Int.self, forKey: .perk5Var1)
            perk5Var2 = try values.decode(Int.self, forKey: .perk5Var2)
            perk5Var3 = try values.decode(Int.self, forKey: .perk5Var3)
            perkPrimaryStyle = try values.decode(Int.self, forKey: .perkPrimaryStyle)
            perkSubStyle = try values.decode(Int.self, forKey: .perkSubStyle)
            statPerk0 = try values.decode(Int.self, forKey: .statPerk0)
            statPerk1 = try values.decode(Int.self, forKey: .statPerk1)
            statPerk2 = try values.decode(Int.self, forKey: .statPerk2)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(participantId, forKey: .participantId)
            try container.encode(win, forKey: .win)
            try container.encode(item0, forKey: .item0)
            try container.encode(item1, forKey: .item1)
            try container.encode(item2, forKey: .item2)
            try container.encode(item3, forKey: .item3)
            try container.encode(item4, forKey: .item4)
            try container.encode(item5, forKey: .item5)
            try container.encode(item6, forKey: .item6)
            try container.encode(kills, forKey: .kills)
            try container.encode(deaths, forKey: .deaths)
            try container.encode(assists, forKey: .assists)
            try container.encode(largestKillingSpree, forKey: .largestKillingSpree)
            try container.encode(largestMultiKill, forKey: .largestMultiKill)
            try container.encode(killingSprees, forKey: .killingSprees)
            try container.encodeIfPresent(longestTimeSpentLiving, forKey: .longestTimeSpentLiving)
            try container.encode(doubleKills, forKey: .doubleKills)
            try container.encode(tripleKills, forKey: .tripleKills)
            try container.encode(quadraKills, forKey: .quadraKills)
            try container.encode(pentaKills, forKey: .pentaKills)
            try container.encode(unrealKills, forKey: .unrealKills)
            try container.encode(totalDamageDealt, forKey: .totalDamageDealt)
            try container.encode(magicDamageDealt, forKey: .magicDamageDealt)
            try container.encode(physicalDamageDealt, forKey: .physicalDamageDealt)
            try container.encode(trueDamageDealt, forKey: .trueDamageDealt)
            try container.encode(largestCriticalStrike, forKey: .largestCriticalStrike)
            try container.encode(totalDamageDealtToChampions, forKey: .totalDamageDealtToChampions)
            try container.encode(magicDamageDealtToChampions, forKey: .magicDamageDealtToChampions)
            try container.encode(physicalDamageDealtToChampions, forKey: .physicalDamageDealtToChampions)
            try container.encode(trueDamageDealtToChampions, forKey: .trueDamageDealtToChampions)
            try container.encode(totalHeal, forKey: .totalHeal)
            try container.encode(totalUnitsHealed, forKey: .totalUnitsHealed)
            try container.encode(damageSelfMitigated, forKey: .damageSelfMitigated)
            try container.encode(damageDealtToObjectives, forKey: .damageDealtToObjectives)
            try container.encode(damageDealtToTurrets, forKey: .damageDealtToTurrets)
            try container.encodeIfPresent(visionScore, forKey: .visionScore)
            try container.encode(timeCCingOthers, forKey: .timeCCingOthers)
            try container.encode(totalDamageTaken, forKey: .totalDamageTaken)
            try container.encode(magicalDamageTaken, forKey: .magicalDamageTaken)
            try container.encode(physicalDamageTaken, forKey: .physicalDamageTaken)
            try container.encode(trueDamageTaken, forKey: .trueDamageTaken)
            try container.encode(goldEarned, forKey: .goldEarned)
            try container.encode(goldSpent, forKey: .goldSpent)
            try container.encode(turretKills, forKey: .turretKills)
            try container.encode(inhibitorKills, forKey: .inhibitorKills)
            try container.encode(totalMinionsKilled, forKey: .totalMinionsKilled)
            try container.encodeIfPresent(neutralMinionsKilled, forKey: .neutralMinionsKilled)
            try container.encodeIfPresent(neutralMinionsKilledTeamJungle, forKey: .neutralMinionsKilledTeamJungle)
            try container.encodeIfPresent(neutralMinionsKilledEnemyJungle, forKey: .neutralMinionsKilledEnemyJungle)
            try container.encode(totalTimeCrowdControlDealt, forKey: .totalTimeCrowdControlDealt)
            try container.encode(champLevel, forKey: .champLevel)
            try container.encodeIfPresent(visionWardsBoughtInGame, forKey: .visionWardsBoughtInGame)
            try container.encodeIfPresent(sightWardsBoughtInGame, forKey: .sightWardsBoughtInGame)
            try container.encodeIfPresent(wardsPlaced, forKey: .wardsPlaced)
            try container.encodeIfPresent(wardsKilled, forKey: .wardsKilled)
            try container.encodeIfPresent(firstBloodKill, forKey: .firstBloodKill)
            try container.encodeIfPresent(firstBloodAssist, forKey: .firstBloodAssist)
            try container.encodeIfPresent(firstTowerKill, forKey: .firstTowerKill)
            try container.encodeIfPresent(firstTowerAssist, forKey: .firstTowerAssist)
            try container.encodeIfPresent(firstInhibitorKill, forKey: .firstInhibitorKill)
            try container.encodeIfPresent(firstInhibitorAssist, forKey: .firstInhibitorAssist)
            try container.encode(combatPlayerScore, forKey: .combatPlayerScore)
            try container.encode(objectivePlayerScore, forKey: .objectivePlayerScore)
            try container.encode(totalPlayerScore, forKey: .totalPlayerScore)
            try container.encode(totalScoreRank, forKey: .totalScoreRank)
            try container.encodeIfPresent(playerScore0, forKey: .playerScore0)
            try container.encodeIfPresent(playerScore1, forKey: .playerScore1)
            try container.encodeIfPresent(playerScore2, forKey: .playerScore2)
            try container.encodeIfPresent(playerScore3, forKey: .playerScore3)
            try container.encodeIfPresent(playerScore4, forKey: .playerScore4)
            try container.encodeIfPresent(playerScore5, forKey: .playerScore5)
            try container.encodeIfPresent(playerScore6, forKey: .playerScore6)
            try container.encodeIfPresent(playerScore7, forKey: .playerScore7)
            try container.encodeIfPresent(playerScore8, forKey: .playerScore8)
            try container.encodeIfPresent(playerScore9, forKey: .playerScore9)
            try container.encode(perk0, forKey: .perk0)
            try container.encode(perk0Var1, forKey: .perk0Var1)
            try container.encode(perk0Var2, forKey: .perk0Var2)
            try container.encode(perk0Var3, forKey: .perk0Var3)
            try container.encode(perk1, forKey: .perk1)
            try container.encode(perk1Var1, forKey: .perk1Var1)
            try container.encode(perk1Var2, forKey: .perk1Var2)
            try container.encode(perk1Var3, forKey: .perk1Var3)
            try container.encode(perk2, forKey: .perk2)
            try container.encode(perk2Var1, forKey: .perk2Var1)
            try container.encode(perk2Var2, forKey: .perk2Var2)
            try container.encode(perk2Var3, forKey: .perk2Var3)
            try container.encode(perk3, forKey: .perk3)
            try container.encode(perk3Var1, forKey: .perk3Var1)
            try container.encode(perk3Var2, forKey: .perk3Var2)
            try container.encode(perk3Var3, forKey: .perk3Var3)
            try container.encode(perk4, forKey: .perk4)
            try container.encode(perk4Var1, forKey: .perk4Var1)
            try container.encode(perk4Var2, forKey: .perk4Var2)
            try container.encode(perk4Var3, forKey: .perk4Var3)
            try container.encode(perk5, forKey: .perk5)
            try container.encode(perk5Var1, forKey: .perk5Var1)
            try container.encode(perk5Var2, forKey: .perk5Var2)
            try container.encode(perk5Var3, forKey: .perk5Var3)
            try container.encode(perkPrimaryStyle, forKey: .perkPrimaryStyle)
            try container.encode(perkSubStyle, forKey: .perkSubStyle)
            try container.encode(statPerk0, forKey: .statPerk0)
            try container.encode(statPerk1, forKey: .statPerk1)
            try container.encode(statPerk2, forKey: .statPerk2)
        }
    }
}
