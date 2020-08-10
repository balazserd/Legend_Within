//
//  NewVersionDownloadingView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct NewVersionDownloadingView: View {
    @ObservedObject private var updateProgress = LeagueApi.shared.updateProgress
    @ObservedObject private var leagueApi = LeagueApi.shared

    var body: some View {
        VStack {
            HStack {
                Text("New patch is available!")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(Color.blue5)

            VStack {
                if !(leagueApi.updatedFailedDueToNoSpace ?? false) {
                    HStack {
                        Text("Please wait until new data is downloaded. This can take a few minutes.")
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.red)
                        Spacer()
                    }

                    Divider()
                        .frame(height: 2)
                        .background(Color.lightBlue3)
                        .padding(.horizontal, -15).padding(.bottom, 5)

                    VStack(spacing: 5) {
                        HStack {
                            Text("CHAMPIONS")
                                .font(.system(size: 17)).bold()
                            Spacer()
                        }
                        DownloadRow(downloadingText: "Champion list",
                                    progress: $updateProgress.championsJSONProgress)
                        DownloadRow(downloadingText: "Individual champions' data",
                                    progress: $updateProgress.championUniqueJSONsProgress)
                        DownloadRow(downloadingText: "Champion icons",
                                    progress: $updateProgress.championIconsProgress)
                    }

                    Divider().padding(.bottom, 8)

                    VStack(spacing: 5) {
                        HStack {
                            Text("ITEMS")
                                .font(.system(size: 17)).bold()
                            Spacer()
                        }
                        DownloadRow(downloadingText: "Item list",
                                    progress: $updateProgress.itemsJSONProgress)
                        DownloadRow(downloadingText: "Item icons",
                                    progress: $updateProgress.itemIconsProgress)
                    }

                    Divider().padding(.bottom, 8)

                    VStack(spacing: 5) {
                        HStack {
                            Text("SUMMONER SPELLS")
                                .font(.system(size: 17)).bold()
                            Spacer()
                        }
                        DownloadRow(downloadingText: "Summoner spell list",
                                    progress: $updateProgress.summonerSpellsJSONProgress)
                        DownloadRow(downloadingText: "Summoner spell icons",
                                    progress: $updateProgress.summonerSpellIconsProgress)
                    }

                    Divider().padding(.bottom, 8)

                    VStack(spacing: 5) {
                        HStack {
                            Text("GENERAL DATA")
                                .font(.system(size: 17)).bold()
                            Spacer()
                        }
                        DownloadRow(downloadingText: "Maps",
                                    progress: $updateProgress.mapsJSONProgress)
                        DownloadRow(downloadingText: "Queues",
                                    progress: $updateProgress.queuesJSONProgress)
                        DownloadRow(downloadingText: "Runes",
                                    progress: $updateProgress.runesJSONProgress)
                    }

                } else {
                    Text("Cannot update to new version. There is not enough space on your device. Make sure you have at least 40 MB of free space.")
                }
            }
            .padding(.horizontal, 15).padding(.bottom, 10).padding(.top, 15)
        }
        .cornerRadius(8)
        .background(RoundedRectangle(cornerRadius: 8)
            .fill(Color.lightBlue5)
            .shadow(color: Color.gray.opacity(0.4),
                    radius: 4, x: 0, y: 2))
        .padding(.horizontal, 10)
    }

    private struct DownloadRow : View {
        var downloadingText: String
        @Binding var progress: Double

        var body: some View {
            HStack {
                Text(downloadingText)
                    .font(.system(size: 15))
                Spacer()
                ZStack {
                    LoadingCircle(progressRatio: $progress,
                                  showPercentage: false)
                        .opacity(progress.isLessThanOrEqualTo(0.99999) ? 1 : 0)
                        .frame(width: 25, height: 25)

                    Image("NewVersionDownloadingViewIcon_Done")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .opacity(progress.isLessThanOrEqualTo(0.99999) ? 0 : 1)
                }
            }
        }
    }
}

struct NewVersionDownloadingView_Previews: PreviewProvider {
    static var previews: some View {
        NewVersionDownloadingView()
    }
}
