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
    }
}

extension LeagueApi.DataDragon : TargetType {
    
    var baseURL: URL {
        URL(string: "https://ddragon.leagueoflegends.com")!
    }

    var path: String {
        let currentVersion = UserDefaults.standard.string(forKey: Settings.currentDownloadedVersion) ?? "10.13.1"

        switch self {
            case .versions: return "/api/versions.json"
            case .champions: return "/cdn/\(currentVersion)/data/en_US/champion.json"
            case .items: return "/cdn/\(currentVersion)/data/en_US/item.json"
            case .champion(_, let name): return "/cdn/\(currentVersion)/data/en_US/champion/\(name).json"
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
                 .champions(let downloadPath):
                return .downloadDestination { _, _ in (downloadPath, [.removePreviousFile, .createIntermediateDirectories]) }
        }
    }

    var headers: [String : String]? {
        nil
    }
}
