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
import Alamofire

public class AccountLookupModel : ObservableObject {
    private let onboardingModel = OnboardingModel.shared

    @Published public var region: Region = .euw
    @Published public var summonerName: String = ""
    @Published public var summoner: Summoner? = nil
    @Published public var errorCode: Int? = nil
    @Published public var localizedErrorDescription: String? = nil
    @Published public var isQuerying: Bool = false
    @Published public var soloQueueEntry: LeagueEntry? = nil
    @Published public var soloQueueDivision: League? = nil //if soloQueueEntry is not nil, it is fatal that this results in nil.
    @Published public var canProgressToNextStep: Bool = false

    private var cancellableBag = Set<AnyCancellable>()

    private let summonerSearchProviderQueue: DispatchQueue
    private let summonerSearchProvider: MoyaProvider<LeagueApi.Summoners>

    private let leagueEntrySearchProviderQueue: DispatchQueue
    private let leagueEntrySearchProvider: MoyaProvider<LeagueApi.LeagueEntries>

    init() {
        self.summonerSearchProviderQueue = DispatchQueue(label: "accountLookupModel.summonerSearchProviderQueue", qos: .userInitiated, attributes: .concurrent)
        self.summonerSearchProvider = MoyaProvider<LeagueApi.Summoners>(callbackQueue: self.summonerSearchProviderQueue)

        self.leagueEntrySearchProviderQueue = DispatchQueue(label: "accountLookupModel.leagueEntrySearchProviderQueue", qos: .userInitiated, attributes: .concurrent)
        self.leagueEntrySearchProvider = MoyaProvider<LeagueApi.LeagueEntries>(callbackQueue: self.leagueEntrySearchProviderQueue)

        self.setupSummonerQuerySubscription()
        self.setupSoloQueueEntryQuerySubscription()
        self.setupSoloQueueDivisionQuerySubscription()
        self.setupCanProgressToNextStepSubscription()

        self.summoner = Summoner.getCurrent()
        if let savedSummoner = self.summoner {
            self.summonerName = savedSummoner.name
            self.region = Region.getCurrentlySelected()
        }
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
                self.isQuerying = true

                var cancellable: AnyCancellable? = nil
                cancellable = self.summonerSearchProvider.requestPublisher(.byName(region: newRegion, name: newSummonerName))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard let self = self else { return }

                        switch completion {
                            case .failure(let error):
                                self.errorCode = error.response?.statusCode

                                switch error {
                                    case .underlying(let underlyingError, _):
                                        let afError = underlyingError.asAFError
                                        switch afError {
                                            case .sessionTaskFailed(let sessionError):
                                                self.localizedErrorDescription = sessionError.localizedDescription
                                            default:
                                                self.localizedErrorDescription = afError?.localizedDescription
                                                    ?? Texts.unknownErrorDescription
                                        }
                                    default: break
                                }

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
                        UserDefaults.standard.set(self.region.rawValue, forKey: Settings.regionKey)
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
                    .retry(3)
                    .map { try! $0.map([LeagueEntry].self) }
                    .map { $0.first { $0.queueType == .rankedSolo } }
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        self?.cancellableBag.remove(cancellable!)
                    }, receiveValue: { [weak self] soloQueueEntry in
                        self?.soloQueueEntry = soloQueueEntry
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
                    .retry(3)
                    .map { try! $0.map(League.self) }
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        self?.cancellableBag.remove(cancellable!)
                    }, receiveValue: { [weak self] division in
                        self?.soloQueueDivision = division
                    })
                cancellable!.store(in: &self.cancellableBag)
            }
            .store(in: &cancellableBag)
    }

    private func setupCanProgressToNextStepSubscription() {
        Publishers.CombineLatest($summoner, $errorCode)
            .sink { [weak self] values in
                if values.0 != nil && values.1 == nil {
                    self?.canProgressToNextStep = true
                } else {
                    self?.canProgressToNextStep = false
                }
            }
            .store(in: &cancellableBag)

        $canProgressToNextStep
            .sink { [weak self] canProgress in
                if canProgress {
                    self?.onboardingModel.didFinishOnboardingPage(number: 2)
                } 
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
