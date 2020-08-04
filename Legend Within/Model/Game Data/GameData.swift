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

    @Published private(set) var champions: [String : ChampionDetails]
    @Published private(set) var items: [String : Item]

    private var cancellableBag = Set<AnyCancellable>()

    private init() {
        self.champions = [:]
        self.items = [:]

        leagueApi.$newVersionExists
            .sink { [weak self] exists in
                if exists == nil || exists! { return }
                DispatchQueue.global(qos: .userInteractive).async {
                    self?.loadData()
                }
            }
            .store(in: &cancellableBag)
    }

    private func loadData() {
        let decoder = JSONDecoder()

        //MARK: champions
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

        //MARK: items
        let itemListData = try! Data(contentsOf: FilePaths.itemsJson.path)
        let itemListObject = try! decoder.decode(ItemsJSON.self, from: itemListData)

        DispatchQueue.main.async {
            self.items = itemListObject.data
        }
    }
}
