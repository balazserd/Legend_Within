//
//  KnowledgeBasePage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct KnowledgeBasePage: View {
    let values: [(Double, Double)] = [(1, 3), (2, 7), (3, -4), (4, 2), (5, -1), (6, 3)]
    var body: some View {
        LineChart(data: [LineChartData(values: values)])
    }
}

struct KnowledgeBasePage_Previews: PreviewProvider {
    static var previews: some View {
        KnowledgeBasePage()
    }
}
