//
//  LeagueApi+UpdateProgress.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 09..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Moya

extension LeagueApi {
    class UpdateProgress : ObservableObject {
        @Published var championsJSONProgress: Double = 0.0
        @Published var itemsJSONProgress: Double = 0.0
        @Published var championUniqueJSONsProgress: Double = 0.0
        @Published var queuesJSONProgress: Double = 0.0
        @Published var mapsJSONProgress: Double = 0.0
        @Published var runesJSONProgress: Double = 0.0
        @Published var itemIconsProgress: Double = 0.0
        @Published var championIconsProgress: Double = 0.0
        @Published var summonerSpellsJSONProgress: Double = 0.0
        @Published var summonerSpellIconsProgress: Double = 0.0

        func increaseProgress(forPhase targetType: MoyaProvider<DataDragon>.Target, by value: Double) {
            DispatchQueue.main.async {
                switch targetType {
                    case .champion: self.championUniqueJSONsProgress += value
                    case .items: self.itemsJSONProgress += value
                    case .champions: self.championsJSONProgress += value
                    case .maps: self.mapsJSONProgress += value
                    case .queues: self.queuesJSONProgress += value
                    case .runes: self.runesJSONProgress += value
                    case .championIcon: self.championIconsProgress += value
                    case .itemIcon: self.itemIconsProgress += value
                    case .summonerSpells: self.summonerSpellsJSONProgress += value
                    case .summonerSpellIcon: self.summonerSpellIconsProgress += value
                    default: break
                }
            }
        }

        func finished() -> Bool {
            return !championsJSONProgress.isLessThanOrEqualTo(0.9999)
                && !itemsJSONProgress.isLessThanOrEqualTo(0.9999)
                && !championUniqueJSONsProgress.isLessThanOrEqualTo(0.9999)
                && !queuesJSONProgress.isLessThanOrEqualTo(0.9999)
                && !mapsJSONProgress.isLessThanOrEqualTo(0.9999)
                && !runesJSONProgress.isLessThanOrEqualTo(0.9999)
                && !itemIconsProgress.isLessThanOrEqualTo(0.9999)
                && !championIconsProgress.isLessThanOrEqualTo(0.9999)
                && !summonerSpellsJSONProgress.isLessThanOrEqualTo(0.9999)
                && !summonerSpellIconsProgress.isLessThanOrEqualTo(0.9999)
        }

        class func willFinishWithValues(championsProgress: Double,
                                        itemsProgress: Double,
                                        uniqueChampionsProgress: Double,
                                        queuesProgress: Double,
                                        mapsProgress: Double,
                                        runesProgress: Double,
                                        itemIconsProgress: Double,
                                        championIconsProgress: Double,
                                        summonerSpellsProgress: Double,
                                        summonerSpellIconsProgress: Double) -> Bool {
            //This is needed because publishers are called in WillChange, not in DidChange.
            return !championsProgress.isLessThanOrEqualTo(0.9999)
                && !itemsProgress.isLessThanOrEqualTo(0.9999)
                && !uniqueChampionsProgress.isLessThanOrEqualTo(0.9999)
                && !queuesProgress.isLessThanOrEqualTo(0.9999)
                && !mapsProgress.isLessThanOrEqualTo(0.9999)
                && !runesProgress.isLessThanOrEqualTo(0.9999)
                && !itemIconsProgress.isLessThanOrEqualTo(0.9999)
                && !championIconsProgress.isLessThanOrEqualTo(0.9999)
                && !summonerSpellsProgress.isLessThanOrEqualTo(0.9999)
                && !summonerSpellIconsProgress.isLessThanOrEqualTo(0.9999)
        }
    }
}
