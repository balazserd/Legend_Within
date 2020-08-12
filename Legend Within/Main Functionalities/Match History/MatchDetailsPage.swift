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
    var match: Match

    var body: some View {
        let winningTeam = match.winnerTeam!
        let winningTeamParticipants = match.winnerTeamParticipants!
        let winningTeamParticipantIdentities = match.winnerTeamParticipantIdentities!

        let losingTeam = match.loserTeam!
        let losingTeamParticipants = match.loserTeamParticipants!
        let losingTeamParticipantIdentities = match.loserTeamParticipantIdentities!

        return ScrollView {
            VStack {
                VStack {
                    Divider()

                    HStack {
                        Text("WINNING TEAM")
                            .bold()
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .padding(.bottom, -3)

                    self.teamView(participants: winningTeamParticipants,
                                  participantIdentities: winningTeamParticipantIdentities)

                    Divider()

                    HStack {
                        Text("LOSING TEAM")
                            .bold()
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .padding(.bottom, -3)

                    self.teamView(participants: losingTeamParticipants,
                                  participantIdentities: losingTeamParticipantIdentities)

                    Divider()

                    HStack {
                        self.banView(bans: winningTeam.bans)

                        Spacer()

                        self.teamLevelStats

                        Spacer()

                        self.banView(bans: losingTeam.bans)
                    }
                }
            }
            .padding(15)
        }
        .navigationBarTitle("Details", displayMode: .inline)
    }

    @ViewBuilder
    private var teamLevelStats: some View {
        HStack(spacing: 12) {
            Spacer()
            VStack {
                Text(" ")
                    .font(.system(size: 16))
                    .bold()

                Spacer(minLength: 15)

                VStack(spacing: 17.5) {
                    Text("\(self.match.winnerTeam!.towerKills)")
                    Text("\(self.match.winnerTeam!.inhibitorKills)")
                    Text("\(self.match.winnerTeam!.dragonKills)")
                    Text("\(self.match.winnerTeam!.riftHeraldKills)")
                    Text("\(self.match.winnerTeam!.baronKills)")
                }

                Spacer(minLength: 5)
            }

            VStack {
                Text("STATISTICS")
                    .font(.system(size: 16))
                    .bold()

                Spacer(minLength: 15)

                VStack(spacing: 17.5) {
                    Text(MatchDetails.Team.keyPathToString(keyPath: \.towerKills)).font(.system(size: 17)).bold()
                    Text(MatchDetails.Team.keyPathToString(keyPath: \.inhibitorKills)).font(.system(size: 17)).bold()
                    Text(MatchDetails.Team.keyPathToString(keyPath: \.dragonKills)).font(.system(size: 17)).bold()
                    Text(MatchDetails.Team.keyPathToString(keyPath: \.riftHeraldKills)).font(.system(size: 17)).bold()
                    Text(MatchDetails.Team.keyPathToString(keyPath: \.baronKills)).font(.system(size: 17)).bold()
                }

                Spacer(minLength: 1)
            }


            VStack {
                Text(" ")
                    .font(.system(size: 16))
                    .bold()

                Spacer(minLength: 15)

                VStack(spacing: 17.5) {
                    Text("\(self.match.loserTeam!.towerKills)")
                    Text("\(self.match.loserTeam!.inhibitorKills)")
                    Text("\(self.match.loserTeam!.dragonKills)")
                    Text("\(self.match.loserTeam!.riftHeraldKills)")
                    Text("\(self.match.loserTeam!.baronKills)")
                }

                Spacer(minLength: 1)
            }
            Spacer()
        }
    }

    private func banView(bans: [Ban]) -> some View {
        VStack {
            HStack {
                Text("BANS")
                    .font(.system(size: 16))
                    .bold()
            }
            .padding(.bottom, -3)

            ForEach(bans, id: \.pickTurn) { ban in
                HStack {
                    if ban.championId == -1 {
                        Image("MatchHistoryIcon_NoBan")
                            .championImageStyle(width: 30)
                            .scaleEffect(0.9) //make it a bit smaller
                    } else {
                        KFImage(FilePaths.championIcon(fileName: self.gameData.champions[ban.championId]!.onlyData().image.full).path)
                            .championImageStyle(width: 30)
                    }
                }
            }

            Spacer()
        }
        .frame(maxWidth: 50)
    }

    private func teamView(participants: [MatchDetails.Participant],
                          participantIdentities: [MatchDetails.ParticipantIdentity]) -> some View {
        VStack {
            ForEach<[MatchDetails.Participant], Int, AnyView>(participants, id: \.participantId) { participant in
                let identity = participantIdentities.first { $0.participantId == participant.participantId }!

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
                                .runeImageStyle(width: 20)
                            KFImage(FilePaths.runeIcon(filePath: participant.secondaryRunePath()!.icon).path)
                                .runeImageStyle(width: 20)
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
                })
            }
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
