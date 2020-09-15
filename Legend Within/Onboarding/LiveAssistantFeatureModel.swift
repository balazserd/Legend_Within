//
//  LiveAssistantFeatureModel.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 10..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Combine

final class LiveAssistantFeatureModel : ObservableObject {
    private var onboardingModel = OnboardingModel.shared
    @Published var showConfirmationModalAboutSiriOptout: Bool = false

    public func initiateAddingSiriShortcut() {
        //TODO
    }

    public func skipStep() {
        self.onboardingModel.didFinishOnboardingPage(number: 3) //This is the 3rd page, after this, all pages should be unlocked.
        self.showConfirmationModalAboutSiriOptout = true
    }
}
