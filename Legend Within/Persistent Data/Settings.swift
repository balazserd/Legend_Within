//
//  Settings.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

struct Settings {
    //MARK: Persistent Store keys
    static let summonerKey = "settings.summoner"
    static let regionKey = "settings.region"
    
    static let onboardingStatusKey = "settings.onboarding.status"

    //MARK: League Api stuff
    static let currentDownloadedVersion = "leagueApi.currentDownloadedVersion"

    //MARK: Constants used throughout the app
    static let supportEmailAddress = "ebuniapps@gmail.com"
}
