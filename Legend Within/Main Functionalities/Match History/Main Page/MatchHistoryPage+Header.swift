//
//  MatchHistoryPage+Header.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension MatchHistoryPage {
    
    struct Header: View {
        var participant: MatchDetails.Participant
        var match: Match

        var body: some View {
            let gameTime = dateFormatter.string(from: Date(timeIntervalSince1970: Double(match.timestamp / 1000)))
            let gameDuration = match.details?.gameDuration.toHoursMinutesAndSecondsText()

            return HStack {
                HStack(alignment: .bottom, spacing: 3) {
                    Text(participant.stats.win ? "VICTORY" : "DEFEAT")
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(participant.stats.win ? ColorPalette.winningTeamHeader : ColorPalette.losingTeamHeader)

                    Text("in \(gameDuration!)")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .alignmentGuide(.bottom, computeValue: { d in d[.bottom] + 1 })

                    Spacer()
                }

                HStack(alignment: .center) {
                    Text(gameTime)
                        .font(.system(size: 13, design: .monospaced))
                }
            }
        }

        let dateFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, HH:mm"
            return formatter
        }()
    }

}
