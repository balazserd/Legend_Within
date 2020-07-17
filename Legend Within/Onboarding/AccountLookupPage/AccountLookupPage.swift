//
//  AccountLookupPage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct AccountLookupPage: View {
    @ObservedObject private var accountLookupModel = AccountLookupModel()

    var body: some View {
        VStack {
            Spacer()

            Picker("", selection: $accountLookupModel.region) {
                ForEach(Region.allCases, id: \.self.rawValue) { region in
                    Text(region.shortName).tag(region)
                }
            }.pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 15)

            TextField("Summoner name", text: $accountLookupModel.summonerName)
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Spacer()
        }
        .padding()
        .overlay(loadingOverlay)
        .overlay(summonerQueryResultOverlay)
    }

    @ViewBuilder
    private var summonerQueryResultOverlay: some View {
        if accountLookupModel.errorCode == nil
            && accountLookupModel.summoner != nil {
            SummonerFoundOverlay(accountLookupModel: self.accountLookupModel)
        } else {
            if accountLookupModel.errorCode == 404 {
                SummonerNotFoundOverlay(accountLookupModel: self.accountLookupModel)
            } else if accountLookupModel.errorCode != nil {
                UnknownErrorOverlay(accountLookupModel: self.accountLookupModel)
            }
        }
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        if accountLookupModel.isQuerying {
            ZStack(alignment: .center) {
                HStack {
                    Text("Looking for Summoner...").bold()
                    ActivityIndicator(isSpinning: $accountLookupModel.isQuerying)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
        }
    }
}

struct AccountLookupPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccountLookupPage()
        }
    }
}
