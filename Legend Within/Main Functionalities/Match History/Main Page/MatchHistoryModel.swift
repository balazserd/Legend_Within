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

    private let matchProviderQueue: DispatchQueue
    private let matchProvider: MoyaProvider<LeagueApi.Matches>

    private var cancellableBag = Set<AnyCancellable>()
    private let bagSafetyQueue = DispatchQueue(label: "matchHistoryModel.bagSafetyQueue", attributes: .concurrent)
    private let operationQueue = DispatchQueue(label: "matchHistoryModel.operationQueue", qos: .userInteractive, attributes: .concurrent)

    init() {
        self.matchProviderQueue = DispatchQueue(label: "matchHistoryModel.matchProviderQueue", qos: .userInitiated, attributes: .concurrent)
        self.matchProvider = MoyaProvider<LeagueApi.Matches>(callbackQueue: self.matchProviderQueue)

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

        matchProvider.requestPublisher(.byAccount(region: .euw,
                                                  encryptedAccountId: "nnK1yvPQltAH9yNP81T9R_iT0hhdt2fk8RBHSEQtEnmubS4",
                                                  queryParams: queryParams))
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
            .compactMap { $0 }
            .map { $0.matches.filter { $0.details == nil }}
            .sink { [weak self] matchesToGetDetailsFor in
                guard let self = self else { return }

                let dpGroup = DispatchGroup()
                DispatchQueue.concurrentPerform(iterations: matchesToGetDetailsFor.count) { i in
                    dpGroup.enter() //ENTER

                    var cancellable: AnyCancellable? = nil
                    cancellable = self.matchProvider.requestPublisher(.singleMatch(region: .euw, matchId: matchesToGetDetailsFor[i].gameId))
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

    enum Season : Int {
        case season8 = 0
        case preSeason9
        case season9
        case preSeason10
        case season10

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"

            return formatter
        }()

        var startTimeUnix: Int {
            let dateFormatter = Season.dateFormatter

            switch self {
                case .season8: return Int(dateFormatter.date(from: "2018/01/16 00:00")!.timeIntervalSince1970 / 1000)
                case .preSeason9: return Int(dateFormatter.date(from: "2018/11/12 00:00")!.timeIntervalSince1970 / 1000)
                case .season9: return Int(dateFormatter.date(from: "2019/01/24 00:00")!.timeIntervalSince1970 / 1000)
                case .preSeason10: return Int(dateFormatter.date(from: "2019/11/19 00:00")!.timeIntervalSince1970 / 1000)
                case .season10: return Int(dateFormatter.date(from: "2020/01/10 00:00")!.timeIntervalSince1970 / 1000)
            }
        }

        var endTimeUnix: Int? {
            switch self {
                case .season10: return nil
                default: return Season(rawValue: self.rawValue + 1)!.startTimeUnix
            }
        }
    }
}
