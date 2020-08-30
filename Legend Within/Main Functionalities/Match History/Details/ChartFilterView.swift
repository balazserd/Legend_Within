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
            HStack(spacing: 4) {
                ForEach(participants, id: \.participantId) { participant in
                    VStack(spacing: 3) {
                        KFImage(FilePaths.championIcon(fileName: self.gameData.champions[participant.championId]!.onlyData().image.full).path)
                            .championImageStyle(width: 32)
                            .opacity(self.visiblePlayers[participant.participantId] ? 1 : 0.5)
                            .onTapGesture {
                                self.visiblePlayers[participant.participantId].toggle()
                            }

                        if self.model.chart_currentValuesForDragGesture[participant.participantId] != nil {
                            self.valueText(for: self.model.chart_currentValuesForDragGesture[participant.participantId]! / 1000)
                                .frame(width: 32, height: 18)
                        } else {
                            Text(" ")
                                .font(.system(size: 14))
                                .frame(width: 32, height: 18)
                        }
                    }
                    .frame(width: 34)
                }
            }
        }

        private func valueText(for value: Double) -> some View {
            let numberFormatter = !value.isLess(than: 100.0) ? self.bigNumberFormatter : self.smallNumberFormatter
            let nsNumber = NSNumber(value: value)

            return HStack(alignment: .bottom, spacing: 0) {
                Text("\(numberFormatter.string(from: nsNumber)!)")
                    .font(.system(size: 14))
                    .minimumScaleFactor(0.7).lineLimit(1)
                Text("k")
                    .font(.system(size: 12))
                    .minimumScaleFactor(0.7).lineLimit(1)
            }
        }

        private let smallNumberFormatter: NumberFormatter = {
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
