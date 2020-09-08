//
//  UIColor+Extensions.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 07..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // https://stackoverflow.com/questions/58242697/segmented-controller-background-grey-after-ios13
    func asImage(height: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: height)

        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(self.cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
