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

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.loadData()
        }

        leagueApi.$newVersionExists
            .sink { [weak self] exists in
                guard exists else { return }
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

        for champion in champListObject.data {
            //TODO: this task could be very long. What to do?
            let champData = try! Data(contentsOf: FilePaths.championJson(name: champion.key).path)
            let champObject = try! decoder.decode(ChampionDetails.self, from: champData)

            DispatchQueue.main.async {
                self.champions[champObject.data[champion.key]!.key] = champObject
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
