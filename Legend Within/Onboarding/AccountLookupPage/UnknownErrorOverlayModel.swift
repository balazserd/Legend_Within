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
            .compactMap { [weak self] result in self?.transformMFComposeResultToUserMessage(result: result) }
            .sink { [weak self] message in
                self?.alertMessage = message
                self?.shouldShowAlertAfterEmailView = true
            }
            .store(in: &self.cancellableBag)
    }

    private func transformMFComposeResultToUserMessage(result: MFMailComposeResult?) -> String? {
        switch result {
            case .saved: return "Your message was saved. But don't forget, we are happy to hear from you anytime."
            case .failed: return "Your message could not be sent. Please try again later."
            case .sent: return "Your message was sent. We will get back to you as soon as we can."
            case .cancelled: return "If you encounter an error, you can always send an e-mail to ebuniapps@gmail.com."
            default: return nil
        }
    }
}
