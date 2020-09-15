//
//  OnboardingModel.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 24..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Combine

//This class should be used with its singleton.
extension OnboardingModel {
    static let shared = OnboardingModel()
}

final class OnboardingModel : ObservableObject {
    @Published var currentPage: Int
    @Published var onboardingStatus: OnboardingModel.Phase
    @Published var highestAllowedPage: Int = 0

    private var cancellableBag = Set<AnyCancellable>()

    //MARK:- Publicly available methods
    public func didBeginOnboarding() {
        guard self.onboardingStatus == .neverStarted else { return }

        self.onboardingStatus = .firstPage
    }

    public func didFinishOnboardingPage(number: Int, enforced: Bool = false) {
        guard number >= self.onboardingStatus.rawValue else { return }
        self.setNewHighestAllowedPage(afterPage: number)
    }

    public func didEndOnboarding() {
        guard self.onboardingStatus.rawValue == Phase.lastPageNumber else { return }

        self.onboardingStatus = .finished
    }

    //MARK:- Init
    private init() {
        let phase = Phase(rawValue: UserDefaults.standard.integer(forKey: Settings.onboardingStatusKey))!
        self.onboardingStatus = phase
        self.currentPage = max(phase.rawValue - 1, 0) //CurrentPage is 0-based, phase is not.

        if phase.rawValue > Phase.firstPage.rawValue {
            self.setNewHighestAllowedPage(afterPage: self.currentPage)
        }

        self.setUpOnboardingSubscriptions()
    }

    //MARK:- Private methods
    private func setNewHighestAllowedPage(afterPage pageNumber: Int) {
        if pageNumber >= 3 { //If the 3rd page is finished, end onboarding trap
            self.highestAllowedPage = Phase.lastPageNumber
        } else {
            self.highestAllowedPage = pageNumber + 1
        }
    }

    private func setUpOnboardingSubscriptions() {
        self.$onboardingStatus
            .sink { newPhase in
                UserDefaults.standard.set(newPhase.rawValue, forKey: Settings.onboardingStatusKey)
            }
            .store(in: &self.cancellableBag)

        self.$currentPage
            .map { $0 + 1 } //CurrentPage needs to be 0-based due to Array Binding, so must add 1 to convert to Phase-rawValue.
            .filter { $0 > self.onboardingStatus.rawValue } //Only allow a new highest page number to fall through.
            .sink { [weak self] pageNumber in
                //It is safe to say at this point that the user turned to this page for the first time.
                self?.onboardingStatus = Phase(rawValue: pageNumber)!
            }
            .store(in: &self.cancellableBag)
    }
}

//MARK:- OnboardingModel.Phase
extension OnboardingModel {
    enum Phase : Int, CaseIterable {
        case neverStarted = 0
        case firstPage
        case secondPage
        case thirdPage
        case fourthPage
        case fifthPage
        case finished

        static var lastPageNumber: Int {
            Phase.allCases.map { $0.rawValue }.max()! - 1
        }
    }
}
