//
//  MatchDetailsPage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct MatchDetailsPage: View {
    @EnvironmentObject var gameData: GameData

    @State private var selectedPlayer: MatchDetails.Participant? = nil
    @ObservedObject private var model: MatchDetailsModel

    @State private var chart_shownPlayers: [Bool] = Array(repeating: true, count: 11) //ParticipantId is 1-based, we need 11 elements.

    init(match _match: Match) {
        model = MatchDetailsModel(match: _match)
    }

    //MARK:- Body
    var body: some View {
        let winningTeam = model.match?.winnerTeam!
        let winningTeamParticipants = model.match?.winnerTeamParticipants!
        let winningTeamParticipantIdentities = model.match?.winnerTeamParticipantIdentities!

        let losingTeam = model.match?.loserTeam!
        let losingTeamParticipants = model.match?.loserTeamParticipants!
        let losingTeamParticipantIdentities = model.match?.loserTeamParticipantIdentities!

        return VStack {
            if model.isWorking || model.match == nil {
                Text("Loading")
            } else {
                ScrollView(.vertical) {
                    VStack {
                        GeneralGameInfoView(model: self.model)

                        Divider()

                        VStack {
                            TeamView(team: winningTeam!,
                                     teamParticipants: winningTeamParticipants!,
                                     teamParticipantIds: winningTeamParticipantIdentities!)

                            TeamView(team: losingTeam!,
                                     teamParticipants: losingTeamParticipants!,
                                     teamParticipantIds: losingTeamParticipantIdentities!)
                        }

                        Divider()

                        if model.chartData != nil {
                            ChartView(winningTeamParticipants: winningTeamParticipants!,
                                      losingTeamParticipants: losingTeamParticipants!,
                                      chartData: model.chartData!,
                                      model: self.model,
                                      visiblePlayers: self.$chart_shownPlayers)
                        }
                    }
                    .padding(15)
                }
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
        .onAppear {
            self.model.requestTimeline(for: self.model.initialMatchParameter)
        }
    }
}

extension MatchDetailsPage {
    struct ColorPalette {
        static let winningTeamHeader = Color("winningTeam_Header")
        static let winningTeamPlayerRow = Color("winningTeam_PlayerRow")

        static let losingTeamHeader = Color("losingTeam_Header")
        static let losingTeamPlayerRow = Color("losingTeam_PlayerRow")

        static let selectedFilter = Color("selectedFilter")
        static let selectedFilterUIColor = UIColor(named: "selectedFilter")!

        static let chartAreaBackground = Color("chartAreaBackground")
        static let chartContainerBackground = Color("chartContainerBackground")
        static let chartFilterOptionsContainer = Color("chartFilterOptionsContainer")

        static let timelineTitle = Color("timelineTitle")
    }
}
