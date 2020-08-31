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
        typealias StatType = MatchDetailsModel.StatType

        var winningTeamParticipants: [MatchDetails.Participant]
        var losingTeamParticipants: [MatchDetails.Participant]
        var chartData: [LineChartData]
        @ObservedObject var model: MatchDetailsModel
        @Binding var visiblePlayers: [Bool]

        @State private var teamLevelSum: Bool = false
        @State private var roleSelection: [Bool] = Array(repeating: false, count: 5)
        private let positionIconNames = [
            "Position_Challenger-Top",
            "Position_Challenger-Jungle",
            "Position_Challenger-Mid",
            "Position_Challenger-Bot",
            "Position_Challenger-Support",
        ]
        
        var body: some View { 
            VStack {
                HStack {
                    Text("Graphs")
                        .font(.system(size: 17)).bold()
                    Spacer()
                }

                Picker("", selection: $model.requestedStatType) {
                    ForEach(StatType.allCases, id: \.self.rawValue) { type in
                        Text(type.description).tag(type as StatType?) //Unless tag value is cast to optional, this won't work.
                            .frame(height: 20).padding(.vertical, -2)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                HStack { 
                    ForEach(0..<positionIconNames.count) { i in
                        Button(action: {
                            let anotherRoleIsAlreadySelected = self.roleSelection.contains(true)
                            self.roleSelection[i].toggle()

                            if !self.roleSelection.contains(true) {
                                self.visiblePlayers = self.visiblePlayers.map { _ in true }
                            } else {
                                if !anotherRoleIsAlreadySelected {
                                    //if this is the 1st selected role undo all player selections
                                    self.visiblePlayers = self.visiblePlayers.map { _ in false }
                                }
                                self.visiblePlayers[self.winningTeamParticipants[i].participantId] = self.roleSelection[i]
                                self.visiblePlayers[self.losingTeamParticipants[i].participantId] = self.roleSelection[i]
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(self.roleSelection[i] ? 0.25 : 0.15))

                                if self.roleSelection[i] {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.darkGold, lineWidth: 2)
                                }

                                Image(self.positionIconNames[i])
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .padding(2)
                            }
                        }.buttonStyle(PlainButtonStyle())
                    }

                    Button(action: {
                        //Practically a toggle, but ready to use other enum cases in the future.
                        self.model.requestedSumType = self.model.requestedSumType == .teamBased
                            ? .playerBased
                            : .teamBased

                        switch self.model.requestedSumType {
                            case .teamBased:
                                self.roleSelection = self.roleSelection.map { _ in false } //undo role selections
                                self.visiblePlayers = self.visiblePlayers.map { _ in false } //undo player selections
                            case .playerBased:
                                self.visiblePlayers = self.visiblePlayers.map { _ in true } //select all players
                            default: break
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(self.teamLevelSum ? 0.25 : 0.15))

                            if self.model.requestedSumType == .teamBased {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.darkGold, lineWidth: 2)
                            }

                            Text("Teams")
                                .font(.system(size: 14)).bold()
                                .foregroundColor(.darkGold)
                                .frame(height: 25)
                                .padding(2)
                        }
                    }.buttonStyle(PlainButtonStyle())
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
                          dragGestureHandlers: self.model.chart_currentValueHandlers,
                          sumType: self.model.requestedSumType!)
                    .frame(height: 200)
            }
        }
    }
}
