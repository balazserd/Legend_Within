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
        ZStack {
            VStack {
                VStack {
                    HStack {
                        Text("Let's begin by specifying the region you play in and your summoner name.")
                            .italic()
                            .font(.system(size: 14))
                        Spacer()
                    }
                    .padding(.bottom, 10)

                    HStack(alignment: .center) {
                        Image("OnboardingIcon_Region")
                            .resizable()
                            .frame(width: 35, height: 35)

                        Picker(selection: $accountLookupModel.region, label: Text("")) {
                            ForEach(Region.allCases, id: \.rawValue) { region in
                                Text("\(region.shortName)").tag(region)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.bottom, 15)

                    HStack {
                        Image("OnboardingIcon_Name")
                            .resizable()
                            .frame(width: 35, height: 35)

                        ZStack {
                            TextField("Summoner name", text: $accountLookupModel.summonerName) {
                                self.dismissKeyboard()
                            }
                            .foregroundColor(.blue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 32)

                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.blue2)
                                .frame(height: 32)
                        }
                        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                }
                .padding()
                .background(Color.lightBlue5)
                .cornerRadius(8)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                .padding(.bottom, 8)

                VStack {
                    summonerQueryResult
                }
                Spacer()
            }
            .padding()

            VStack {
                Spacer()
                HStack {
                    Text("Ready! Swipe to next page!")
                        .font(.system(size: 14))
                        .bold()
                    Image("OnboardingIcon_Check")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(6)
                .shadow(color: Color.gray.opacity(0.4), radius: 6, x: 0, y: 3)
                .offset(x: 0,
                        y: accountLookupModel.errorCode == nil && accountLookupModel.summoner != nil
                            ? -60 : 120)
                    .animation(.easeOut(duration: 0.5))
            }

            loadingOverlay
        }
        .frame(maxWidth: .infinity)
    }

    private func dismissKeyboard() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .first { $0.isKeyWindow }
        keyWindow?.endEditing(true)
    }

    @ViewBuilder
    private var summonerQueryResult: some View {
        if accountLookupModel.errorCode == nil
            && accountLookupModel.summoner != nil {
            SummonerFoundOverlay(accountLookupModel: self.accountLookupModel)
        } else {
            if accountLookupModel.errorCode == 404 {
                SummonerNotFoundOverlay(accountLookupModel: self.accountLookupModel)
            } else if accountLookupModel.localizedErrorDescription != nil {
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
            .edgesIgnoringSafeArea(.all)
        }
    }
}

extension AccountLookupPage : Equatable {
    static func ==(lhs: AccountLookupPage, rhs: AccountLookupPage) -> Bool {
        return true
    }
}

struct AccountLookupPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccountLookupPage()
        }
    }
}
