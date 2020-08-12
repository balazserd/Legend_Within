//
//  MatchHistoryModel.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Combine
import Moya

final class MatchHistoryModel : ObservableObject {
    @Published var matchHistory: MatchHistory? = nil
    @Published var isLoadingFirstSetOfMatches: Bool = false
    @Published var isLoadingFurtherSetsOfMatches: Bool = false
    @Published var matchTypesToFetch: MatchTypesToFetch = .all

    private let matchesProvider = MoyaProvider<LeagueApi.Matches>()

    private var cancellableBag = Set<AnyCancellable>()
    private let bagSafetyQueue = DispatchQueue(label: "matchHistoryModel.bagSafetyQueue", attributes: .concurrent)
    private let operationQueue = DispatchQueue(label: "matchHistoryModel.operationQueue", qos: .userInteractive, attributes: .concurrent)

    init() {
        setupMatchDetailsSubcription()
    }

    public func requestMatches(shouldOverwriteCurrentInstance: Bool = false) {
        let queryParams: LeagueApi.Matches.ByAccountQueryParameters = {
            var params = LeagueApi.Matches.ByAccountQueryParameters()
            params.beginIndex = self.matchHistory?.matches.count ?? 0
            params.endIndex = params.beginIndex! + 20
            params.queues = self.matchTypesToFetch.asRequestHeaderValue

            return params
        }()

        if self.matchHistory == nil || shouldOverwriteCurrentInstance {
            self.isLoadingFirstSetOfMatches = true
        } else {
            self.isLoadingFurtherSetsOfMatches = true
        }

        matchesProvider.requestPublisher(.byAccount(region: .euw,
                                                    encryptedAccountId: "nnK1yvPQltAH9yNP81T9R_iT0hhdt2fk8RBHSEQtEnmubS4",
                                                    queryParams: queryParams))
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .map { $0.data }
            .decode(type: MatchHistory.self, decoder: JSONDecoder())
            .mapError(NetworkRequestError.transformDecodableNetworkErrorStream(error:))
            .sink(receiveCompletion: { completionType in
                //TODO error handling
                print(completionType)
            }) { [weak self] newMatchHistory in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    if self.matchHistory == nil || shouldOverwriteCurrentInstance {
                        self.matchHistory = newMatchHistory
                        self.objectWillChange.send()
                    } else {
                        var newSetOfMatches = self.matchHistory!.matches
                        newSetOfMatches.insert(contentsOf: newMatchHistory.matches,
                                               at: newMatchHistory.startIndex)
                        self.matchHistory!.matches = newSetOfMatches
                    }
                }
            }
            .store(in: &self.cancellableBag)
    }

    private func setupMatchDetailsSubcription() {
        $matchHistory
            .receive(on: self.operationQueue)
            .sink { [weak self] matchHistory in
                guard
                    let self = self,
                    matchHistory != nil
                else { return }

                let matchesToGetDetailsFor = matchHistory!.matches.filter { $0.details == nil }

                let dpGroup = DispatchGroup()
                DispatchQueue.concurrentPerform(iterations: matchesToGetDetailsFor.count) { i in
                    dpGroup.enter() //ENTER

                    var cancellable: AnyCancellable? = nil
                    cancellable = self.matchesProvider.requestPublisher(.singleMatch(region: .euw, matchId: matchesToGetDetailsFor[i].gameId))
                        .receive(on: DispatchQueue.global(qos: .userInteractive))
                        .map { $0.data }
                        .decode(type: MatchDetails.self, decoder: JSONDecoder())
                        .mapError(NetworkRequestError.transformDecodableNetworkErrorStream(error:))
                        .sink(receiveCompletion: { [weak self] completionType in
                            self?.bagSafetyQueue.async(flags: .barrier) {
                                self?.cancellableBag.remove(cancellable!)
                            }
                            dpGroup.leave() //LEAVE

                            //TODO error handling
                        }) { newMatchDetails in
                            DispatchQueue.main.async {
                                matchesToGetDetailsFor[i].details = newMatchDetails
                            }
                        }

                    self.bagSafetyQueue.async(flags: .barrier) {
                        self.cancellableBag.insert(cancellable!)
                    }
                }

                dpGroup.notify(queue: .main) {
                    self.isLoadingFirstSetOfMatches = false
                    self.isLoadingFurtherSetsOfMatches = false
                }
            }
            .store(in: &cancellableBag)
    }

    enum MatchTypesToFetch : CaseIterable {
        case all
        case allRanked
        case rankedSolo

        var asRequestHeaderValue: [Int]? {
            switch self {
                case .all: return nil
                case .allRanked: return [420, 440, 700]
                case .rankedSolo: return [420]
            }
        }

        var description: String {
            switch self {
                case .all: return "All"
                case .allRanked: return "Ranked only"
                case .rankedSolo: return "Ranked Solo/Duo only"
            }
        }
    }
}
