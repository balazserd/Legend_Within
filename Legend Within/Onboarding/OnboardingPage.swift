//
//  OnboardingPage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 24..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct OnboardingPage: View {
    @ObservedObject private var model = OnboardingModel.shared
    
    let pages = [AnyView(WelcomePage()),
                 AnyView(AccountLookupPage()),
                 AnyView(LiveAssistantFeaturePage()),
                 AnyView(SummonerSearchAndKnowledgeFeaturesPage()),
                 AnyView(MatchHistoryAndStatisticsFeaturesPage())]
    .map { UIHostingController(rootView: $0) }
    
    var body: some View {
        return ZStack {
            PageView(pages: pages,
                     currentPage: $model.currentPage,
                     highestAllowedPage: $model.highestAllowedPage)
                .id(UUID())

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ForEach(0..<pages.count, id: \.self) { pageNumber in
                        Circle()
                            .fill(pageNumber == self.model.currentPage ? Color.blue : Color.gray.opacity(0.7))
                            .frame(width: 8, height: 8)
                    }
                    Spacer()
                }
                .padding(.bottom, 25)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

extension OnboardingPage {
    struct ColorPalette {
        static let featurePreviewTitle = Color("featurePreviewTitle")
        static let featureCardBackground = Color("featureCardBackground")
        static let featurePreviewFont = Color("featurePreviewFont")
        static let featurePreviewSecondaryFont = Color("featurePreviewSecondaryFont")
    }
}

struct OnboardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage()
    }
}
