//
//  MatchHistoryPage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct MatchHistoryPage: View {
    @ObservedObject var model = MatchHistoryModel()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(model.matchHistory?.matches ?? [], id: \.gameId) { match in
                        NavigationLink(destination: MatchDetailsPage()) {
                            MatchHistoryItem(match: match)
                        }
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            self.model.requestMatches(beginIndex: 0, endIndex: 20)
                        }) {
                            Text("Load more")
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        /* TODO */
                    }) {
                        Text("Filter")
                    }
                }
            )
            .navigationBarTitle(Text("Match History"))
        }
    }
}

struct MatchHistoryPage_Previews: PreviewProvider {
    static var previews: some View {
        MatchHistoryPage()
    }
}
