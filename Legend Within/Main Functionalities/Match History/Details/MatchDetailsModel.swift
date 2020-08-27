//
//  MatchDetailsModel.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Combine
import Moya
import SwiftUI

final class MatchDetailsModel : ObservableObject {
    typealias Role = MatchDetails.Participant.Timeline.Role
    typealias Lane = MatchDetails.Participant.Timeline.Lane
    typealias GestureValueHandler = LineChart.DragGestureHandler

    @Published var timeline: MatchTimeline? = nil
    @Published var roles: [Int : Role?]? = nil
    @Published var lanes: [Int : Lane?]? = nil
    @Published var participants: [MatchDetails.Participant]? = nil
    @Published var isWorking: Bool = false
    @Published var match: Match? = nil
    var initialMatchParameter: Match
    @Published var chart_currentValuesForDragGesture: [Double?] = Array(repeating: nil, count: 11) //1-based array.
    var chart_currentValueHandlers: [GestureValueHandler] = (0...10).map { _ in GestureValueHandler() } //1-based array.

    private var cancellableBag = Set<AnyCancellable>()
    private let timelineProvider = MoyaProvider<LeagueApi.Matches>()
    private(set) var roleClassifier: RoleClassifier? = nil

    init(match: Match) {
        self.initialMatchParameter = match

        for i in (1...10) {
            //When the drag gesture happens, a new value is requested to show the values of the chart where the finger is.
            chart_currentValueHandlers[i].$valueAtRequest
                .sink { [weak self] in
                    guard let self = self else { return }
                    var newArray = self.chart_currentValuesForDragGesture
                    newArray[i] = $0
                    self.chart_currentValuesForDragGesture = newArray
                }
                .store(in: &cancellableBag)
        }

        match.$details
            .removeDuplicates(by: { $0?.participants.map { $0.participantId } == $1?.participants.map { $0.participantId } })
            .sink { [weak self] details in
                guard
                    let self = self,
                    let details = details
                else { return }

                print(details.participants.map { $0.championId })
                self.participants = details.participants
            }
            .store(in: &cancellableBag)

        self.setupTimelineSubscription()
    }

    public func requestTimeline(for match: Match) {
        timelineProvider.requestPublisher(.timeline(region: .euw, matchId: match.gameId))
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .map { $0.data }
            .decode(type: MatchTimeline.self, decoder: JSONDecoder())
            .mapError(NetworkRequestError.transformDecodableNetworkErrorStream(error:))
            .sink(receiveCompletion: { completionType in
                print(completionType)
                //TODO error handling
            }) { [weak self] timeline in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.timeline = timeline
                    self.isWorking = true
                }
            }
            .store(in: &self.cancellableBag)
    }

    private func reshuffleParticipantsToMatchLaneOrder() {
        guard roles?.count == 10 && lanes?.count == 10 else { return } //only reshuffle on summoner's rift.

        let newParticipantOrder = self.participants!.sorted(by: { p1, p2 in
            if lanes![p1.participantId]!!.rankedPosition != lanes![p2.participantId]!!.rankedPosition {
                return lanes![p1.participantId]!!.rankedPosition < lanes![p2.participantId]!!.rankedPosition
            }

            return roles![p1.participantId]!!.positionId < roles![p2.participantId]!!.positionId
        })

        initialMatchParameter.details!.participants = newParticipantOrder
        self.match = initialMatchParameter
    }

    private func setupTimelineSubscription() {
        $timeline
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .sink { [weak self] timeline in
                guard
                    let self = self,
                    let timeline = timeline
                else { return }

                let newRoleClassifier = RoleClassifier(from: self.participants!, with: timeline)
                DispatchQueue.main.async {
                    self.roleClassifier = newRoleClassifier
                }

                let predictedRolesAndLanes = newRoleClassifier.predict()
                let predictedLanes = Dictionary<Int, Lane?>(uniqueKeysWithValues: predictedRolesAndLanes.map { ($0.key, $0.value?.0) })
                let predictedRoles = Dictionary<Int, Role?>(uniqueKeysWithValues: predictedRolesAndLanes.map { ($0.key, $0.value?.1) })

                DispatchQueue.main.async {
                    self.lanes = predictedLanes
                    self.roles = predictedRoles
                    self.reshuffleParticipantsToMatchLaneOrder()
                    self.isWorking = false
                }
            }
            .store(in: &cancellableBag)
    }
}
