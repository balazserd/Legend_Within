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
                            NavigationLink(destination: MatchDetailsPage(match: match)) {
                                MatchHistoryItem(match: match)
                            }
                        }
                    }

                    HStack {
                        Spacer()
                        if model.isLoadingFirstSetOfMatches || model.isLoadingFurtherSetsOfMatches {
                            LoadingIndicator()
                        } else {
                            Button(action: {
                                self.model.requestMatches()
                            }) {
                                Text("Load more")
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
                .introspectTableView { tableView in
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
        .onAppear {
            if self.model.matchHistory?.matches == nil
            || self.model.matchHistory!.matches.count == 0 {
                self.model.requestMatches()
            }
        }
    }

    private struct LoadingIndicator: View {
        var body: some View {
            HStack {
                Text("Loading matches...")
                    .font(.system(size: 15))

                ActivityIndicator(isSpinning: .constant(true))
            }
        }
    }
}

struct MatchHistoryPage_Previews: PreviewProvider {
    static var previews: some View {
        MatchHistoryPage()
    }
}
