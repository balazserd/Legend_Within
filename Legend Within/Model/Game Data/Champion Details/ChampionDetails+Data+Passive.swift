//
//  ChampionDetails+Data+Passive.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension ChampionDetails.Data {
    final class Passive: Codable {

        let name: String
        let description: String
        let image: Image

        private enum CodingKeys: String, CodingKey {
            case name = "name"
            case description = "description"
            case image = "image"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decode(String.self, forKey: .name)
            description = try values.decode(String.self, forKey: .description)
            image = try values.decode(Image.self, forKey: .image)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(description, forKey: .description)
            try container.encode(image, forKey: .image)
        }

    }
}
