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

    private let matchesProvider = MoyaProvider<LeagueApi.Matches>()

    private var cancellableBag = Set<AnyCancellable>()
    private let bagSafetyQueue = DispatchQueue(label: "matchHistoryModel.bagSafetyQueue", attributes: .concurrent)

    init() {
        setupMatchDetailsSubcription()
    }

    public func requestMatches(shouldOverwriteCurrentInstance: Bool = false, beginIndex: Int, endIndex: Int) {
        let queryParams: LeagueApi.Matches.ByAccountQueryParameters = {
            var params = LeagueApi.Matches.ByAccountQueryParameters()
            params.beginIndex = beginIndex
            params.endIndex = endIndex

            return params
        }()

        matchesProvider.requestPublisher(.byAccount(region: .euw,
                                                    encryptedAccountId: "nnK1yvPQltAH9yNP81T9R_iT0hhdt2fk8RBHSEQtEnmubS4",
                                                    queryParams: queryParams))
            .sink(receiveCompletion: { [weak self] completionType in
                guard let self = self else { return }

                print(completionType)
            }) { [weak self] response in
                guard let self = self else { return }

                let history = try! response.map(MatchHistory.self)
                if self.matchHistory == nil || shouldOverwriteCurrentInstance {
                    self.matchHistory = history
                } else {
                    self.matchHistory!.matches.insert(contentsOf: history.matches, at: history.startIndex)
                }
            }
            .store(in: &self.cancellableBag)
    }

    private func setupMatchDetailsSubcription() {
        $matchHistory
            .sink { [weak self] matchHistory in
                guard
                    let self = self,
                    matchHistory != nil
                else { return }

                let matchesToGetDetailsFor = matchHistory!.matches.filter { $0.details == nil }

                DispatchQueue.concurrentPerform(iterations: matchesToGetDetailsFor.count) { i in
                    var cancellable: AnyCancellable? = nil
                    cancellable = self.matchesProvider.requestPublisher(.singleMatch(region: .euw, matchId: matchesToGetDetailsFor[i].gameId))
                        .receive(on: DispatchQueue.global(qos: .userInteractive))
                        .sink(receiveCompletion: { [weak self] completionType in
                            print(completionType)
                            self?.cancellableBag.remove(cancellable!)
                        }) { [weak self] matchResponse in
                            guard let self = self else { return }

                            let matchDetails = try! matchResponse.map(MatchDetails.self)
                            DispatchQueue.main.async {
                                matchesToGetDetailsFor[i].details = matchDetails
                            }
                        }

                    self.bagSafetyQueue.async(flags: .barrier) {
                        self.cancellableBag.insert(cancellable!)
                    }
                }
            }
            .store(in: &cancellableBag)
    }
}
