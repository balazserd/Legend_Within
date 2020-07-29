//
//  AccountLookupModel.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Moya
import Combine

public class AccountLookupModel : ObservableObject {
    @Published public var region: Region = .euw
    @Published public var summonerName: String = ""
    @Published public var summoner: Summoner? = nil
    @Published public var errorCode: Int? = nil
    @Published public var isQuerying: Bool = false
    @Published public var soloQueueEntry: LeagueEntry? = nil
    @Published public var soloQueueDivision: League? = nil //if soloQueueEntry is not nil, it is fatal that this results in nil.

    private var cancellableBag = Set<AnyCancellable>()

    private let summonerSearchProvider = MoyaProvider<LeagueApi.Summoners>()
    private let leagueEntrySearchProvider = MoyaProvider<LeagueApi.LeagueEntries>()

    init() {
        self.setupSummonerQuerySubscription()
        self.setupSoloQueueEntryQuerySubscription()
        self.setupSoloQueueDivisionQuerySubscription()
    }

    private func setupSummonerQuerySubscription() {
        Publishers.CombineLatest($summonerName, $region)
            .debounce(for: .milliseconds(1500), scheduler: RunLoop.main)
            .sink { [weak self] newValues in
                let newSummonerName = newValues.0
                let newRegion = newValues.1

                guard
                    let self = self,
                    newSummonerName != ""
                else { return }

                UserDefaults.standard.set(newRegion.rawValue, forKey: Settings.regionKey)

                self.isQuerying = true

                var cancellable: AnyCancellable? = nil
                cancellable = self.summonerSearchProvider.requestPublisher(.byName(region: newRegion, name: newSummonerName))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard let self = self else { return }

                        switch completion {
                            case .failure(let error):
                                self.errorCode = error.response?.statusCode
                            case .finished:
                                self.errorCode = nil
                        }

                        self.cancellableBag.remove(cancellable!)
                        self.isQuerying = false
                    }, receiveValue: { [weak self] response in
                        guard let self = self else { return }

                        let summoner = try! response.map(Summoner.self)
                        self.summoner = summoner
                        let summonerJson = try? JSONEncoder().encode(summoner)
                        UserDefaults.standard.set(summonerJson, forKey: Settings.summonerKey)
                    })
                cancellable!.store(in: &self.cancellableBag)
            }
            .store(in: &cancellableBag)
    }

    private func setupSoloQueueEntryQuerySubscription() {
        $summoner
            .sink { [weak self] newSummoner in
                guard
                    let self = self,
                    let newSummoner = newSummoner
                else { return }

                var cancellable: AnyCancellable? = nil
                cancellable = self.leagueEntrySearchProvider.requestPublisher(.byEncryptedSummonerId(region: self.region, encryptedSummonerId: newSummoner.id))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        self?.cancellableBag.remove(cancellable!)
                    }, receiveValue: { [weak self] response in
                        guard let self = self else { return }

                        let entries = try! response.map([LeagueEntry].self)
                        let soloQueueEntry = entries.first { $0.queueType == .rankedSolo }
                        self.soloQueueEntry = soloQueueEntry
                    })
                cancellable!.store(in: &self.cancellableBag)
            }
            .store(in: &cancellableBag)
    }

    private func setupSoloQueueDivisionQuerySubscription() {
        $soloQueueEntry
            .sink { [weak self] newLeagueEntry in
                guard
                    let self = self,
                    let newLeagueEntry = newLeagueEntry
                else { return }

                var cancellable: AnyCancellable? = nil
                cancellable = self.leagueEntrySearchProvider.requestPublisher(.leagues(region: self.region, leagueId: newLeagueEntry.leagueId))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        self?.cancellableBag.remove(cancellable!)
                    }, receiveValue: { [weak self] response in
                        guard let self = self else { return }
                        let division = try! response.map(League.self)
                        self.soloQueueDivision = division
                    })
                cancellable!.store(in: &self.cancellableBag)
            }
            .store(in: &cancellableBag)
    }
}

extension AccountLookupModel {
    enum SummonerSearchError : Error {
        case notFound
        case networkIssue
        case unknown
    }
}
