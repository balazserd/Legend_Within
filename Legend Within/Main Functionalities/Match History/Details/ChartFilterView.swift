//
//  ChartFilterView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 27..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

extension MatchDetailsPage {
    struct ChartFilterView: View {
        @EnvironmentObject var gameData: GameData
        var participants: [MatchDetails.Participant]
        var model: MatchDetailsModel
        @Binding var visiblePlayers: [Bool]

        var body: some View {
            GeometryReader { proxy in
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        ForEach(self.participants, id: \.participantId) { participant in
                            VStack {
                                KFImage(FilePaths.championIcon(fileName: self.gameData.champions[participant.championId]!.onlyData().image.full).path)
                                    .championImageStyle(width: 32)
                                    .opacity(self.visiblePlayers[participant.participantId] ? 1 : 0.5)
                                    .onTapGesture {
                                        self.visiblePlayers[participant.participantId].toggle()
                                    }
                            }
                            .frame(width: self.calculateImageWidthInImageRow(for: proxy))
                        }
                    }

                    HStack(spacing: 4) {
                        if self.model.requestedSumType == .playerBased {
                            ForEach(self.participants, id: \.participantId) { participant in
                                VStack {
                                    if self.model.chart_currentValuesForDragGesture[participant.participantId] != nil {
                                        self.valueText(for: self.model.chart_currentValuesForDragGesture[participant.participantId]!)
                                            .frame(width: 32, height: 18)
                                            .foregroundColor(self.model.colorForParticipantId(participant.participantId))
                                    } else {
                                        Text(" ")
                                            .font(.system(size: 14))
                                            .frame(width: 32, height: 18)
                                    }
                                }
                            }
                        } else {
                            Spacer()
                            if self.model.chart_currentValuesForDragGesture.filter { $0 != nil }.count > 0 {
                                self.valueText(for: self.model.chart_currentValuesForDragGesture[self.participants[0].teamId / 100]!)
                                    .frame(height: 18)
                                    .foregroundColor(self.model.colorForTeamId(self.participants[0].teamId))
                            } else {
                                Text(" ")
                                .font(.system(size: 14))
                                .frame(height: 18)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .frame(height: 54) //32 + 4 + 18 
        }

        private func valueText(for value: Double) -> some View {
            let numberFormatter: NumberFormatter
            let willBeDividedBy1000: Bool
            if !value.isLess(than: 100.0 * 1000) {
                numberFormatter = self.bigNumberFormatter
                willBeDividedBy1000 = true
            } else {
                if !value.isLess(than: 1000.0) {
                    numberFormatter = self.mediumNumberFormatter
                    willBeDividedBy1000 = true
                } else {
                    numberFormatter = self.tinyNumberFormatter
                    willBeDividedBy1000 = false
                }
            }

            let nsNumber = NSNumber(value: value / (willBeDividedBy1000 ? 1000.0 : 1.0))

            return HStack(alignment: .bottom, spacing: 0) {
                Text("\(numberFormatter.string(from: nsNumber)!)")
                    .font(.system(size: 14)).bold()
                    .minimumScaleFactor(0.7).lineLimit(1)
                if willBeDividedBy1000 {
                    Text("k")
                        .font(.system(size: 12))
                        .minimumScaleFactor(0.7).lineLimit(1)
                }
            }
        }

        private func calculateImageWidthInImageRow(for proxy: GeometryProxy) -> CGFloat {
            let playerCountAsCGFloat = CGFloat(self.participants.count)
            return (proxy.size.width - (playerCountAsCGFloat - 1) * 4) / playerCountAsCGFloat //4 is the HStack spacing.
        }

        private let tinyNumberFormatter: NumberFormatter = {
            var formatter = NumberFormatter()
            formatter.maximumFractionDigits = 0
            return formatter
        }()

        private let mediumNumberFormatter: NumberFormatter = {
            var formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            formatter.minimumFractionDigits = 1
            return formatter
        }()
        private let bigNumberFormatter: NumberFormatter = {
            var formatter = NumberFormatter()
            formatter.maximumFractionDigits = 0
            return formatter
        }()
    }
}
