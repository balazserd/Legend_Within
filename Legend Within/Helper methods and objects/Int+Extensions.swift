//
//  Int+Extensions.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 05..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension Int {
    //Assumes 1 = 1 second.
    func toHoursMinutesAndSecondsText() -> String {
        let hours = Int(self / 3600)
        let minutes = Int((self % 3600) / 60)
        let seconds = self % 60

        let minutesSecondsText = "\(minutes < 10 ? "0\(minutes)" : "\(minutes)"):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
        let hoursText = "\(hours < 10 ? "0\(hours)" : "\(hours)"):"

        var finalText = minutesSecondsText
        if hours > 0 {
            finalText = hoursText + minutesSecondsText
        }

        return finalText
    }
}
