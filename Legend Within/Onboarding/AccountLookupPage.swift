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

    struct SummonerFoundOverlay: View {
        @ObservedObject var accountLookupModel: AccountLookupModel
        @State private var isShown = false

        var body: some View {
            let soloQueueEntry = accountLookupModel.soloQueueEntry
            let soloQueueDivision = accountLookupModel.soloQueueDivision
            
            return ZStack(alignment: .center) {
                VStack {
                    Text("Is this your account?")
                        .bold()
                        .font(.system(size: 22))
                        .foregroundColor(.blue)
                        .padding(.bottom, 5)

                    HStack {
                        KFImage(UrlConstants.profileIcons(iconId: accountLookupModel.summoner!.profileIconId).url)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                            .padding(5)
                        Text(accountLookupModel.summoner!.name)
                            .bold()
                            .font(.system(size: 17))
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    .padding(.bottom, 5)

                    if soloQueueEntry != nil && soloQueueDivision != nil {
                        HStack {
                            ZStack(alignment: .bottom) {
                                Image(AssetPaths.rankedEmblem(tier: soloQueueEntry!.tier).path)
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .padding(.bottom, 5)
                                    .cornerRadius(8)
                                    .shadow(color: Color.gray.opacity(0.8), radius: 4, x: 0, y: 2)

                                Text("\(soloQueueEntry!.tier.normalizedString) \(soloQueueEntry!.rank.normalizedString)")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(height: 22)
                                    .padding(.horizontal, 5)
                                    .background(Color.blue)
                                    .cornerRadius(11)
                                    .shadow(color: Color.gray.opacity(0.8), radius: 4, x: 0, y: 2)
                            }
                            .padding(.trailing, 10).padding(.bottom, 5)

                            VStack(alignment: .leading) {
                                VStack() {
                                    Text(soloQueueDivision!.name)
                                        .font(.system(size: 20))
                                        .bold().italic()
                                        .foregroundColor(Color.blue.opacity(0.6))

                                    Text("\(soloQueueEntry!.leaguePoints) LP")
                                        .font(.system(size: 22))
                                        .bold()
                                        .foregroundColor(Color.blue)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: Color.blue.opacity(0.15), radius: 4, x: 0, y: 2)

                                Spacer()

                                HStack {
                                    VStack {
                                        MiddleAlignedView {
                                            Text("\(soloQueueEntry!.wins)")
                                                .bold()
                                                .font(.system(size: 25))
                                                .foregroundColor(Color.green5)
                                        }

                                        MiddleAlignedView {
                                            Text("WINS")
                                                .bold()
                                                .font(.system(size: 14))
                                                .foregroundColor(.darkGreen5)
                                        }
                                    }

                                    Spacer()

                                    Text("\(soloQueueEntry!.winRatePercent)%")
                                        .bold()
                                        .font(.system(size: 25))

                                    Spacer()

                                    VStack {
                                        MiddleAlignedView {
                                            Text("\(soloQueueEntry!.losses)")
                                                .bold()
                                                .font(.system(size: 25))
                                                .foregroundColor(Color.red5)
                                        }

                                        MiddleAlignedView {
                                            Text("LOSSES")
                                                .bold()
                                                .font(.system(size: 14))
                                                .foregroundColor(.darkRed5)
                                        }
                                    }
                                }
                                .padding(.vertical, 7)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: Color.blue.opacity(0.15), radius: 4, x: 0, y: 2)
                            }
                        }
                        .frame(maxHeight: 130)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        .padding(.bottom, 15)
                    }

                    HStack {
                        Button(action: {
                            self.accountLookupModel.summoner = nil
                        }, label: {
                            Text("No")
                        })
                        .frame(maxWidth: .infinity)

                        Button(action: {
                            //Advance to next page
                        }, label: {
                            Text("Yes")
                        })
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .shadow(color: Color.gray, radius: 6, x: 0, y: 0)
                .modifier(CustomViewModifiers.FloatIn(whenTrue: $isShown))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
            .onAppear {
                self.isShown = true
            }
        }
    }

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
