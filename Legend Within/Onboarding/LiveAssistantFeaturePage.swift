//
//  LiveAssistantFeaturePage.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 09..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension OnboardingPage {
    struct LiveAssistantFeaturePage: View {
        @ObservedObject private var model = LiveAssistantFeatureModel()
        private let questions = [Question(questionText: "Are they a one-trick?",
                                          questionIconName: "FeaturePreviewIcon_LiveAssistant_OTP"),
                                 Question(questionText: "Is this their first game on a champion?",
                                          questionIconName: "FeaturePreviewIcon_LiveAssistant_Beginner"),
                                 Question(questionText: "Could they be a smurf?",
                                          questionIconName: "FeaturePreviewIcon_LiveAssistant_Smurf")]
        
        var body: some View {
            VStack(spacing: 12) {
                Spacer()

                VStack {
                    Image("FeaturePreviewIcon_LiveAssistant")
                        .resizable()
                        .frame(width: 100, height: 100)

                    Text("Live Assistant")
                        .font(.system(size: 25)).bold()
                        .foregroundColor(Color("featurePreviewFont"))
                        .padding(.bottom, 15)

                    Text("Anytime you start a game, live assistant can automatically pull the statistics of all the other players.")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("featurePreviewSecondaryFont"))
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(Color("featureCardBackground"))
                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2))

                VStack(spacing: 10) {
                    ForEach(0..<self.questions.count) { i in
                        self.getQuestionView(at: i)
                    }

                    VStack(spacing: 3) {
                        Text("Just say")
                            .font(.system(size: 14))
                            .foregroundColor(Color("featurePreviewSecondaryFont"))

                        Text("\"Hey Siri, I started a league game!\"")
                            .bold()
                            .font(.system(size: 18))
                            .foregroundColor(Color("featurePreviewFont"))

                        Text("and the smart assistant will let you know.")
                            .font(.system(size: 14))
                            .foregroundColor(Color("featurePreviewSecondaryFont"))
                    }
                    .padding(.top, 10)
                }

                Spacer()

                AddToSiriButton { self.model.initiateAddingSiriShortcut() }
                    .frame(width: 135, height: 50) //Width here doesn't really matter, the button will always be the same width. (SiriButton has a parent container view to avoid flickering)

                Button(action: { self.model.skipStep() }) {
                    Text("I don't want to use the smart assistant")
                        .font(.system(size: 12))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 10)
            }
            .padding(15)
            .alert(isPresented: self.$model.showConfirmationModalAboutSiriOptout) {
                Alert(title: Text("Info"),
                      message: Text("Even if you opt out now, you can later change this in the Settings."),
                      dismissButton: .default(Text("OK"), action: { self.model.showConfirmationModalAboutSiriOptout = false
                      }))
            }
        }

        private func getQuestionView(at index: Int) -> some View {
            HStack {
                Image(self.questions[index].questionIconName)
                    .resizable()
                    .frame(width: 30, height: 30)

                Text(self.questions[index].questionText)
                    .font(.system(size: 14))
                    .bold()
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("featurePreviewFont"))
                    .lineLimit(2)

                Spacer()
            }
            .padding(8, 5, 8, 5)
            .background(RoundedRectangle(cornerRadius: 6)
                .fill(Color.blue.opacity(0.1)))
        }

        private struct Question {
            var questionText: String
            var questionIconName: String
        }
    }
}

struct LiveAssistantFeaturePage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage.LiveAssistantFeaturePage()
    }
}
