//
//  MatchHistoryPage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct MatchHistoryPage: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    NavigationLink(destination: MatchDetailsPage()) {
                        MatchHistoryItem()
                    }

                    HStack {
                        Spacer()
                        Button(action: { /*TODO*/ }) {
                            Text("Load more")
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarItems(trailing:
                HStack {
                    Button(action: { /*TODO */ }) {
                        Text("Filter")
                    }
                }
            )
            .navigationBarTitle("Match History")
        }
    }
}

struct MatchHistoryPage_Previews: PreviewProvider {
    static var previews: some View {
        MatchHistoryPage()
    }
}
