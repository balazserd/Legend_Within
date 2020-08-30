//
//  GeneralGameInfoView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 30..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension MatchDetailsPage {

    struct GeneralGameInfoView: View {
        @EnvironmentObject var gameData: GameData
        
        @ObservedObject var model: MatchDetailsModel

        var body: some View {
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

        let dateFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, HH:mm"
            return formatter
        }()
    }

}
