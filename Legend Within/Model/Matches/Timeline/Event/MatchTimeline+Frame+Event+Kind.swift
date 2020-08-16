//
//  MatchTimeline+Frame+Event+Kind.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 15..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchTimeline.Frame.Event {
    enum Kind : String {
        case championKill = "CHAMPION_KILL"
        case wardPlaced = "WARD_PLACED"
        case wardKill = "WARD_KILL"
        case buildingKill = "BUILDING_KILL"
        case eliteMonsterKill = "ELITE_MONSTER_KILL"
        case itemPurchased = "ITEM_PURCHASED"
        case itemSold = "ITEM_SOLD"
        case itemDestroyed = "ITEM_DESTROYED"
        case itemUndone = "ITEM_UNDO"
        case skillLevelUp = "SKILL_LEVEL_UP"
        case ascendedEvent = "ASCENDED_EVENT"
        case capturePoint = "CAPTURE_POINT"
        case poroKingSummon = "PORO_KING_SUMMON"
    }
}
