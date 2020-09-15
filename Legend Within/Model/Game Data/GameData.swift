//
//  GameData.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Combine

final class GameData : ObservableObject {
    private let leagueApi = LeagueApi.shared
    private(set) static var shared = GameData()

    @Published private(set) var champions: [Int : ChampionDetails]
    @Published private(set) var items: [Int : Item]
    @Published private(set) var queues: [Int : Queue]
    @Published private(set) var maps: [Int : Map]
    @Published private(set) var runePaths: [Int : RunePath]
    @Published private(set) var summonerSpells: [Int : SummonerSpell]

    private var cancellableBag = Set<AnyCancellable>()

    private let dedicatedConcurrentQueue = DispatchQueue(label: "gameData.concurrentQueue", qos: .userInteractive, attributes: .concurrent)

    private init() {
        self.champions = [:]
        self.items = [:]
        self.queues = [:]
        self.maps = [:]
        self.runePaths = [:]
        self.summonerSpells = [:]

        leagueApi.$newVersionExists
            .compactMap { $0 }
            .sink { [weak self] exists in
                //When a new version's download is finished, this will receive a "false" value. That's when this should run.
                if exists { return }
                DispatchQueue.global(qos: .userInteractive).async {
                    self?.loadData()
                }
            }
            .store(in: &cancellableBag)
    }

    private func loadData() {
        let decoder = JSONDecoder()

        //MARK: champions
        self.dedicatedConcurrentQueue.async {
            let champListData = try! Data(contentsOf: FilePaths.championsJson.path)
            let champListObject = try! decoder.decode(ChampionsJSON.self, from: champListData)

            let keyArray = champListObject.data.map { $0.key }
            let champArray = champListObject.data.map { $0.value }

            DispatchQueue.concurrentPerform(iterations: champArray.count) { i in
                let champData = try! Data(contentsOf: FilePaths.championJson(name: keyArray[i]).path)
                let champObject = try! decoder.decode(ChampionDetails.self, from: champData)

                DispatchQueue.main.async {
                    self.champions[champObject.data[keyArray[i]]!.key] = champObject
                }
            }
        }

        //MARK: items
        self.dedicatedConcurrentQueue.async {
            let itemListData = try! Data(contentsOf: FilePaths.itemsJson.path)
            let itemListObject = try! decoder.decode(ItemsJSON.self, from: itemListData)

            DispatchQueue.main.async {
                self.items = itemListObject.data
            }
        }

        //MARK: maps
        self.dedicatedConcurrentQueue.async {
            let mapListData = try! Data(contentsOf: FilePaths.mapsJson.path)
            let mapListObject = try! decoder.decode([Map].self, from: mapListData)

            DispatchQueue.main.async {
                self.maps = Dictionary(uniqueKeysWithValues: mapListObject.map { ($0.mapId, $0) })
            }
        }

        //MARK: queues
        self.dedicatedConcurrentQueue.async {
            let queueListData = try! Data(contentsOf: FilePaths.queuesJson.path)
            let queueListObject = try! decoder.decode([Queue].self, from: queueListData)

            DispatchQueue.main.async {
                self.queues = Dictionary(uniqueKeysWithValues: queueListObject.map { ($0.queueId, $0) })
            }
        }

        //MARK: runes
        self.dedicatedConcurrentQueue.async {
            let runePathListData = try! Data(contentsOf: FilePaths.runesJson.path)
            let runePathListObject = try! decoder.decode([RunePath].self, from: runePathListData)

            DispatchQueue.main.async {
                self.runePaths = Dictionary(uniqueKeysWithValues: runePathListObject.map { ($0.id, $0) })
            }
        }

        //MARK: summoner spells
        self.dedicatedConcurrentQueue.async {
            let summonerSpellListData = try! Data(contentsOf: FilePaths.summonerSpellsJson.path)
            let summonerSpellListObject = try! decoder.decode(SummonerSpellsJSON.self, from: summonerSpellListData)

            DispatchQueue.main.async {
                self.summonerSpells = Dictionary(uniqueKeysWithValues: summonerSpellListObject.data.map { (Int($0.value.key)!, $0.value) })
            }
        }
    }
}
