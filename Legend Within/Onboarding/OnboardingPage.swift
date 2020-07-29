//
//  OnboardingPage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 24..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct OnboardingPage: View {
    @State var currentPage: Int = 0
    let pages = [AnyView(WelcomePage()),
                 AnyView(AccountLookupPage())]
    .map { UIHostingController(rootView: $0)}
    
    var body: some View {
        return ZStack {
            PageView(pages: pages,
                     currentPage: $currentPage)
                .id(UUID())

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ForEach(0..<pages.count, id: \.self) { pageNumber in
                        Circle()
                            .fill(pageNumber == self.currentPage ? Color.blue : Color.gray)
                            .frame(width: 10, height: 10)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct OnboardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage()
    }
}
