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

            Text("Welcome to")
                .font(.system(size: 24))
                .bold()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundColor(Color.blue.opacity(0.8))
                .multilineTextAlignment(.center)

            Text("Legend Within")
                .font(.system(size: 40))
                .bold()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundColor(.blue)
                .padding(.bottom, 25.0)
                .multilineTextAlignment(.center)

            Text("We will need some initial info to look up the rest that'll help to configure the app for you.")
                .font(.system(size: 15))
                .italic()
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea(.all)
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
