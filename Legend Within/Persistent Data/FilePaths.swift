//
//  FilePaths.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

import Foundation

enum FilePaths {
    case championsJson
    case itemsJson
    case championJson(name: String)

    var path: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        switch self {
            case .championsJson:
                return documentDirectory.appendingPathComponent("champion.json")
            case .itemsJson:
                return documentDirectory.appendingPathComponent("item.json")
            case .championJson(let name):
                return documentDirectory.appendingPathComponent("champions", isDirectory: true).appendingPathComponent("\(name).json")
        }
    }
}
