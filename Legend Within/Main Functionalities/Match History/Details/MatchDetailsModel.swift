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
    @Published var canReceiveTimelineValues: Bool = false
    @Published var roles: [Int : Role?]? = nil
    @Published var lanes: [Int : Lane?]? = nil
    @Published var participants: [MatchDetails.Participant]? = nil
    @Published var isWorking: Bool = false
    @Published var match: Match? = nil
    var initialMatchParameter: Match

    @Published var requestedStatType: TimelineStatType? = nil
    @Published var requestedSumType: SumType? = nil
    var needsNewChartData = PassthroughSubject<(SumType, TimelineStatType), Never>()
    @Published var chartData: [LineChartData]? = nil
    @Published var chart_currentValuesForDragGesture: [Double?] = Array(repeating: nil, count: 11) //1-based array.
    var chart_currentValueHandlers: [GestureValueHandler] = (0...10).map { _ in GestureValueHandler() } //1-based array.

    private var cancellableBag = Set<AnyCancellable>()
    private let timelineProvider = MoyaProvider<LeagueApi.Matches>()
    private(set) var roleClassifier: RoleClassifier? = nil
    private let colorArray: [Color] = [.green, .orange, .blue, .red, .purple, .black, Color("darkGold"), .gray, .darkBlue2, .darkGreen5]
    func colorForParticipantId(_ id: Int) -> Color { return self.colorArray[id - 1] }
    func colorForTeamId(_ id: Int) -> Color { return self.colorArray[id / 100 - 1] }

    init(match: Match) {
        self.initialMatchParameter = match

        self.setupMatchDetailsSubscription(for: match)
        self.setupTimelineSubscription()
        self.setupChartDataRequestPipeline()
        self.setupChartDragGestureHandlers()
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

                    //Should request initial data
                    self.requestedStatType = .gold
                    self.requestedSumType = .playerBased
                }
            }
            .store(in: &self.cancellableBag)
    }

    //MARK: - Subscriptions and Request Pipelines

    private func setupTimelineSubscription() {
        $canReceiveTimelineValues
            .filter { $0 } //only true values
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.requestTimeline(for: self.initialMatchParameter)
            }
            .store(in: &cancellableBag)

        $timeline
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .compactMap { $0 }
            .sink { [weak self] timeline in
                guard
                    let self = self,
                    let participants = self.participants
                else { return }

                let newRoleClassifier = RoleClassifier(from: participants, with: timeline)
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

    private func setupMatchDetailsSubscription(for match: Match) {
        match.$details
            .removeDuplicates(by: { $0?.participants.map { $0.participantId } == $1?.participants.map { $0.participantId } })
            .compactMap { $0 }
            .sink { [weak self] details in
                self?.participants = details.participants
            }
            .store(in: &cancellableBag)
    }

    private func setupChartDataRequestPipeline() {
        Publishers.CombineLatest($requestedSumType.compactMap { $0 }, $requestedStatType.compactMap { $0 }) //removing nils
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] sumType, statType in
                self?.needsNewChartData.send((sumType, statType))
            }
            .store(in: &cancellableBag)

        needsNewChartData
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] sumType, statType in
                guard
                    let self = self,
                    self.timeline != nil,
                    self.participants != nil
                else { return }

                let values = sumType.mappedValue(self.timeline!.getValues(for: statType.associatedKeyPath), self.participants!)
                let chartData = values.map { timelineValue in
                    LineChartData(values: timelineValue.value.map { (Double($0.key), Double($0.value)) }.sorted(by: { $0.0 < $1.0 }),
                                  lineColor: self.colorArray[timelineValue.key - 1],
                                  shownAspects: [.line],
                                  associatedParticipantId: timelineValue.key)
                }

                DispatchQueue.main.async {
                    self.chartData = chartData
                }
            }
            .store(in: &cancellableBag)
    }

    private func setupChartDragGestureHandlers() {
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
    }

    //MARK:- private accessory functions

    private func reshuffleParticipantsToMatchLaneOrder() {
        guard roles?.count == 10 && lanes?.count == 10 else { return } //only reshuffle in 5v5.

        let newParticipantOrder = self.participants!.sorted(by: { p1, p2 in
            if lanes![p1.participantId]!!.rankedPosition != lanes![p2.participantId]!!.rankedPosition {
                return lanes![p1.participantId]!!.rankedPosition < lanes![p2.participantId]!!.rankedPosition
            }

            return roles![p1.participantId]!!.positionId < roles![p2.participantId]!!.positionId
        })

        initialMatchParameter.details!.participants = newParticipantOrder
        self.match = initialMatchParameter
    }
}
