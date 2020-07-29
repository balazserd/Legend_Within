//
//  WelcomePage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct WelcomePage: View {
    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "star.fill")
                .padding(.bottom, 40)

            Text("Welcome to Legend Within!")
                .font(.system(size: 30))
                .bold()
                .foregroundColor(.blue)
                .padding(.bottom, 10)

            Text("We will need some initial info to look up the rest that'll help to configure the app for you.")
                .font(.system(size: 13))
                .italic()
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
    }
}

extension WelcomePage : Equatable {
    static func ==(lhs: WelcomePage, rhs: WelcomePage) -> Bool {
        return true
    }
}

struct WelcomePage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage()
    }
}
