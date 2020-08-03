//
//  MainWindow.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct MainWindow: View {
    @State private var selectedTab: Int = 0

    private let pages = [
        AnyView(LiveAssistantPage()),
        AnyView(MatchHistoryPage()),
        AnyView(StatisticsPage()),
        AnyView(KnowledgeBasePage()),
        AnyView(SettingsPage())
    ]

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                pages[selectedTab]

                GeometryReader { proxy in
                    HStack(spacing: 0) {
                        TabIcon(tab: .liveAssistant,
                                tabIndex: 0,
                                selectedIndex: self.$selectedTab,
                                title: "Assistant")
                            .frame(width: proxy.size.width / 5)


                        TabIcon(tab: .matchHistory,
                                tabIndex: 1,
                                selectedIndex: self.$selectedTab,
                                title: "History")
                            .frame(width: proxy.size.width / 5)


                        TabIcon(tab: .statistics,
                                tabIndex: 2,
                                selectedIndex: self.$selectedTab,
                                title: "Statistics")
                            .frame(width: proxy.size.width / 5)


                        TabIcon(tab: .knowledgeBase,
                                tabIndex: 3,
                                selectedIndex: self.$selectedTab,
                                title: "Knowledge")
                            .frame(width: proxy.size.width / 5)

                        TabIcon(tab: .settings,
                                tabIndex: 4,
                                selectedIndex: self.$selectedTab,
                                title: "Settings")
                            .frame(width: proxy.size.width / 5)
                    }
                }
                .frame(height: 60)
            }
        }
    }
}

struct TabIcon : View {
    var tab: MainWindow.Tab
    var tabIndex: Int
    @Binding var selectedIndex: Int
    var title: String

    var body: some View {
        VStack(spacing: 4) {
            Image(AssetPaths.tabIcon(tab: tab, selected: tabIndex == selectedIndex).path)
                .resizable()
                .frame(width: 28, height: 28)
                .opacity(selectedIndex == tabIndex ? 1.0 : 0.8)

            Text(title)
                .lineLimit(1)
                .font(Font.system(size: 13).weight(selectedIndex == tabIndex ? .bold : .regular))
                .foregroundColor(selectedIndex == tabIndex ? .blue2 : Color.black.opacity(0.8))
        }
        .onTapGesture {
            self.selectedIndex = self.tabIndex
        }
    }
}

extension MainWindow {
    enum Tab {
        case liveAssistant
        case matchHistory
        case statistics
        case knowledgeBase
        case settings

        var iconName: String {
            switch self {
                case .knowledgeBase: return "KnowledgeBase"
                case .liveAssistant: return "LiveAssistant"
                case .matchHistory: return "MatchHistory"
                case .settings: return "Settings"
                case .statistics: return "Statistics"
            }
        }
    }
}

struct MainWindow_Previews: PreviewProvider {
    static var previews: some View {
        MainWindow()
    }
}
