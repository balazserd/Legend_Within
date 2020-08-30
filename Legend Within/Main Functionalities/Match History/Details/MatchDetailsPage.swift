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
            if model.isWorking || model.match == nil || model.chartData == nil {
                Text("Loading")
            } else {
                ScrollView {
                    VStack {
                        VStack {
                            GeneralGameInfoView(model: self.model)

                            Divider()

                            VStack {
                                HStack {
                                    Text("WINNING TEAM")
                                        .font(.system(size: 20)).bold()
                                        .foregroundColor(.green)
                                    Spacer()
                                    BansView(bans: winningTeam!.bans)
                                }
                                .padding(.bottom, -3)

                                TeamView(team: winningTeam!,
                                         teamParticipants: winningTeamParticipants!,
                                         teamParticipantIds: winningTeamParticipantIdentities!)

                                Divider()

                                HStack {
                                    Text("LOSING TEAM")
                                        .font(.system(size: 20)).bold()
                                        .foregroundColor(.red)
                                    Spacer()
                                    BansView(bans: losingTeam!.bans)
                                }
                                .padding(.bottom, -3)

                                TeamView(team: losingTeam!,
                                         teamParticipants: losingTeamParticipants!,
                                         teamParticipantIds: losingTeamParticipantIdentities!)
                            }

                            Divider()

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

struct MatchDetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        let decoder = JSONDecoder()
        guard
            let url_match = Bundle.main.url(forResource: "MatchExample",
                                                  withExtension: "json"),
            let url_matchDetails = Bundle.main.url(forResource: "MatchDetailsExample",
                                                        withExtension: "json")
            else { fatalError() }

        let match = try! decoder.decode(Match.self, from: Data(contentsOf: url_match))
        let matchDetails = try! decoder.decode(MatchDetails.self, from: Data(contentsOf: url_matchDetails))

        match.details = matchDetails

        return MatchDetailsPage(match: match)
    }
}
