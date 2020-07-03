//
//  Summoner.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

//MARK: - Summoner main class declaration
public final class Summoner : NSObject, Codable {
    public var name: String
    public var id: String
    public var accountId: String
    public var puuid: String
    public var revisionDate : Int
    public var profileIconId: Int
    public var summonerLevel: Int

    //MARK: - Codable inits
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountId = try values.decode(String.self, forKey: .accountId)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        profileIconId = try values.decode(Int.self, forKey: .profileIconId)
        puuid = try values.decode(String.self, forKey: .puuid)
        revisionDate = try values.decode(Int.self, forKey: .revisionDate)
        summonerLevel = try values.decode(Int.self, forKey: .summonerLevel)

        super.init()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.accountId, forKey: .accountId)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.profileIconId, forKey: .profileIconId)
        try container.encode(self.puuid, forKey: .puuid)
        try container.encode(self.revisionDate, forKey: .revisionDate)
        try container.encode(self.summonerLevel, forKey: .summonerLevel)
    }
}

//MARK: - CodingKeys extension
private extension Summoner {
    enum CodingKeys: String, CodingKey {
        case accountId = "accountId"
        case id = "id"
        case name = "name"
        case profileIconId = "profileIconId"
        case puuid = "puuid"
        case revisionDate = "revisionDate"
        case summonerLevel = "summonerLevel"
    }
}
