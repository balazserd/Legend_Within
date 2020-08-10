//
//  SummonerSpell.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 10..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

final class SummonerSpell: Codable {

    let id: String
    let name: String
    let description: String
    let tooltip: String
    let maxrank: Int
    let cooldown: [Double]
    let cooldownBurn: String
    let cost: [Double]
    let costBurn: String
    let dataValues: DataValues
    let effect: [[Double]?]
    let effectBurn: [String?]
    let vars: [Var]
    let key: String
    let summonerLevel: Int
    let modes: [String]
    let costType: String
    let maxammo: String
    let range: [Double]
    let rangeBurn: String
    let image: Image
    let resource: String

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case tooltip = "tooltip"
        case maxrank = "maxrank"
        case cooldown = "cooldown"
        case cooldownBurn = "cooldownBurn"
        case cost = "cost"
        case costBurn = "costBurn"
        case dataValues = "datavalues"
        case effect = "effect"
        case effectBurn = "effectBurn"
        case vars = "vars"
        case key = "key"
        case summonerLevel = "summonerLevel"
        case modes = "modes"
        case costType = "costType"
        case maxammo = "maxammo"
        case range = "range"
        case rangeBurn = "rangeBurn"
        case image = "image"
        case resource = "resource"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        tooltip = try values.decode(String.self, forKey: .tooltip)
        maxrank = try values.decode(Int.self, forKey: .maxrank)
        cooldown = try values.decode([Double].self, forKey: .cooldown)
        cooldownBurn = try values.decode(String.self, forKey: .cooldownBurn)
        cost = try values.decode([Double].self, forKey: .cost)
        costBurn = try values.decode(String.self, forKey: .costBurn)
        dataValues = try values.decode(DataValues.self, forKey: .dataValues)
        effect = try values.decode([[Double]?].self, forKey: .effect)
        effectBurn = try values.decode([String?].self, forKey: .effectBurn)
        vars = try values.decode([Var].self, forKey: .vars)
        key = try values.decode(String.self, forKey: .key)
        summonerLevel = try values.decode(Int.self, forKey: .summonerLevel)
        modes = try values.decode([String].self, forKey: .modes)
        costType = try values.decode(String.self, forKey: .costType)
        maxammo = try values.decode(String.self, forKey: .maxammo)
        range = try values.decode([Double].self, forKey: .range)
        rangeBurn = try values.decode(String.self, forKey: .rangeBurn)
        image = try values.decode(Image.self, forKey: .image)
        resource = try values.decode(String.self, forKey: .resource)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(tooltip, forKey: .tooltip)
        try container.encode(maxrank, forKey: .maxrank)
        try container.encode(cooldown, forKey: .cooldown)
        try container.encode(cooldownBurn, forKey: .cooldownBurn)
        try container.encode(cost, forKey: .cost)
        try container.encode(costBurn, forKey: .costBurn)
        try container.encode(dataValues, forKey: .dataValues)
        try container.encode(effect, forKey: .effect)
        try container.encode(effectBurn, forKey: .effectBurn)
        try container.encode(vars, forKey: .vars)
        try container.encode(key, forKey: .key)
        try container.encode(summonerLevel, forKey: .summonerLevel)
        try container.encode(modes, forKey: .modes)
        try container.encode(costType, forKey: .costType)
        try container.encode(maxammo, forKey: .maxammo)
        try container.encode(range, forKey: .range)
        try container.encode(rangeBurn, forKey: .rangeBurn)
        try container.encode(image, forKey: .image)
        try container.encode(resource, forKey: .resource)
    }

}
