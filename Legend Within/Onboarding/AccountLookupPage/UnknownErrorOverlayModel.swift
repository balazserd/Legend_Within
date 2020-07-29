//
//  UnknownErrorOverlayModel.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Combine
import MessageUI

final class UnknownErrorOverlayModel : ObservableObject {
    @Published var supportEmailStatus: MFMailComposeResult?
    @Published var shouldShowSupportEmailView: Bool = false
    @Published var shouldShowAlertAfterEmailView: Bool = false
    @Published var alertMessage: String = ""

    private var cancellableBag = Set<AnyCancellable>()

    init() {
        self.setUpSupportEmailStatusPublisher()
    }

    private func setUpSupportEmailStatusPublisher() {
        $supportEmailStatus
            .sink { [weak self] result in
                guard let self = self else { return }

                switch result {
                    case .saved: self.alertMessage = "Your message was saved. But don't forget, we are happy to hear from you anytime."
                    case .failed: self.alertMessage = "Your message could not be sent. Please try again later."
                    case .sent: self.alertMessage = "Your message was sent. We will get back to you as soon as we can."
                    default: return
                }

                if [.saved, .sent, .failed].contains(result) {
                    self.shouldShowAlertAfterEmailView = true
                }
            }
            .store(in: &self.cancellableBag)
    }
}
