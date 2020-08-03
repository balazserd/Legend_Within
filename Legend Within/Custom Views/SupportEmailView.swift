//
//  SupportEmailView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import MessageUI

struct SupportEmailView : UIViewControllerRepresentable {
    typealias UIViewControllerType = MFMailComposeViewController

    var mailComposeResult: Binding<MFMailComposeResult?>?
    var sendingError: Binding<Error?>?

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailController = MFMailComposeViewController()
        mailController.setToRecipients([Settings.supportEmailAddress])
        mailController.setSubject("Error report for Legend Within")
        mailController.setMessageBody("Please describe what the issue is below.", isHTML: false)

        mailController.mailComposeDelegate = context.coordinator

        return mailController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        //No update is necessary
    }

    func makeCoordinator() -> Coordinator {
        SupportEmailView.Coordinator(with: self)
    }

    class Coordinator : NSObject, MFMailComposeViewControllerDelegate {
        var mailViewController: SupportEmailView

        init(with mailVC: SupportEmailView) {
            self.mailViewController = mailVC
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            self.mailViewController.mailComposeResult?.wrappedValue = result
            self.mailViewController.sendingError?.wrappedValue = error
        }
    }
}

struct SupportEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SupportEmailView()
    }
}
