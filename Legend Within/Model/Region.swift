//
//  Region.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

public enum Region : Int, CustomStringConvertible, CaseIterable {
    case euw = 0
    case eune = 1
    case kr = 2
    case na = 3

    static let userDefaultKey = "SelectedRegion"

    public func saveAsSelected() {
        UserDefaults.standard.set(self.rawValue, forKey: Region.userDefaultKey)
    }

    public static func getCurrentlySelected() -> Region {
        Region(rawValue: UserDefaults.standard.integer(forKey: Region.userDefaultKey)) ?? .euw
    }

    public var description: String {
        switch self {
            case .eune: return "Europe Nordic & East"
            case .euw: return "Europe West"
            case .na: return "North America"
            case .kr: return "South Korea"
        }
    }

    public var shortName : String {
        switch self {
            case .eune: return "EUNE"
            case .euw: return "EUW"
            case .kr: return "KR"
            case .na: return "NA"
        }
    }

    public var urlPrefix: String {
        switch self {
            case .eune: return "eun1"
            case .euw: return "euw1"
            case .kr: return "kr"
            case .na: return "na1"
        }
    }
}
