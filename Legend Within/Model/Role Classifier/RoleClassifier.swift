//
//  RoleClassifier.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 15..
//  Copyright © 2020. EBUniApps. All rights reserved.
//
//  Machine Learning model trained based on the Jupyter Notebook of Canisback:
//  https://github.com/Canisback/roleML/blob/master/exploration/Role%20ML.ipynb

import Foundation
import SwiftUI

final class RoleClassifier {
    typealias ParticipantPosition = MatchTimeline.Frame.Position
    typealias Participant = MatchDetails.Participant
    typealias Lane = MatchDetails.Participant.Timeline.Lane
    typealias Role = MatchDetails.Participant.Timeline.Role

    var timeline: MatchTimeline
    var participants: [Int : Participant]
    var laneFrequencies = [Int : [Lane : Double]]()
    var mostFrequentLanes = [Int : Lane]()

    let mlModel = LoLRoleClassifier_Final()
    var mlInputs = [Int : LoLRoleClassifier_FinalInput]()

    init(from _participants: [Participant], with _timeline: MatchTimeline) {
        self.timeline = _timeline
        self.participants = Dictionary<Int, Participant>(uniqueKeysWithValues: _participants.map { ($0.participantId, $0) })

        self.calculateParticipantLaneFrequencies(from: _timeline)
        self.mlInputs = self.transformIntoMLClass(participants: _participants, timeline: _timeline)
    }

    func predict() -> [Int : (Lane, Role)?] {
        var result = [Int : (Lane, Role)?]()

        for i in 1...10 {
            let prediction = try? self.mlModel.prediction(input: self.mlInputs[i]!)
            if let resultString = prediction?.position {
                let separatorIndex = resultString.firstIndex(of: "_")!
                let firstPart = resultString.prefix(upTo: separatorIndex)
                let secondPart = resultString.suffix(from: resultString.index(separatorIndex, offsetBy: 1))

                let lane = Lane(rawValue: String(firstPart))!
                let role = Role(rawValue: String(secondPart))!

                result[i] = (lane, role)
            } else {
                result[i] = nil
            }
        }

        return result
    }

    private func calculateParticipantLaneFrequencies(from timeline: MatchTimeline) {
        //init lane frequency array
        for i in 1...10 {
            laneFrequencies[i] = [.top: 0, .middle: 0, .bottom: 0, .jungle: 0]
        }

        //calc lane freqencies and positions
        for minute in 1..<min(11, timeline.frames.count) {
            for participantFrame in timeline.frames[minute].participantFrames {
                guard let pos = participantFrame.value.position else { continue }
                let position = CGPoint(x: pos.x, y: pos.y)

                if midLaneArea.contains(position) {
                    laneFrequencies[participantFrame.value.participantId]![.middle]! += 1
                } else if botLaneArea.contains(position) {
                    laneFrequencies[participantFrame.value.participantId]![.bottom]! += 1
                } else if topLaneArea.contains(position) {
                    laneFrequencies[participantFrame.value.participantId]![.top]! += 1
                } else if jungleArea1.contains(position) || jungleArea2.contains(position) {
                    laneFrequencies[participantFrame.value.participantId]![.jungle]! += 1
                }
            }
        }

        mostFrequentLanes = Dictionary(uniqueKeysWithValues: laneFrequencies
            .map { freq in
                (freq.key, freq.value.sorted(by: { $0.value > $1.value }).first!.key)
            })
    }

