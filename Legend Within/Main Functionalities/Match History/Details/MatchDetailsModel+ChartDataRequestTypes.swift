//
//  MatchDetailsModel+ChartDataRequestTypes.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 30..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension MatchDetailsModel {
    enum SumType {
        case teamBased
        case playerBased

        var mappedValue: (MatchTimeline.ParticipantIdGroupedTimelineValues, [MatchDetails.Participant]) -> MatchTimeline.TeamGroupedTimelineValues {
            switch self {
                case .teamBased: return { valuesByPlayer, participants in
                    var team1Values = [Int : Int]()
                    var team2Values = [Int : Int]()

                    let addValuesOfPlayerToTeam: (([Int : Int], inout [Int : Int]) -> Void) = { playerValues, teamValues in
                        for val in playerValues {
                            if teamValues[val.key] == nil {
                                teamValues[val.key] = val.value
                            } else {
                                teamValues[val.key]! += val.value
                            }
                        }
                    }

                    for values in valuesByPlayer {
                        if participants.first(where: { $0.participantId == values.key })!.teamId == 100 {
                            addValuesOfPlayerToTeam(values.value, &team1Values)
                        } else {
                            addValuesOfPlayerToTeam(values.value, &team2Values)
                        }
                    }

                    return [1 : team1Values,
                            2 : team2Values]
                }

                case .playerBased: return { playerGroupedValues, _ in playerGroupedValues } //do nothing
            }
        }
    }

    enum StatType : Int, CaseIterable {
        case gold = 0
        case xp
        case minionKills

        var description: String {
            switch self {
                case .gold: return "Gold"
                case .xp: return "Experience"
                case .minionKills: return "Minion Kills"
            }
        }

        var associatedKeyPath: KeyPath<MatchTimeline.Frame.ParticipantFrame, Int> {
            switch self {
                case .gold: return \.totalGold
                case .xp: return \.xp
                case .minionKills: return \.minionsKilled
            }
        }
    }
}
