//
//  UnknownErrorOverlay.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 17..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension AccountLookupPage {
    struct UnknownErrorOverlay: View {
        @ObservedObject var accountLookupModel: AccountLookupModel
        @State private var isShown: Bool = false

        var body: some View {
            ZStack(alignment: .center) {
                VStack {
                    Text("An unknown error occurred.")
                        .foregroundColor(.blue)
                        .bold()
                        .font(.system(size: 17))
                        .padding(.bottom, 8)
                    Text("Please try again later.")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)

                    Button(action: {
                        self.accountLookupModel.summoner = nil
                        self.accountLookupModel.errorCode = nil
                    }, label: {
                        Text("OK")
                    })
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
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

struct UnknownErrorOverlay_Preview : PreviewProvider {
    static var previews: some View {
        Group {
            AccountLookupPage.UnknownErrorOverlay(accountLookupModel: AccountLookupModel())
        }
    }
}
