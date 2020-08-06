//
//  LeagueApi+DataDragon.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Moya

extension LeagueApi {
    enum DataDragon {
        case versions
        case champions(downloadPath: URL)
        case items(downloadPath: URL)
        case champion(downloadPath: URL, name: String)
        case maps(downloadPath: URL)
        case queues(downloadPath: URL)
        case runes(downloadPath: URL)
    }
}

extension LeagueApi.DataDragon : TargetType {
    
    var baseURL: URL {
        switch self {
        case .versions, .champions, .champion, .items, .runes: return URL(string: "https://ddragon.leagueoflegends.com")!
            case .maps, .queues: return URL(string: "https://static.developer.riotgames.com/docs/lol")!
        }
    }

    var path: String {
        let currentVersion = UserDefaults.standard.string(forKey: Settings.currentDownloadedVersion) ?? "10.13.1"

        switch self {
            case .versions: return "/api/versions.json"
            case .champions: return "/cdn/\(currentVersion)/data/en_US/champion.json"
            case .items: return "/cdn/\(currentVersion)/data/en_US/item.json"
            case .champion(_, let name): return "/cdn/\(currentVersion)/data/en_US/champion/\(name).json"
            case .maps: return "/maps.json"
            case .queues: return "/queues.json"
            case .runes: return "/cdn/\(currentVersion)/data/en_US/runesReforged.json"
        }
    }

    var method: Moya.Method {
        .get
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        switch self {
            case .versions:
                return .requestPlain
            case .items(let downloadPath),
                 .champion(let downloadPath, _),
                 .champions(let downloadPath),
                 .maps(let downloadPath),
                 .queues(let downloadPath),
                 .runes(let downloadPath):
                return .downloadDestination { _, _ in (downloadPath, [.removePreviousFile, .createIntermediateDirectories]) }
        }
    }

    var headers: [String : String]? {
        nil
    }
}
