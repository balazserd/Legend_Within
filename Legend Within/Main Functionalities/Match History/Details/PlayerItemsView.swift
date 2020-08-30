//
//  PlayerItemsView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 30..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

extension MatchDetailsPage {

    struct PlayerItemsView: View {
        var player: MatchDetails.Participant

        var body: some View {
            let allItems = player.allItems

            return HStack(spacing: 3) {
                KFImage(FilePaths.itemIcon(id: allItems[6]).path) //Trinket
                    .trinketImageStyle(width: 23)

                ForEach(0..<6) { i in
                    KFImage(FilePaths.itemIcon(id: allItems[i]).path)
                        .itemImageStyle(width: 23)
                }
            }
        }
    }
    
}
