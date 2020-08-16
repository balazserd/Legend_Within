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

            return
                VStack {
                    VStack(spacing: 10) {
                        HStack {
                            Text("Account found!")
                                .bold()
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                .padding(.horizontal, 13).padding(.vertical, 7)
                            Spacer()
                        }
                        .background(Color.darkBlue2)
                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)

                        HStack {
                            KFImage(UrlConstants.profileIcons(iconId: accountLookupModel.summoner!.profileIconId).url)
                                .resizable()
                                .frame(width: 35, height: 35)
                                .cornerRadius(8)
                                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                                .padding(5)
                            Text(accountLookupModel.summoner!.name)
                                .bold()
                                .font(.system(size: 15))
                            Spacer()
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                        .padding(.bottom, 0).padding(.horizontal, 10)

                        if soloQueueEntry != nil && soloQueueDivision != nil {
                            GeometryReader { proxy in
                                self.getRankedPart(in: proxy,
                                                   withSoloQueueEntry: soloQueueEntry,
                                                   withSoloQueueDivision: soloQueueDivision)
                            }
                            .frame(maxHeight: 130)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 10)
                        }
                    }
                    .padding(.bottom, 10)
                    .background(Color.lightBlue5)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.8), radius: 6, x: 0, y: 3)
                    .padding(.bottom, 3)
                }
                .modifier(CustomViewModifiers.FloatIn(whenTrue: $isShown))
                .onAppear {
                    self.isShown = true
                }
        }

        private func getRankedPart(in proxy: GeometryProxy,
                                   withSoloQueueEntry soloQueueEntry: LeagueEntry?,
                                   withSoloQueueDivision soloQueueDivision: League?) -> some View {
            let width = proxy.size.width

            return HStack {
                ZStack(alignment: .bottom) {
                    Image(AssetPaths.rankedEmblem(tier: soloQueueEntry!.tier).path)
                        .resizable()
                        .padding(.bottom, 5)
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.8), radius: 4, x: 0, y: 2)

                    Text("\(soloQueueEntry!.tier.normalizedString) \(soloQueueEntry!.rank.normalizedString)")
                        .bold()
                        .foregroundColor(.white)
                        .frame(height: 22)
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .padding(.horizontal, 5)
                        .background(Color.blue)
                        .cornerRadius(11)
                        .shadow(color: Color.gray.opacity(0.8), radius: 4, x: 0, y: 2)
                }
                .frame(width: width * 0.33, height: width * 0.33)
                .padding(.trailing, 10).padding(.bottom, 5)

                VStack(alignment: .leading, spacing: 0) {
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
                    .background(Color.white)
                    .cornerRadius(8)

                    Spacer()
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 0.5)
                        .padding(.horizontal, 15)
                    Spacer()

                    HStack(alignment: .center, spacing: 3) {
                        VStack {
                            HorizontalAlignedView(.center) {
                                Text("\(soloQueueEntry!.wins)")
                                    .bold()
                                    .font(.system(size: 25))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .foregroundColor(Color.green5)
                            }

                            HorizontalAlignedView(.center) {
                                Text("WON")
                                    .bold()
                                    .font(.system(size: 14))
                                    .foregroundColor(.darkGreen5)
                            }
                        }

                        VStack {
                            HorizontalAlignedView(.center) {
                                Text("\(soloQueueEntry!.winRatePercent)%")
                                    .bold()
                                    .font(.system(size: 40))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                            }

                            HorizontalAlignedView(.center) {
                                Text("Winrate")
                                    .bold()
                                    .font(.system(size: 14))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .foregroundColor(.gray)
                            }
                        }

                        VStack {
                            HorizontalAlignedView(.center) {
                                Text("\(soloQueueEntry!.losses)")
                                    .bold()
                                    .font(.system(size: 25))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .foregroundColor(Color.red5)
                            }

                            HorizontalAlignedView(.center) {
                                Text("LOST")
                                    .bold()
                                    .font(.system(size: 14))
                                    .foregroundColor(.darkRed5)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
        }
    }
}

//MARK: -Preview
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
