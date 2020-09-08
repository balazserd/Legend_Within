//
//  TeamStatsView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 30..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension MatchDetailsPage {

    struct TeamStatsView: View {
        var team: MatchDetails.Team

        var body: some View {
            HStack(spacing: 0) { [team] in
                GeometryReader { proxy in
                    HStack {
                        HStack {
                            IconSprites.teamStat(type: .turret).image().plainImageStyle(width: 20)
                            Text("\(team.towerKills)")
                            Spacer()
                        }
                        .frame(width: proxy.size.width / 5)

                        HStack {
                            IconSprites.teamStat(type: .inhibitor).image().plainImageStyle(width: 20)
                            Text("\(team.inhibitorKills)")
                            Spacer()
                        }
                        .frame(width: proxy.size.width / 5)

                        HStack {
                            IconSprites.teamStat(type: .dragon).image().plainImageStyle(width: 20)
                            Text("\(team.dragonKills)")
                            Spacer()
                        }
                        .frame(width: proxy.size.width / 5)

                        HStack {
                            IconSprites.teamStat(type: .herald).image().plainImageStyle(width: 20)
                            Text("\(team.riftHeraldKills)")
                            Spacer()
                        }
                        .frame(width: proxy.size.width / 5)

                        HStack {
                            IconSprites.teamStat(type: .baron).image().plainImageStyle(width: 20)
                            Text("\(team.baronKills)")
                            Spacer()
                        }
                        .frame(width: proxy.size.width / 5)
                    }
                }
            }
            .frame(height: 20)
        }
    }

}
