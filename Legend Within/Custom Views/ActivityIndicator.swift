//
//  ActivityIndicator.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 30..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct ActivityIndicator : UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView
    @Binding var isSpinning: Bool

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = false
        return activityIndicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if isSpinning {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(isSpinning: .constant(false))
    }
}
