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

    @State var currentPage: Int = 0
    
    let pages = [AnyView(WelcomePage()),
                 AnyView(AccountLookupPage()),
                 AnyView(WelcomePage())]
    .map { UIHostingController(rootView: $0)}
    
    var body: some View {
        return ZStack {
            PageView(pages: pages,
                     currentPage: $currentPage,
                     highestAllowedPage: $model.highestAllowedPage)
                .id(UUID())

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ForEach(0..<pages.count, id: \.self) { pageNumber in
                        Circle()
                            .fill(pageNumber == self.currentPage ? Color.blue : Color.gray)
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

struct OnboardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage()
    }
}
