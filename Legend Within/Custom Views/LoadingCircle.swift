//
//  LoadingCircle.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 09..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct LoadingCircle: View {
    @Binding var progressRatio: Double
    var showPercentage: Bool = true

    var body: some View {
        VStack(spacing: 3) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                Circle()
                    .trim(from: 0, to: CGFloat(progressRatio))
                    .stroke(Color.green, lineWidth: 3)
                    .rotationEffect(.degrees(-90.0))
                    .animation(.easeOut(duration:0.2))
            }
            .padding(1.5)
            .frame(maxWidth: 30, maxHeight: 30)

            if showPercentage {
                Text("\(Int(progressRatio.rounded(.up) * 100.0))%")
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .frame(maxWidth: 30)
            }
        }
    }
}

struct LoadingCircle_Previews: PreviewProvider {
    static var previews: some View {
        LoadingCircle(progressRatio: .constant(0.57))
    }
}