    private func transformIntoMLClass(participants: [Participant], timeline: MatchTimeline) -> [Int : LoLRoleClassifier_FinalInput] {
        var dict = [Int : LoLRoleClassifier_FinalInput]()

        for participant in participants {
            let items = Set(participant.allItems)
            let has_item_mostlyUsed_BOTTOM_DUO_CARRY: Double = items.intersection(self.mostUsedItems["BOTTOM_DUO_CARRY"]!).count > 0 ? 1 : 0
            let has_item_mostlyUsed_BOTTOM_DUO_SUPPORT: Double = items.intersection(self.mostUsedItems["BOTTOM_DUO_SUPPORT"]!).count > 0 ? 1 : 0
            let has_item_mostlyUsed_JUNGLE_NONE: Double = items.intersection(self.mostUsedItems["JUNGLE_NONE"]!).count > 0 ? 1 : 0
            let has_item_mostlyUsed_MIDDLE_SOLO: Double = items.intersection(self.mostUsedItems["MIDDLE_SOLO"]!).count > 0 ? 1 : 0
            let has_item_mostlyUsed_TOP_SOLO: Double = items.intersection(self.mostUsedItems["TOP_SOLO"]!).count > 0 ? 1 : 0
            let has_item_overUsed_BOTTOM_DUO_CARRY: Double = items.intersection(self.decentlyUsedItems["BOTTOM_DUO_CARRY"]!).count > 0 ? 1 : 0
            let has_item_overUsed_BOTTOM_DUO_SUPPORT: Double = items.intersection(self.decentlyUsedItems["BOTTOM_DUO_SUPPORT"]!).count > 0 ? 1 : 0
            let has_item_overUsed_JUNGLE_NONE: Double = items.intersection(self.decentlyUsedItems["JUNGLE_NONE"]!).count > 0 ? 1 : 0
            let has_item_overUsed_MIDDLE_SOLO: Double = items.intersection(self.decentlyUsedItems["MIDDLE_SOLO"]!).count > 0 ? 1 : 0
            let has_item_overUsed_TOP_SOLO: Double = items.intersection(self.decentlyUsedItems["TOP_SOLO"]!).count > 0 ? 1 : 0
            let has_item_underUsed_BOTTOM_DUO_CARRY: Double = items.intersection(self.leastUsedItems["BOTTOM_DUO_CARRY"]!).count > 0 ? 1 : 0
            let has_item_underUsed_BOTTOM_DUO_SUPPORT: Double = items.intersection(self.leastUsedItems["BOTTOM_DUO_SUPPORT"]!).count > 0 ? 1 : 0
            let has_item_underUsed_JUNGLE_NONE: Double = items.intersection(self.leastUsedItems["JUNGLE_NONE"]!).count > 0 ? 1 : 0
            let has_item_underUsed_MIDDLE_SOLO: Double = items.intersection(self.leastUsedItems["MIDDLE_SOLO"]!).count > 0 ? 1 : 0
            let has_item_underUsed_TOP_SOLO: Double = items.intersection(self.leastUsedItems["TOP_SOLO"]!).count > 0 ? 1 : 0

            let jungleMinionRatio: Double = Double(participant.stats.neutralMinionsKilled ?? 0) / Double(participant.stats.totalMinionsKilled)
            let jungleMinionsKilled: Double = Double(participant.stats.neutralMinionsKilled ?? 0)
            let minionsKilled: Double = Double(participant.stats.totalMinionsKilled)

            let lane_frequency_bot: Double = self.laneFrequencies[participant.participantId]![.bottom]!
            let lane_frequency_jungle: Double = self.laneFrequencies[participant.participantId]![.jungle]!
            let lane_frequency_mid: Double = self.laneFrequencies[participant.participantId]![.middle]!
            let lane_frequency_top: Double = self.laneFrequencies[participant.participantId]![.top]!

            let most_frequent_bot: Double = self.mostFrequentLanes[participant.participantId]! == .bottom ? 1 : 0
            let most_frequent_jungle: Double = self.mostFrequentLanes[participant.participantId]! == .jungle ? 1 : 0
            let most_frequent_mid: Double = self.mostFrequentLanes[participant.participantId]! == .mid ? 1 : 0
            let most_frequent_top: Double = self.mostFrequentLanes[participant.participantId]! == .top ? 1 : 0

            let spells = [participant.spell1Id, participant.spell2Id]
            let spell_1: Double = spells.contains(1) ? 1 : 0
            let spell_11: Double = spells.contains(11) ? 1 : 0
            let spell_12: Double = spells.contains(12) ? 1 : 0
            let spell_14: Double = spells.contains(14) ? 1 : 0
            let spell_21: Double = spells.contains(21) ? 1 : 0
            let spell_3: Double = spells.contains(3) ? 1 : 0
            let spell_4: Double = spells.contains(4) ? 1 : 0
            let spell_6: Double = spells.contains(6) ? 1 : 0
            let spell_7: Double = spells.contains(7) ? 1 : 0

            let input = LoLRoleClassifier_FinalInput(has_item_mostlyUsed_BOTTOM_DUO_CARRY: has_item_mostlyUsed_BOTTOM_DUO_CARRY,
                                                     has_item_mostlyUsed_BOTTOM_DUO_SUPPORT: has_item_mostlyUsed_BOTTOM_DUO_SUPPORT,
                                                     has_item_mostlyUsed_JUNGLE_NONE: has_item_mostlyUsed_JUNGLE_NONE,
                                                     has_item_mostlyUsed_MIDDLE_SOLO: has_item_mostlyUsed_MIDDLE_SOLO,
                                                     has_item_mostlyUsed_TOP_SOLO: has_item_mostlyUsed_TOP_SOLO,
                                                     has_item_overUsed_BOTTOM_DUO_CARRY: has_item_overUsed_BOTTOM_DUO_CARRY,
                                                     has_item_overUsed_BOTTOM_DUO_SUPPORT: has_item_overUsed_BOTTOM_DUO_SUPPORT,
                                                     has_item_overUsed_JUNGLE_NONE: has_item_overUsed_JUNGLE_NONE,
                                                     has_item_overUsed_MIDDLE_SOLO: has_item_overUsed_MIDDLE_SOLO,
                                                     has_item_overUsed_TOP_SOLO: has_item_overUsed_TOP_SOLO,
                                                     has_item_underUsed_BOTTOM_DUO_CARRY: has_item_underUsed_BOTTOM_DUO_CARRY,
                                                     has_item_underUsed_BOTTOM_DUO_SUPPORT: has_item_underUsed_BOTTOM_DUO_SUPPORT,
                                                     has_item_underUsed_JUNGLE_NONE: has_item_underUsed_JUNGLE_NONE,
                                                     has_item_underUsed_MIDDLE_SOLO: has_item_underUsed_MIDDLE_SOLO,
                                                     has_item_underUsed_TOP_SOLO: has_item_underUsed_TOP_SOLO,
                                                     jungleMinionRatio: jungleMinionRatio,
                                                     jungleMinionsKilled: jungleMinionsKilled,
                                                     lane_frequency_bot: lane_frequency_bot,
                                                     lane_frequency_jungle: lane_frequency_jungle,
                                                     lane_frequency_mid: lane_frequency_mid,
                                                     lane_frequency_top: lane_frequency_top,
                                                     minionsKilled: minionsKilled,
                                                     most_frequent_bot: most_frequent_bot,
                                                     most_frequent_jungle: most_frequent_jungle,
                                                     most_frequent_mid: most_frequent_mid,
                                                     most_frequent_top: most_frequent_top,
                                                     spell_1: spell_1,
                                                     spell_11: spell_11,
                                                     spell_12: spell_12,
                                                     spell_14: spell_14,
                                                     spell_21: spell_21,
                                                     spell_3: spell_3,
                                                     spell_4: spell_4,
                                                     spell_6: spell_6,
                                                     spell_7: spell_7)

            dict[participant.participantId] = input
        }

        return dict
    }

