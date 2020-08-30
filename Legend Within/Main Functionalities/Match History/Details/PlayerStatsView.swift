//
//  PlayerStatsView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 30..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension MatchDetailsPage {

    struct PlayerStatsView: View {
        var player: MatchDetails.Participant

        var body: some View {
            HStack {
                HStack(spacing: 4) {
                    IconSprites.playerStat(type: .gold).image().plainImageStyle(width: 14)
                    Text("\(self.wholeNumberFormatter.string(from: NSNumber(value: player.stats.goldEarned))!)")
                        .font(.system(size: 14)).bold()
                        .lineLimit(1).minimumScaleFactor(0.8)
                    Spacer(minLength: 1)
                }
                .frame(width: 75)

                HStack(spacing: 4) {
                    IconSprites.playerStat(type: .minion).image().plainImageStyle(width: 14)
                    Text("\(self.wholeNumberFormatter.string(from: NSNumber(value: player.stats.totalMinionsKilled))!)")
                        .font(.system(size: 14)).bold()
                        .lineLimit(1).minimumScaleFactor(0.8)
                    Spacer(minLength: 1)
                }
                .frame(width: 55)

                HStack(spacing: 4) {
                    Image("icon_damage")
                        .plainImageStyle(width: 14)
                    Text("\(Int(player.stats.totalDamageDealtToChampions / 1000))K")
                        .font(.system(size: 14)).bold()
                        .lineLimit(1).minimumScaleFactor(0.8)
                    Spacer(minLength: 1)
                }
            }
        }

        let wholeNumberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.usesGroupingSeparator = true
            formatter.groupingSeparator = ","
            return formatter
        }()
    }
    
}
