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

    init() {

    }

    public func requestMatches() {
        let queryParams: LeagueApi.Matches.ByAccountQueryParameters = {
            var params = LeagueApi.Matches.ByAccountQueryParameters()
            params.beginIndex = 0
            params.endIndex = 20

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
                self.matchHistory = history
            }
            .store(in: &self.cancellableBag)
    }
}
