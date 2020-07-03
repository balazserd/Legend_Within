//
//  LeagueApi.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Moya

public struct LeagueApi {
    static func apiUrl(region: Region) -> URL {
        URL(string: String("https://\(region.urlPrefix).api.riotgames.com"))!
    }

    static let commonHeaders: [String : String]? = [
        "X-Riot-Token" : LeagueApi.key
    ]
}
