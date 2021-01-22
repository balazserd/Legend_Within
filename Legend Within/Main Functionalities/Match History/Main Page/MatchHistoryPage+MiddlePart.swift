//
//  MatchHistoryPage+MiddlePart.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension MatchHistoryPage {

    struct MiddlePart: View {
        @EnvironmentObject var gameData: GameData
        
        var participant: MatchDetails.Participant
        var match: Match

        private let statIconNames = ["MatchHistoryIcon_Kill",
                                     "MatchHistoryIcon_Death",
                                     "MatchHistoryIcon_Assist"]

        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Text(gameData.queues[match.queue]!.map)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Spacer()
                }

                HStack {
                    Text(gameData.queues[match.queue]!.transformedDescription ?? "")
                        .font(.system(size: 15))
                    Spacer()
                }

                Spacer(minLength: 5)

                HStack(spacing: 0) {
                    statWithIcon(iconName: "MatchHistoryIcon_Kill", stat: self.participant.stats.kills)
                    statWithIcon(iconName: "MatchHistoryIcon_Death", stat: self.participant.stats.deaths)
                    statWithIcon(iconName: "MatchHistoryIcon_Assist", stat: self.participant.stats.assists)

                    Spacer()
                }
            }
        }

        private func statWithIcon(iconName: String, stat: Int) -> some View {
            HStack(spacing: 0) {
                Image(iconName)
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(.trailing, 3)

                Text("\(stat)")
                    .font(.system(size: 15))
                    .lineLimit(1)

                Spacer(minLength: 0.5)
            }
            .frame(width: 40)
            .padding(.trailing, 3)
        }
    }

}
