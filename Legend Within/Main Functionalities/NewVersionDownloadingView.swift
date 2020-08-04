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

    var body: some View {
        VStack {
            Text("New version is being downloaded. Please wait...")
            if updateProgress.championsJSONProgress.isLess(than: 1.0) {
                Text("Downloading champion list - \(Int(updateProgress.championsJSONProgress * 100))%")
            } else {
                if updateProgress.itemsJSONProgress.isLess(than: 1.0) {
                    Text("Downloading items list - \(Int(updateProgress.itemsJSONProgress * 100))%")
                } else {
                    Text("Downloading individual champions' data - \(Int(updateProgress.championUniqueJSONsProgress * 100))%")
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
