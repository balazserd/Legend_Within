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
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("Legend Within")
                .font(.system(size: 40))
                .bold()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundColor(.white)
                .padding(.bottom, 25.0)
                .multilineTextAlignment(.center)

            Text("We will need some initial info to look up the rest that'll help to configure the app for you.")
                .font(.system(size: 15))
                .italic()
                .foregroundColor(Color.white.opacity(0.9))
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.blue2, .blue5]),
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
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
