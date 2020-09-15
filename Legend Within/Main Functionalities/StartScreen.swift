//
//  StartScreen.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct StartScreen: View {
    @ObservedObject private var leagueApi = LeagueApi.shared
    @ObservedObject private var onboardingModel = OnboardingModel.shared

    var body: some View {
        ZStack {
            if leagueApi.newVersionExists == nil || leagueApi.newVersionExists! {
                NewVersionDownloadingView()
            } else {
                if onboardingModel.onboardingStatus == .finished {
                    MainWindow()
                } else {
                    OnboardingPage()
                }
            }
        }
    }
}

struct StartScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartScreen()
    }
}
