//
//  MatchHistoryAndStatisticsFeaturesPage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 10..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension OnboardingPage {
    struct MatchHistoryAndStatisticsFeaturesPage: View {
        @ObservedObject private var onboardingModel = OnboardingModel.shared

        var body: some View {
            ZStack {
                VStack(spacing: 25) {
                    Spacer()

                    VStack {
                        Image("FeaturePreviewIcon_MatchHistory")
                            .resizable()
                            .frame(width: 100, height: 100)

                        Text("Match History")
                            .font(.system(size: 25)).bold()
                            .foregroundColor(Color("featurePreviewFont"))
                            .padding(.bottom, 15)

                        Text("See all your past matches.\nFilter them any way you want.")
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
                        Image("FeaturePreviewIcon_Statistics")
                            .resizable()
                            .frame(width: 100, height: 100)

                        Text("Statistics & Analysis")
                            .font(.system(size: 25)).bold()
                            .foregroundColor(Color("featurePreviewFont"))
                            .padding(.bottom, 15)

                            Text("Curious about that mighty winrate? Looking for ways to improve? We'll get the details for you.")
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

                VStack {
                    Spacer()

                    Button(action: { self.onboardingModel.didEndOnboarding() }) {
                        Text("Finish onboarding")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                    }
                    .background(RoundedRectangle(cornerRadius: 8)
                        .fill(Color("featurePreviewSecondaryFont"))
                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2))

                }
                .padding(.bottom, 5)
            }
            .padding(15)
        }
    }
}

struct MatchHistoryAndStatisticsFeaturesPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage.MatchHistoryAndStatisticsFeaturesPage()
    }
}
