//
//  SummonerSearchAndKnowledgeFeaturesPage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 10..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension OnboardingPage {
    struct SummonerSearchAndKnowledgeFeaturesPage: View {
        var body: some View {
            VStack(spacing: 25) {
                Spacer()

                VStack {
                    Image("FeaturePreviewIcon_SummonerSearch")
                        .resizable()
                        .frame(width: 100, height: 100)

                    Text("Summoner Search")
                        .font(.system(size: 25)).bold()
                        .foregroundColor(Color("featurePreviewFont"))
                        .padding(.bottom, 15)

                    Text("Find any summoner you want and see detailed analysis about them.")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("featurePreviewSecondaryFont"))
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(Color("featureCardBackground"))
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2))

                VStack {
                    Image("FeaturePreviewIcon_Knowledge")
                        .resizable()
                        .frame(width: 100, height: 100)

                    Text("Knowledge")
                        .font(.system(size: 25)).bold()
                        .foregroundColor(Color("featurePreviewFont"))
                        .padding(.bottom, 15)

                    Text("Look for any item, champion, mastery you're interested in, and see stats of champions with different builds.")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("featurePreviewSecondaryFont"))
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(Color("featureCardBackground"))
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2))

                Spacer()
            }
            .padding(15)
        }

        private func getQuestionView(at index: Int) -> some View {
            HStack {
                Image("star.fill")
                    .resizable()
                    .frame(width: 30, height: 30)

                Text("blabla")
                    .font(.system(size: 14))
                    .bold()
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("featurePreviewFont"))
                    .lineLimit(2)

                Spacer()
            }
            .padding(8, 5, 8, 5)
            .background(RoundedRectangle(cornerRadius: 6)
                .fill(Color.blue.opacity(0.1)))
        }
    }
}

struct SummonerSearchAndKnowledgeFeaturesPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage.SummonerSearchAndKnowledgeFeaturesPage()
    }
}
