//
//  SummonerFoundOverlay.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 17..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

extension AccountLookupPage {
    struct SummonerFoundOverlay: View {
        @ObservedObject var accountLookupModel: AccountLookupModel
        @State private var isShown = false

        var body: some View {
            let soloQueueEntry = accountLookupModel.soloQueueEntry
            let soloQueueDivision = accountLookupModel.soloQueueDivision

            return ZStack(alignment: .center) {
                VStack(spacing: 10) {
                    HStack {
                        Text("Is this your account?")
                            .bold()
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .padding(.horizontal, 13).padding(.vertical, 7)
                        Spacer()
                    }
                    .background(Color.blue)
                    .shadow(color: Color.gray.opacity(0.8), radius: 4, x: 0, y: 2)

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
                    .padding(.bottom, 0).padding(.horizontal, 10)

                    if soloQueueEntry != nil && soloQueueDivision != nil {
                        GeometryReader { proxy in
                            self.getRankedPart(for: proxy,
                                               withSoloQueueEntry: soloQueueEntry,
                                               withSoloQueueDivision: soloQueueDivision)
                        }
                        .frame(maxHeight: 130)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 10)
                    }

                    HStack {
                        Button(action: {
                            self.accountLookupModel.summoner = nil
                        }, label: {
                            Text("No...").bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        })
                            .background(Color.white).foregroundColor(Color.red.opacity(1))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red.opacity(0.6), lineWidth: 0.5))
                            .padding(.leading, 10).padding(.trailing, 1)
                            .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 2)

                        Button(action: {
                            //Advance to next page
                        }, label: {
                            Text("Yes!").bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        })

                            .background(Color.blue).foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.leading, 1).padding(.trailing, 10)
                            .shadow(color: Color.gray.opacity(1), radius: 4, x: 0, y: 2)
                    }
                    .padding(.bottom, 10)
                }
                .background(LinearGradient(gradient: Gradient(colors: [.white, .lightBlue5]),
                                           startPoint: .bottomLeading, endPoint: .topTrailing))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .shadow(color: Color.gray, radius: 6, x: 0, y: 0)
                .modifier(CustomViewModifiers.FloatIn(whenTrue: $isShown))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                self.isShown = true
            }
        }

        private func getRankedPart(for proxy: GeometryProxy,
                                   withSoloQueueEntry soloQueueEntry: LeagueEntry?,
                                   withSoloQueueDivision soloQueueDivision: League?) -> some View {
            let width = proxy.size.width

            return HStack {
                ZStack(alignment: .bottom) {
                    Image(AssetPaths.rankedEmblem(tier: soloQueueEntry!.tier).path)
                        .resizable()
                        .frame(width: width * 0.33, height: width * 0.33)
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
                                Text("WON")
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
                                Text("LOST")
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
        }
    }
}

struct SummonerFoundOverlay_Preview : PreviewProvider {
    static var previews: some View {
        let model: AccountLookupModel = {
            let m = AccountLookupModel()

            let decoder = JSONDecoder()
            guard
                let url_leagueEntry = Bundle.main.url(forResource: "SummonerFoundExampleLeagueEntry",
                                                      withExtension: "json"),
                let url_soloQueueDivision = Bundle.main.url(forResource: "SummonerFoundExampleSoloQueueDivision",
                                                            withExtension: "json"),
                let url_summoner = Bundle.main.url(forResource: "SummonerFoundExampleSummoner",
                                                   withExtension: "json")
                else { fatalError() }

            let soloQueueEntry = try! decoder.decode(LeagueEntry.self, from: Data(contentsOf: url_leagueEntry))
            let soloQueueDivison =  try! decoder.decode(League.self, from: Data(contentsOf: url_soloQueueDivision))
            let summoner = try! decoder.decode(Summoner.self, from: Data(contentsOf: url_summoner))

            m.soloQueueEntry = soloQueueEntry
            m.soloQueueDivision = soloQueueDivison
            m.summoner = summoner

            return m
        }()

        return Group {
            AccountLookupPage.SummonerFoundOverlay(accountLookupModel: model)
        }
    }
}
