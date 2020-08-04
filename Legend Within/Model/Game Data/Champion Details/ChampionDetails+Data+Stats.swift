//
//  ChampionDetails+Data+Stats.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension ChampionDetails.Data {
    final class Stats: Codable {

        let hp: Double
        let hpperlevel: Double
        let mp: Double
        let mpperlevel: Double
        let movespeed: Double
        let armor: Double
        let armorperlevel: Double
        let spellblock: Double
        let spellblockperlevel: Double
        let attackrange: Double
        let hpregen: Double
        let hpregenperlevel: Double
        let mpregen: Double
        let mpregenperlevel: Double
        let crit: Double
        let critperlevel: Double
        let attackdamage: Double
        let attackdamageperlevel: Double
        let attackspeedperlevel: Double
        let attackspeed: Double

        private enum CodingKeys: String, CodingKey {
            case hp = "hp"
            case hpperlevel = "hpperlevel"
            case mp = "mp"
            case mpperlevel = "mpperlevel"
            case movespeed = "movespeed"
            case armor = "armor"
            case armorperlevel = "armorperlevel"
            case spellblock = "spellblock"
            case spellblockperlevel = "spellblockperlevel"
            case attackrange = "attackrange"
            case hpregen = "hpregen"
            case hpregenperlevel = "hpregenperlevel"
            case mpregen = "mpregen"
            case mpregenperlevel = "mpregenperlevel"
            case crit = "crit"
            case critperlevel = "critperlevel"
            case attackdamage = "attackdamage"
            case attackdamageperlevel = "attackdamageperlevel"
            case attackspeedperlevel = "attackspeedperlevel"
            case attackspeed = "attackspeed"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            hp = try values.decode(Double.self, forKey: .hp)
            hpperlevel = try values.decode(Double.self, forKey: .hpperlevel)
            mp = try values.decode(Double.self, forKey: .mp)
            mpperlevel = try values.decode(Double.self, forKey: .mpperlevel)
            movespeed = try values.decode(Double.self, forKey: .movespeed)
            armor = try values.decode(Double.self, forKey: .armor)
            armorperlevel = try values.decode(Double.self, forKey: .armorperlevel)
            spellblock = try values.decode(Double.self, forKey: .spellblock)
            spellblockperlevel = try values.decode(Double.self, forKey: .spellblockperlevel)
            attackrange = try values.decode(Double.self, forKey: .attackrange)
            hpregen = try values.decode(Double.self, forKey: .hpregen)
            hpregenperlevel = try values.decode(Double.self, forKey: .hpregenperlevel)
            mpregen = try values.decode(Double.self, forKey: .mpregen)
            mpregenperlevel = try values.decode(Double.self, forKey: .mpregenperlevel)
            crit = try values.decode(Double.self, forKey: .crit)
            critperlevel = try values.decode(Double.self, forKey: .critperlevel)
            attackdamage = try values.decode(Double.self, forKey: .attackdamage)
            attackdamageperlevel = try values.decode(Double.self, forKey: .attackdamageperlevel)
            attackspeedperlevel = try values.decode(Double.self, forKey: .attackspeedperlevel)
            attackspeed = try values.decode(Double.self, forKey: .attackspeed)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(hp, forKey: .hp)
            try container.encode(hpperlevel, forKey: .hpperlevel)
            try container.encode(mp, forKey: .mp)
            try container.encode(mpperlevel, forKey: .mpperlevel)
            try container.encode(movespeed, forKey: .movespeed)
            try container.encode(armor, forKey: .armor)
            try container.encode(armorperlevel, forKey: .armorperlevel)
            try container.encode(spellblock, forKey: .spellblock)
            try container.encode(spellblockperlevel, forKey: .spellblockperlevel)
            try container.encode(attackrange, forKey: .attackrange)
            try container.encode(hpregen, forKey: .hpregen)
            try container.encode(hpregenperlevel, forKey: .hpregenperlevel)
            try container.encode(mpregen, forKey: .mpregen)
            try container.encode(mpregenperlevel, forKey: .mpregenperlevel)
            try container.encode(crit, forKey: .crit)
            try container.encode(critperlevel, forKey: .critperlevel)
            try container.encode(attackdamage, forKey: .attackdamage)
            try container.encode(attackdamageperlevel, forKey: .attackdamageperlevel)
            try container.encode(attackspeedperlevel, forKey: .attackspeedperlevel)
            try container.encode(attackspeed, forKey: .attackspeed)
        }

    }
}
