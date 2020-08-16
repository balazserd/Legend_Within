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
        case runeIcon(downloadPath: URL, path: String)
        case itemIcon(downloadPath: URL, id: Int)
        case championIcon(downloadPath: URL, name: String)
        case summonerSpells(downloadPath: URL)
        case summonerSpellIcon(downloadPath: URL, name: String)
    }
}

extension LeagueApi.DataDragon : TargetType {
    
    var baseURL: URL {
        switch self {
            case .versions,
                 .champions,
                 .champion,
                 .items,
                 .runes,
                 .runeIcon,
                 .championIcon,
                 .itemIcon,
                 .summonerSpells,
                 .summonerSpellIcon:
                return URL(string: "https://ddragon.leagueoflegends.com")!
            case .maps,
                 .queues:
                return URL(string: "https://static.developer.riotgames.com/docs/lol")!
        }
    }

    var path: String {
        let versionToDownload = UserDefaults.standard.string(forKey: Settings.versionToDownload) ?? "10.16.1"

        switch self {
            case .versions: return "/api/versions.json"
            case .champions: return "/cdn/\(versionToDownload)/data/en_US/champion.json"
            case .items: return "/cdn/\(versionToDownload)/data/en_US/item.json"
            case .champion(_, let name): return "/cdn/\(versionToDownload)/data/en_US/champion/\(name).json"
            case .maps: return "/maps.json"
            case .queues: return "/queues.json"
            case .runes: return "/cdn/\(versionToDownload)/data/en_US/runesReforged.json"
            case .runeIcon(_, let path): return "/cdn/img/\(path)"
            case .championIcon(_, let name): return "/cdn/\(versionToDownload)/img/champion/\(name)"
            case .itemIcon(_, let id): return "/cdn/\(versionToDownload)/img/item/\(id).png"
            case .summonerSpells: return "/cdn/\(versionToDownload)/data/en_US/summoner.json"
            case .summonerSpellIcon(_, let name): return "/cdn/\(versionToDownload)/img/spell/\(name)"
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
                 .runes(let downloadPath),
                 .runeIcon(let downloadPath, _),
                 .championIcon(let downloadPath, _),
                 .itemIcon(let downloadPath, _),
                 .summonerSpells(let downloadPath),
                 .summonerSpellIcon(let downloadPath, _):
                return .downloadDestination { _, _ in (downloadPath, [.removePreviousFile, .createIntermediateDirectories]) }
        }
    }

    var headers: [String : String]? {
        nil
    }
}
