//
//  FilePaths.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

import Foundation

enum FilePaths {
    case championsJson
    case itemsJson
    case championJson(name: String)
    case mapsJson
    case queuesJson
    case runesJson
    case runeIcon(filePath: String)
    case championIcon(fileName: String)
    case itemIcon(id: Int)
    case summonerSpellsJson
    case summonerSpellIcon(fileName: String)

    var path: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        switch self {
            case .championsJson:
                return documentDirectory.appendingPathComponent("champion.json")
            case .itemsJson:
                return documentDirectory.appendingPathComponent("item.json")
            case .championJson(let name):
                return documentDirectory.appendingPathComponent("champions", isDirectory: true).appendingPathComponent("\(name).json")
            case .mapsJson:
                return documentDirectory.appendingPathComponent("maps.json")
            case .queuesJson:
                return documentDirectory.appendingPathComponent("queues.json")
            case .runesJson:
                return documentDirectory.appendingPathComponent("runes.json")
            case .runeIcon(let path):
                return documentDirectory.appendingPathComponent("runeIcons", isDirectory: true).appendingPathComponent("\(path)")
            case .championIcon(let fileName):
                return documentDirectory.appendingPathComponent("championIcons", isDirectory: true).appendingPathComponent("\(fileName)")
            case .itemIcon(let id):
                return documentDirectory.appendingPathComponent("itemIcons", isDirectory: true).appendingPathComponent("\(id).png")
            case .summonerSpellsJson:
                return documentDirectory.appendingPathComponent("summoner.json")
            case .summonerSpellIcon(let fileName):
                return documentDirectory.appendingPathComponent("summonerSpells", isDirectory: true).appendingPathComponent("\(fileName)")
        }
    }
}
