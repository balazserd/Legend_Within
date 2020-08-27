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
    private let colorArray: [Color] = [.blue, .green, .orange, .red, .purple, .black, .yellow, .pink, .darkBlue2, .darkGreen5]
    @EnvironmentObject var gameData: GameData

    @State private var selectedPlayer: MatchDetails.Participant? = nil
    @ObservedObject private var model: MatchDetailsModel

    @State private var chart_shownPlayers: [Bool] = Array(repeating: true, count: 11) //ParticipantId is 1-based, we need 11 elements.

    init(match _match: Match) {
        model = MatchDetailsModel(match: _match)
    }

    let wholeNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        return formatter
    }()

    let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, HH:mm"
        return formatter
    }()

    //MARK:- Body
    var body: some View {
        let winningTeam = model.match?.winnerTeam!
        let winningTeamParticipants = model.match?.winnerTeamParticipants!
        let winningTeamParticipantIdentities = model.match?.winnerTeamParticipantIdentities!

        let losingTeam = model.match?.loserTeam!
        let losingTeamParticipants = model.match?.loserTeamParticipants!
        let losingTeamParticipantIdentities = model.match?.loserTeamParticipantIdentities!

        let chartData = model.timeline?.getGoldValues().map { goldValueTimeline in
            LineChartData(values: goldValueTimeline.value.map { (Double($0.key), Double($0.value)) }.sorted(by: { $0.0 < $1.0 }),
                          lineColor: self.colorArray[goldValueTimeline.key - 1],
                          shownAspects: [.line],
                          associatedParticipantId: goldValueTimeline.key)
        }

        return VStack {
            if model.isWorking || model.match == nil {
                Text("Loading")
            } else {
                ScrollView {
                    VStack {
                        VStack {
                            self.generalGameInfo()

                            Divider()

                            VStack {
                                HStack {
                                    Text("WINNING TEAM")
                                        .font(.system(size: 20)).bold()
                                        .foregroundColor(.green)
                                    Spacer()
                                    self.banView(bans: winningTeam!.bans)
                                }
                                .padding(.bottom, -3)

                                self.teamLevelStats(team: winningTeam!)
                                self.teamView(participants: winningTeamParticipants!,
                                              participantIdentities: winningTeamParticipantIdentities!)

                                Divider()

                                HStack {
                                    Text("LOSING TEAM")
                                        .font(.system(size: 20)).bold()
                                        .foregroundColor(.red)
                                    Spacer()
                                    self.banView(bans: losingTeam!.bans)
                                }
                                .padding(.bottom, -3)

                                self.teamLevelStats(team: losingTeam!)
                                self.teamView(participants: losingTeamParticipants!,
                                              participantIdentities: losingTeamParticipantIdentities!)
                            }

                            Divider()

                            ChartView(winningTeamParticipants: winningTeamParticipants!,
                                      losingTeamParticipants: losingTeamParticipants!,
                                      chartData: chartData!,
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

    //MARK:- Body parts

    private func generalGameInfo() -> some View {
        let gameTime = dateFormatter.string(from: Date(timeIntervalSince1970: Double(model.match!.timestamp / 1000)))
        let gameDuration = model.match!.details!.gameDuration.toHoursMinutesAndSecondsText()

        return HStack {
            VStack {
                HStack {
                    Text(gameData.queues[model.match!.queue]!.map)
                        .font(.system(size: 17)).bold()
                    Spacer()
                }
                HStack {
                    Text(gameData.queues[model.match!.queue]!.transformedDescription ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }

            Spacer(minLength: 15)

            VStack {
                HStack {
                    Text("Played at:")
                        .font(.system(size: 14)).bold()
                        Spacer()
                    Text(gameTime)
                        .font(.system(size: 13))
                }

                HStack {
                    Text("Game Time:")
                        .font(.system(size: 14)).bold()
                        Spacer()
                    Text(gameDuration)
                        .font(.system(size: 13))
                }
            }
        }
    }

    private func teamLevelStats(team: MatchDetails.Team) -> some View {
        HStack(spacing: 0) {
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
        .frame(height: 25)
    }

    private func banView(bans: [Ban]) -> some View {
        ForEach(bans, id: \.championId) { ban in
            VStack {
                if ban.championId != -1 {
                    KFImage(FilePaths.championIcon(fileName: self.gameData.champions[ban.championId]!.onlyData().image.full).path)
                        .championImageStyle(width: 30)
                        .opacity(0.9)
                        .overlay(Image("MatchHistoryIcon_BanX")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .offset(x: 10, y: -10))
                }
            }
        }
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
                        self.items(for: participant)
                        self.playerStats(for: participant)
                    }
                    .frame(maxWidth: .infinity)
                })
            }
        }
    }

    private func items(for player: MatchDetails.Participant) -> some View {
        let allItems = player.allItems

        return HStack(spacing: 3) {
            KFImage(FilePaths.itemIcon(id: allItems[6]).path) //Trinket
                .trinketImageStyle(width: 23)

            ForEach(0..<6) { i in
                KFImage(FilePaths.itemIcon(id: allItems[i]).path)
                    .itemImageStyle(width: 23)
            }
        }
    }

    private func playerStats(for player: MatchDetails.Participant) -> some View {
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
