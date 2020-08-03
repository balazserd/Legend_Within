//
//  UnknownErrorOverlay.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 17..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import MessageUI

extension AccountLookupPage {
    struct UnknownErrorOverlay: View {
        @ObservedObject var accountLookupModel: AccountLookupModel
        @ObservedObject var model = UnknownErrorOverlayModel()
        @State private var isShown: Bool = false
        @State private var supportEmailStatus: MFMailComposeResult? = nil

        var body: some View {
            VStack {
                VStack(spacing: 10) {
                    HStack {
                        Text("An error occurred")
                            .bold()
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .padding(.horizontal, 13).padding(.vertical, 7)
                        Spacer()
                    }
                    .background(Color.red)
                    .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)

                    Text(accountLookupModel.localizedErrorDescription ?? Texts.unknownErrorDescription)
                        .font(.system(size: 16))
                        .minimumScaleFactor(0.01)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .padding(.vertical, 10).padding(.horizontal, 13)
                }
                .padding(.bottom, 10)
                .background(Color.lightRed5)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.8), radius: 6, x: 0, y: 3)
                .padding(.bottom, 15)

                if MFMailComposeViewController.canSendMail() {
                    Button(action: { self.model.shouldShowSupportEmailView = true }) {
                        Text("Contact support").bold()
                            .padding(.vertical, 12)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color.lightRed1)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.8), radius: 6, x: 0, y: 3)
                }
            }
            .modifier(CustomViewModifiers.FloatIn(whenTrue: $isShown))
            .onAppear {
                self.isShown = true
            }
            .onDisappear {
                self.isShown = false
            }
            .sheet(isPresented: self.$model.shouldShowSupportEmailView) {
                SupportEmailView(mailComposeResult: self.$model.supportEmailStatus)
                    .alert(isPresented: self.$model.shouldShowAlertAfterEmailView) {
                        Alert(title: Text("Status update"),
                              message: Text(self.model.alertMessage),
                              dismissButton: .default(Text("OK")) {
                                self.model.shouldShowAlertAfterEmailView = false
                                self.model.shouldShowSupportEmailView = false
                              })
                    }
            }
        }
    }
}

struct UnknownErrorOverlay_Preview : PreviewProvider {
    static var previews: some View {
        Group {
            AccountLookupPage.UnknownErrorOverlay(accountLookupModel: AccountLookupModel())
        }
    }
}
