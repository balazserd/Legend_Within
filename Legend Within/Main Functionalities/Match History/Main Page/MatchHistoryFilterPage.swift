//
//  MatchHistoryFilterPage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 09..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension MatchHistoryPage {
    struct MatchHistoryFilterPage: View {
        @ObservedObject var model: MatchHistoryModel

        var body: some View {
            Form {
                Section {
                    Picker(selection: $model.matchTypesToFetch,
                           label: Text("Match types")) {
                        ForEach(MatchHistoryModel.MatchTypesToFetch.allCases, id: \.hashValue) { option in
                            Text(option.description).tag(option)
                        }
                    }
                }
            }
            .navigationBarTitle("Filter", displayMode: .inline)
        }
    }
}
