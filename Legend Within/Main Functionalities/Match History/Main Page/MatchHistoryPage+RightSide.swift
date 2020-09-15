//
//  MatchHistoryPage+RightSide.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

extension MatchHistoryPage {
    
    struct RightSide: View {
        var participant: MatchDetails.Participant

        var body: some View {
            let itemIdsFirstRow = participant.firstThreeItemIds
            let itemIdsSecondRow = participant.secondThreeItemIds
            let trinketItemId = participant.stats.item6

            return VStack {
                HStack(spacing: 3) {
                    VStack {
                        Spacer()

                        KFImage(FilePaths.itemIcon(id: trinketItemId).path)
                            .trinketImageStyle(width: 25)

                        Spacer()
                    }

                    VStack(spacing: 3) {
                        HStack(spacing: 3) {
                            ForEach(0..<3) { i in
                                KFImage(FilePaths.itemIcon(id: itemIdsFirstRow[i]).path).itemImageStyle(width: 25)
                            }
                        }
                        HStack(spacing: 3) {
                            ForEach(0..<3) { i in
                                KFImage(FilePaths.itemIcon(id: itemIdsSecondRow[i]).path).itemImageStyle(width: 25)
                            }
                        }
                    }
                }
            }
        }
    }

}
