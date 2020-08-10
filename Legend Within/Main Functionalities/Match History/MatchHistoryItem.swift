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

struct MatchHistoryItem: View {
    @EnvironmentObject var gameData: GameData
    @ObservedObject var match: Match

    let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, HH:mm"
        return formatter
    }()

    var body: some View {
        let participant = match.details(for: Summoner.getCurrent())

        let itemIdsFirstRow = participant?.firstThreeItemIds
        let itemIdsSecondRow = participant?.secondThreeItemIds
        let trinketItemId = participant?.stats.item6

        let gameTime = dateFormatter.string(from: Date(timeIntervalSince1970: Double(match.timestamp / 1000)))
        let gameDuration = match.details?.gameDuration.toHoursMinutesAndSecondsText()

        let championIconName = gameData.champions[(match.champion)]!.onlyData().image.full

        return HStack(spacing: 3) {
            if gameData.champions.count == 0
                || gameData.items.count == 0
                || gameData.runePaths.count == 0
                || gameData.maps.count == 0
                || gameData.queues.count == 0
                || gameData.summonerSpells.count == 0 {
                EmptyView()
            } else {
                if participant != nil {
                    VStack(spacing: 3.5) {
                        KFImage(FilePaths.championIcon(fileName: championIconName).path)
                            .bigItemImageStyle()

                        HStack(spacing: 4) {
                            KFImage(FilePaths.summonerSpellIcon(fileName: gameData.summonerSpells[participant!.spell1Id]!.image.full).path)
                                .smallItemImageStyle()

                            KFImage(FilePaths.summonerSpellIcon(fileName: gameData.summonerSpells[participant!.spell2Id]!.image.full).path)
                                .smallItemImageStyle()
                        }
                    }
                    .padding(.trailing, 5)

                    VStack(spacing: 0) {
                        HStack {
                            HStack(alignment: .bottom, spacing: 3) {
                                Text(participant!.stats.win ? "VICTORY" : "DEFEAT")
                                    .font(.system(size: 18))
                                    .bold()
                                    .foregroundColor(participant!.stats.win ? Color.green5 : Color.red3)

                                Text("in \(gameDuration!)")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .alignmentGuide(.bottom, computeValue: { d in d[.bottom] + 1 })

                                Spacer()

                                Text(gameTime)
                                    .font(.system(size: 13, design: .monospaced))
                            }
                        }

                        Divider()
                            .opacity(0.7)
                            .padding(.top, 2).padding(.bottom, 5)

                        HStack {
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
                                    HStack(spacing: 0) {
                                        Image("MatchHistoryIcon_Kill")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .padding(.trailing, 3)
                                        Text("\(participant!.stats.kills)")
                                            .font(.system(size: 15))
                                            .lineLimit(1)
                                        Spacer(minLength: 0.5)
                                    }
                                    .frame(width: 40)
                                    .padding(.trailing, 3)

                                    HStack(spacing: 0) {
                                        Image("MatchHistoryIcon_Death")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .padding(.trailing, 3)
                                        Text("\(participant!.stats.deaths)")
                                            .font(.system(size: 15))
                                            .lineLimit(1)
                                        Spacer(minLength: 0.5)
                                    }
                                    .frame(width: 40)
                                    .padding(.trailing, 3)

                                    HStack(spacing: 0) {
                                        Image("MatchHistoryIcon_Assist")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .padding(.trailing, 3)
                                        Text("\(participant!.stats.assists)")
                                            .font(.system(size: 15))
                                            .lineLimit(1)
                                        Spacer(minLength: 0.5)
                                    }
                                    .frame(width: 40)

                                    Spacer()
                                }
                            }
                            .padding(.top, -1)

                            Spacer()

                            VStack {
                                HStack(spacing: 3) {
                                    VStack {
                                        Spacer()
                                        if trinketItemId != nil {
                                            KFImage(FilePaths.itemIcon(id: trinketItemId!).path)
                                                .smallItemImageStyle()
                                        }
                                        Spacer()
                                    }

                                    VStack(spacing: 3) {
                                        HStack(spacing: 3) {
                                            if itemIdsFirstRow != nil {
                                                KFImage(FilePaths.itemIcon(id: itemIdsFirstRow![0]!).path).smallItemImageStyle()
                                                KFImage(FilePaths.itemIcon(id: itemIdsFirstRow![1]!).path).smallItemImageStyle()
                                                KFImage(FilePaths.itemIcon(id: itemIdsFirstRow![2]!).path).smallItemImageStyle()
                                            }
                                        }
                                        HStack(spacing: 3) {
                                            if itemIdsSecondRow != nil {
                                                KFImage(FilePaths.itemIcon(id: itemIdsSecondRow![0]!).path).smallItemImageStyle()
                                                KFImage(FilePaths.itemIcon(id: itemIdsSecondRow![1]!).path).smallItemImageStyle()
                                                KFImage(FilePaths.itemIcon(id: itemIdsSecondRow![2]!).path).smallItemImageStyle()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

private extension KFImage {
    func smallItemImageStyle() -> some View {
        self.itemImageStyle(width: 25)
            .background(RoundedRectangle(cornerRadius: 3).fill(Color.gray).opacity(0.3))
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.black, lineWidth: 1.5))
    }

    func bigItemImageStyle() -> some View {
        self.itemImageStyle(width: 55)
    }

    private func itemImageStyle(width w: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: w, height: w)
            .cornerRadius(3)
    }
}

struct MatchHistoryItem_Previews: PreviewProvider {
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

        return MatchHistoryItem(match: match)
    }
}
