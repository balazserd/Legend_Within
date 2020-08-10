//
//  MatchHistoryPage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import Introspect

struct MatchHistoryPage: View {
    @ObservedObject var model = MatchHistoryModel()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(model.matchHistory?.matches ?? [], id: \.gameId) { match in
                        ZStack {
                            NavigationLink(destination: MatchDetailsPage()) {
                                MatchHistoryItem(match: match)
                            }
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
                .introspectTableView { tableView in
//                    tableView.separatorStyle = .none
                    tableView.tableFooterView = UIView()
                }
            }
            .navigationBarItems(trailing:
                HStack {
                    NavigationLink(destination: MatchHistoryFilterPage(model: model)) {
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
