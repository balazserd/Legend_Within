//
//  MatchHistoryItem.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import Combine

extension MatchHistoryPage {
    struct MatchHistoryItem: View {
        @EnvironmentObject var gameData: GameData

        var match: Match // DO NOT MAKE THIS AN OBSERVABLEOBJECT OR YOU WILL SUFFER! (it will call NavigationLink destination a second time, which cannot and should not trigger a new timeline request)

        @GestureState private var pressed: Bool = false
        @State private var showingDetails: Bool = false

        var body: some View {
            let participant = match.participantDetails(for: Summoner.getCurrent())

            return ZStack {
                NavigationLink(destination: MatchDetailsPage(match: match), isActive: $showingDetails) {
                    HStack(spacing: 3) {
                        if !gameDataIsReady() {
                            EmptyView()
                        } else {
                            if match.details != nil {
                                LeftSide(participant: participant!)
                                    .padding(.trailing, 5)

                                VStack(spacing: 0) {
                                    Header(participant: participant!, match: match)

                                    Divider()
                                        .opacity(0.7)
                                        .padding(.top, 2).padding(.bottom, 5)

                                    HStack {
                                        MiddlePart(participant: participant!, match: match)
                                            .padding(.top, -1)

                                        Spacer()

                                        RightSide(participant: participant!)
                                    }
                                }
                            }
                        }
                    }
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .fill(participant?.stats.win ?? true ? ColorPalette.winningTeamPlayerRow : ColorPalette.losingTeamPlayerRow)
                        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 1.5))
                    .padding(.trailing, -15)
                    .zIndex(.infinity)
                }

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(showingDetails ? 0.1 : 0.0))
            }
            .gesture(tapToDetailsGesture)
        }

        private var tapToDetailsGesture: some Gesture {
            TapGesture().onEnded {
                self.showingDetails = true
            }
        }

        private func gameDataIsReady() -> Bool {
            let isLoadingAnyPart =
                gameData.champions.count == 0
                || gameData.items.count == 0
                || gameData.runePaths.count == 0
                || gameData.maps.count == 0
                || gameData.queues.count == 0
                || gameData.summonerSpells.count == 0

            return !isLoadingAnyPart
        }
    }
}
