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
            ZStack(alignment: .center) {
                VStack {
                    Text("Could not find summoner!")
                        .foregroundColor(.blue)
                        .bold()
                        .font(.system(size: 17))
                        .padding(.vertical, 15)

                    Text("Please check that you have no typos and you selected the correct region.")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 30)

                    Button(action: {
                        self.accountLookupModel.summoner = nil
                        self.accountLookupModel.errorCode = nil
                    }, label: {
                        HStack {
                            Spacer()
                            Text("OK").font(.system(size: 17)).bold()
                            Spacer()
                        }
                    })
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.4))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                }
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 12).padding(.top, 12)
                .shadow(color: Color.gray, radius: 6, x: 0, y: 3)
                .modifier(CustomViewModifiers.FloatIn(whenTrue: $isShown))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
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
