//
//  OnboardingModel.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 24..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Combine

final class OnboardingModel : ObservableObject {
    static let shared = OnboardingModel()

    @Published var onboardingStatus: OnboardingModel.Phase
    @Published var highestAllowedPage: Int = 2

    private var cancellableBag = Set<AnyCancellable>()

    public func didBeginOnboarding() {
        guard self.onboardingStatus == .neverStarted else { return }

        self.onboardingStatus = .firstPage
    }

    public func didFinishOnboardingPage(number: Int) {
        guard number > self.onboardingStatus.rawValue else { return }

        let newPhase = Phase(rawValue: number + 1)!
        self.onboardingStatus = newPhase
    }

    public func didEndOnboarding() {
        guard self.onboardingStatus == .thirdPage else { return }

        self.onboardingStatus = .finished
    }

    private init() {
        self.onboardingStatus = Phase(rawValue: UserDefaults.standard.integer(forKey: Settings.onboardingStatusKey))!
        self.setUpOnboardingSubscriptions()
    }

    private func setUpOnboardingSubscriptions() {
        self.$onboardingStatus
            .sink { newPhase in
                UserDefaults.standard.set(newPhase.rawValue,
                                          forKey: Settings.onboardingStatusKey)
            }
            .store(in: &self.cancellableBag)
    }
}

extension OnboardingModel {
    enum Phase : Int, CaseIterable {
        case neverStarted = 0
        case firstPage = 1
        case secondPage = 2
        case thirdPage = 3
        case finished = 4
    }
}
