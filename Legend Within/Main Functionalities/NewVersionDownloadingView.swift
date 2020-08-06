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
            Text("New version is being downloaded. Please wait...")

            if !(leagueApi.updatedFailedDueToNoSpace ?? false) {
                Text("Downloading champion list - \(Int(updateProgress.championsJSONProgress * 100))%")
                Text("Downloading items list - \(Int(updateProgress.itemsJSONProgress * 100))%")
                Text("Downloading individual champions' data - \(Int(updateProgress.championUniqueJSONsProgress * 100))%")
                Text("Downloading maps list - \(Int(updateProgress.mapsJSONProgress * 100))%")
                Text("Downloading queues list - \(Int(updateProgress.queuesJSONProgress * 100))%")
                Text("Downloading runes list - \(Int(updateProgress.runesJSONProgress * 100))%")
            } else {
                Text("Cannot update to new version. There is not enough space on your device. Make sure you have at least 20 MB of free space.")
            }
        }
    }
}

struct NewVersionDownloadingView_Previews: PreviewProvider {
    static var previews: some View {
        NewVersionDownloadingView()
    }
}
