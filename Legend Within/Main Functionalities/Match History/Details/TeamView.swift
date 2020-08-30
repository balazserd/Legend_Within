//
//  TeamView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 30..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

extension MatchDetailsPage {
    struct TeamView: View {
        @EnvironmentObject var gameData: GameData

        var team: MatchDetails.Team
        var teamParticipants: [MatchDetails.Participant]
        var teamParticipantIds: [MatchDetails.ParticipantIdentity]

        var body: some View {
            VStack {
                TeamStatsView(team: team)

                ForEach<[MatchDetails.Participant], Int, AnyView>(teamParticipants, id: \.participantId) { participant in
                    let identity = self.teamParticipantIds.first { $0.participantId == participant.participantId }!

                    return AnyView(HStack {
                        HStack(spacing: 3) {
                            KFImage(FilePaths.championIcon(fileName: self.gameData.champions[participant.championId]!.onlyData().image.full).path)
                                .championImageStyle(width: 45)

                            VStack(spacing: 3) {
                                KFImage(FilePaths.summonerSpellIcon(fileName: self.gameData.summonerSpells[participant.spell1Id]!.image.full).path)
                                    .summonerSpellImageStyle(width: 20)
                                KFImage(FilePaths.summonerSpellIcon(fileName: self.gameData.summonerSpells[participant.spell2Id]!.image.full).path)
                                    .summonerSpellImageStyle(width: 20)
                            }

                            VStack(spacing: 3) {
                                KFImage(FilePaths.runeIcon(filePath: participant.keyStone()!.icon).path)
                                    .plainImageStyle(width: 20)
                                KFImage(FilePaths.runeIcon(filePath: participant.secondaryRunePath()!.icon).path)
                                    .plainImageStyle(width: 20)
                            }
                        }

                        VStack {
                            HStack {
                                Text(identity.player.summonerName)
                                    .font(.system(size: 14))
                                    .lineLimit(1).minimumScaleFactor(0.7)
                                Spacer()
                            }

                            HStack {
                                Text("\(participant.stats.kills) / \(participant.stats.deaths) / \(participant.stats.assists)")
                                    .font(.system(size: 16)).bold()
                                    .lineLimit(1).minimumScaleFactor(0.7)
                                Spacer()
                            }
                        }

                        Spacer()

                        VStack(spacing: 3) {
                            PlayerItemsView(player: participant)
                            PlayerStatsView(player: participant)
                        }
                        .frame(maxWidth: .infinity)
                    })
                }
            }
        }
    }
}
