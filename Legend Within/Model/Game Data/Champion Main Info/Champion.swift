//
//  Champion.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

final class Champion: Codable {

    let version: String
    let id: String
    let key: Int
    let name: String
    let title: String
    let blurb: String
    let info: Info
    let image: Image
    let tags: [String]
    let partype: String
    let stats: Stats

    private enum CodingKeys: String, CodingKey {
        case version = "version"
        case id = "id"
        case key = "key"
        case name = "name"
        case title = "title"
        case blurb = "blurb"
        case info = "info"
        case image = "image"
        case tags = "tags"
        case partype = "partype"
        case stats = "stats"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        version = try values.decode(String.self, forKey: .version)
        id = try values.decode(String.self, forKey: .id)
        //Inconsistent keycoding on Riot's side. API returns these values as Int, they are string in the data json.
        key = Int(try values.decode(String.self, forKey: .key))!
        name = try values.decode(String.self, forKey: .name)
        title = try values.decode(String.self, forKey: .title)
        blurb = try values.decode(String.self, forKey: .blurb)
        info = try values.decode(Info.self, forKey: .info)
        image = try values.decode(Image.self, forKey: .image)
        tags = try values.decode([String].self, forKey: .tags)
        partype = try values.decode(String.self, forKey: .partype)
        stats = try values.decode(Stats.self, forKey: .stats)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(id, forKey: .id)
        //Inconsistent keycoding on Riot's side. API returns these values as Int, they are string in the data json.
        try container.encode(String(key), forKey: .key)
        try container.encode(name, forKey: .name)
        try container.encode(title, forKey: .title)
        try container.encode(blurb, forKey: .blurb)
        try container.encode(info, forKey: .info)
        try container.encode(image, forKey: .image)
        try container.encode(tags, forKey: .tags)
        try container.encode(partype, forKey: .partype)
        try container.encode(stats, forKey: .stats)
    }

}
