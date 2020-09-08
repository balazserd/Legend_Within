//
//  SummonerNotFoundOverlay.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 17..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension AccountLookupPage {
    struct SummonerNotFoundOverlay: View {
        @ObservedObject var accountLookupModel: AccountLookupModel
        @State private var isShown: Bool = false

        var body: some View {
            VStack {
                VStack(spacing: 10) {
                    HStack {
                        Text("Account not found!")
                            .bold()
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .padding(.horizontal, 13).padding(.vertical, 7)
                        Spacer()
                    }
                    .background(Color.red)
                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)

                    Text("Please check that you have no typos and you selected the correct region.")
                        .font(.system(size: 14))
                        .minimumScaleFactor(0.01)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .padding(.vertical, 5).padding(.horizontal, 13)

                }
                .padding(.bottom, 10)
                .background(Color.lightRed5)
                .cornerRadius(8)
                .shadow(color: Color.gray.opacity(0.4), radius: 6, x: 0, y: 3)
                .padding(.bottom, 3)
            }
            .modifier(CustomViewModifiers.FloatIn(whenTrue: $isShown))
            .onAppear {
                self.isShown = true
            }
        }
    }
}

struct SummonerNotFoundOverlay_Preview : PreviewProvider {
    static var previews: some View {
        Group {
            AccountLookupPage.SummonerNotFoundOverlay(accountLookupModel: AccountLookupModel())
        }
    }
}
