//
//  ChartView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 27..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension MatchDetailsPage {
    struct ChartView: View {
        var winningTeamParticipants: [MatchDetails.Participant]
        var losingTeamParticipants: [MatchDetails.Participant]
        var chartData: [LineChartData]
        var model: MatchDetailsModel
        @Binding var visiblePlayers: [Bool]
        
        var body: some View {
            VStack {
                HStack {
                    Text("Graphs")
                        .font(.system(size: 17)).bold()
                    Spacer()
                }

                HStack {
                    VStack(spacing: 4) {
                        Rectangle().fill(Color.green)
                            .frame(height: 5)
                            .padding(.horizontal, 1)

                        ChartFilterView(participants: winningTeamParticipants,
                                        model: self.model,
                                        visiblePlayers: self.$visiblePlayers)
                    }

                    Divider()

                    VStack(spacing: 4) {
                        Rectangle().fill(Color.red)
                            .frame(height: 5)
                            .padding(.horizontal, 1)

                        ChartFilterView(participants: losingTeamParticipants,
                                        model: self.model,
                                        visiblePlayers: self.$visiblePlayers)
                    }
                }

                LineChart(data: chartData,
                          visibilityMatrix: self.$visiblePlayers,
                          dragGestureHandlers: self.model.chart_currentValueHandlers)
                    .frame(height: 200)
            }
        }
    }
}
