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
        ZStack {
            NavigationView {
                VStack {
                    List {
                        ForEach(model.matchHistory?.matches ?? [], id: \.gameId) { match in
                            MatchHistoryItem(match: match)
                        }

                        VStack(spacing: 12) {
                            Divider()

                            Button(action: { self.model.requestMatches() }) {
                                Text("Load more")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 7)
                                    .background(RoundedRectangle(cornerRadius: 5)
                                        .fill(ColorPalette.loadMoreButtonBackground)
                                        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 1.5))
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    .introspectTableView { tableView in
                        tableView.tableFooterView = UIView()
                        tableView.separatorStyle = .none
                        UITableViewCell.appearance().selectionStyle = .none
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

            if model.isLoadingFirstSetOfMatches || model.isLoadingFurtherSetsOfMatches {
                LoadingIndicator()
            }
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
            ZStack {
                HStack {
                    Text("Loading matches...")
                        .bold()
                        .font(.system(size: 15))

                    ActivityIndicator(isSpinning: .constant(true))
                }
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.2))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

extension MatchHistoryPage {
    struct ColorPalette {
        static let winningTeamHeader = Color("winningTeam_Header")
        static let winningTeamPlayerRow = Color("winningTeam_PlayerRow")

        static let losingTeamHeader = Color("losingTeam_Header")
        static let losingTeamPlayerRow = Color("losingTeam_PlayerRow")

        static let loadMoreButtonBackground = Color("loadMoreButtonBackground")
    }
}

struct MatchHistoryPage_Previews: PreviewProvider {
    static var previews: some View {
        MatchHistoryPage()
    }
}
