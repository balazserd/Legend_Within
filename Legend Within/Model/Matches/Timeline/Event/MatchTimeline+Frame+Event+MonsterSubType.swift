//
//  MatchTimeline+Frame+Event+MonsterSubType.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 15..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchTimeline.Frame.Event {
    enum MonsterSubType : String {
        case infernalDrake = "FIRE_DRAGON"
        case cloudDrake = "AIR_DRAGON"
        case oceanDrake = "OCEAN_DRAGON"
        case mountainDrake = "EARTH_DRAGON"
        case elderDrake = "ELDER_DRAGON"
    }
}