    private let leastUsedItems: [String: Set<Int>] = [
        "BOTTOM_DUO_SUPPORT": [ 1011, 1018, 1036, 1037, 1038, 1039, 1041, 1042, 1043, 1051, 1053, 1054, 1055, 1056, 1057, 1058, 1083, 1400, 1401, 1402, 1412, 1413, 1414, 1416, 1419, 2011, 2015, 2033, 2057, 2058, 2059, 2061, 2062, 2140, 2319, 2420, 2421, 3001, 3004, 3006, 3020, 3022, 3025, 3026, 3027, 3031, 3033, 3035, 3036, 3040, 3042, 3044, 3046, 3047, 3052, 3053, 3057, 3065, 3068, 3071, 3072, 3074, 3075, 3076, 3077, 3078, 3083, 3085, 3086, 3087, 3089, 3091, 3094, 3095, 3100, 3101, 3102, 3115, 3123, 3124, 3135, 3139, 3140, 3142, 3143, 3144, 3146, 3152, 3153, 3155, 3156, 3161, 3165, 3193, 3194, 3196, 3197, 3198, 3211, 3285, 3340, 3363, 3371, 3373, 3374, 3379, 3380, 3384, 3386, 3387, 3389, 3508, 3513, 3706, 3715, 3742, 3748, 3751, 3812, 3814, 3907, 3916],
        "JUNGLE_NONE": [ 1004, 1006, 1018, 1051, 1053, 1054, 1055, 1056, 1083, 2003, 2004, 2010, 2011, 2013, 2015, 2033, 2053, 2056, 2058, 2059, 2060, 2061, 2062, 2065, 2319, 2403, 2422, 2423, 2424, 3003, 3004, 3006, 3009, 3024, 3025, 3027, 3028, 3030, 3031, 3040, 3042, 3046, 3050, 3056, 3068, 3069, 3070, 3072, 3086, 3087, 3092, 3094, 3095, 3096, 3097, 3098, 3105, 3107, 3114, 3115, 3116, 3123, 3124, 3139, 3140, 3146, 3152, 3153, 3158, 3161, 3190, 3196, 3197, 3198, 3222, 3285, 3301, 3302, 3363, 3371, 3373, 3379, 3382, 3389, 3390, 3401, 3504, 3508, 3751, 3801, 3802, 3812, 3905, 3907],
        "TOP_SOLO": [ 1004, 1039, 1041, 1042, 1051, 1400, 1401, 1402, 1412, 1413, 1414, 1416, 1419, 2003, 2015, 2055, 2057, 2065, 2319, 2423, 3004, 3006, 3009, 3028, 3031, 3041, 3042, 3046, 3050, 3069, 3072, 3085, 3086, 3092, 3094, 3095, 3096, 3097, 3098, 3100, 3105, 3107, 3109, 3113, 3114, 3117, 3124, 3139, 3145, 3153, 3158, 3174, 3190, 3197, 3222, 3285, 3303, 3363, 3364, 3371, 3374, 3380, 3382, 3386, 3388, 3389, 3390, 3401, 3504, 3513, 3706, 3715, 3801, 3905],
        "BOTTOM_DUO_CARRY": [ 1001, 1004, 1006, 1011, 1026, 1027, 1028, 1029, 1031, 1039, 1041, 1052, 1056, 1058, 1082, 1400, 1401, 1402, 1412, 1413, 1414, 1416, 1419, 2033, 2053, 2055, 2057, 2065, 2138, 2139, 2403, 3001, 3003, 3010, 3020, 3024, 3027, 3028, 3030, 3040, 3041, 3044, 3047, 3050, 3052, 3053, 3056, 3057, 3065, 3067, 3068, 3069, 3070, 3071, 3074, 3075, 3076, 3077, 3078, 3082, 3083, 3089, 3092, 3096, 3097, 3098, 3100, 3102, 3105, 3107, 3108, 3109, 3110, 3111, 3113, 3114, 3116, 3117, 3134, 3135, 3136, 3142, 3143, 3147, 3151, 3152, 3157, 3161, 3165, 3174, 3190, 3191, 3193, 3194, 3196, 3197, 3198, 3211, 3222, 3285, 3303, 3340, 3364, 3373, 3374, 3379, 3380, 3382, 3383, 3387, 3390, 3401, 3504, 3512, 3513, 3706, 3715, 3742, 3748, 3751, 3800, 3801, 3812, 3814, 3905, 3907, 3916],
        "MIDDLE_SOLO": [ 1004, 1006, 1011, 1029, 1031, 1033, 1039, 1041, 1042, 1043, 1051, 1055, 1057, 1083, 1400, 1401, 1402, 1412, 1413, 1414, 1416, 1419, 2010, 2011, 2013, 2015, 2053, 2056, 2057, 2058, 2060, 2061, 2062, 2065, 2138, 2140, 2319, 3004, 3006, 3009, 3010, 3022, 3024, 3025, 3028, 3042, 3046, 3047, 3050, 3056, 3065, 3067, 3068, 3069, 3071, 3072, 3074, 3075, 3076, 3082, 3083, 3085, 3086, 3092, 3094, 3095, 3096, 3097, 3098, 3101, 3105, 3107, 3109, 3110, 3114, 3117, 3123, 3124, 3139, 3143, 3144, 3153, 3161, 3174, 3190, 3193, 3194, 3196, 3211, 3222, 3301, 3364, 3373, 3379, 3382, 3383, 3387, 3389, 3401, 3504, 3508, 3512, 3513, 3706, 3715, 3742, 3751, 3800, 3801]
    ]
    private let decentlyUsedItems: [String : Set<Int>] = [
      "BOTTOM_DUO_SUPPORT": [1004, 2065, 2403, 3024, 3028, 3109, 3117, 3174, 3190, 3383, 3801],
      "JUNGLE_NONE": [3083, 3380, 3513],
      "TOP_SOLO": [2053, 3022, 3056, 3074, 3387, 3512, 3748, 3751, 3812],
      "BOTTOM_DUO_CARRY": [1042, 1043, 1051, 1055, 1083, 2011, 2015, 2060, 2061, 3006, 3025, 3031, 3046, 3072, 3085, 3086, 3087, 3094, 3124, 3139, 3140, 3144, 3153, 3363, 3371, 3508],
      "MIDDLE_SOLO": [1056, 3003, 3027, 3030, 3040, 3198, 3285, 3390]
    ]
    private let mostUsedItems: [String : Set<Int>] = [
        "BOTTOM_DUO_SUPPORT": [3050, 3069, 3092, 3096, 3097, 3098, 3105, 3107, 3114, 3222, 3382, 3401, 3504, 3850, 3851, 3853, 3854, 3855, 3857, 3858, 3859, 3860, 3862, 3863, 3864],
        "JUNGLE_NONE": [1039, 1041, 1400, 1401, 1402, 1412, 1413, 1414, 1416, 1419, 2057, 3706, 3715],
        "TOP_SOLO": [3068, 3161, 3196, 3373, 3379],
        "BOTTOM_DUO_CARRY": [2319, 3004, 3042, 3095, 3389],
        "MIDDLE_SOLO": [3197]
    ]
    private let midLaneArea = Path { path in
        path.addLines([CGPoint(x: 4200, y: 3500),
                       CGPoint(x: 11300, y: 10500),
                       CGPoint(x: 13200, y: 13200),
                       CGPoint(x: 10500, y: 11300),
                       CGPoint(x: 3300, y: 4400),
                       CGPoint(x: 1600, y: 1600)])
        path.closeSubpath()
    }
    private let topLaneArea = Path { path in
        path.addLines([CGPoint(x: -120, y: 1600),
                       CGPoint(x: -120, y: 14980),
                       CGPoint(x: 13200, y: 14980),
                       CGPoint(x: 13200, y: 13200),
                       CGPoint(x: 4000, y: 13200),
                       CGPoint(x: 1600, y: 11000),
                       CGPoint(x: 1600, y: 1600)])
        path.closeSubpath()
    }
    private let botLaneArea = Path { path in
        path.addLines([CGPoint(x: 1600, y: -120),
                       CGPoint(x: 14870, y: -120),
                       CGPoint(x: 14870, y: 13200),
                       CGPoint(x: 13200, y: 13200),
                       CGPoint(x: 13270, y: 4000),
                       CGPoint(x: 10500, y: 1700),
                       CGPoint(x: 1600, y: 1600)])
        path.closeSubpath()
    }
    private let jungleArea1 = Path { path in
        path.addLines([CGPoint(x: 1600, y: 5000),
                       CGPoint(x: 1600, y: 11000),
                       CGPoint(x: 4000, y: 13200),
                       CGPoint(x: 9800, y: 13200),
                       CGPoint(x: 10500, y: 11300),
                       CGPoint(x: 3300, y: 4400)])
        path.closeSubpath()
    }
    private let jungleArea2 = Path { path in
        path.addLines([CGPoint(x: 5000, y: 1700),
                       CGPoint(x: 4200, y: 3500),
                       CGPoint(x: 11300, y: 10500),
                       CGPoint(x: 13270, y: 9900),
                       CGPoint(x: 13270, y: 4000),
                       CGPoint(x: 10500, y: 1700)])
        path.closeSubpath()
    }
}

extension Array where Element : Hashable {
    func mostFrequent() -> (value: Element, count: Int)? {
        let counts = self.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        if let (value, count) = counts.max(by: { $0.1 < $1.1 }) {
            return (value, count)
        }

        return nil
    }
}
