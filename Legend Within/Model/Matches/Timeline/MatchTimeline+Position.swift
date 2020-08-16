//
//  MatchTimeline+Position.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchTimeline.Frame {
    struct Position: Codable {

        let x: Int
        let y: Int

        private enum CodingKeys: String, CodingKey {
            case x = "x"
            case y = "y"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            x = try values.decode(Int.self, forKey: .x)
            y = try values.decode(Int.self, forKey: .y)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(x, forKey: .x)
            try container.encode(y, forKey: .y)
        }

    }
}
