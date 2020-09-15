//
//  AddToSiriButton.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 10..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import Combine
import IntentsUI

struct AddToSiriButton: UIViewRepresentable {
    typealias UIViewType = UIView

    private var model: Model
    private var cancellableBag = Set<AnyCancellable>()
    private var button: INUIAddVoiceShortcutButton

    init(action: @escaping () -> ()) {
        self.button = INUIAddVoiceShortcutButton(style: .whiteOutline)
        self.model = Model(with: button, action: action)
    }

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        //no update needed.
    }
}

extension AddToSiriButton {
    private final class Model : ObservableObject {
        private var cancellableBag = Set<AnyCancellable>()

        init(with button: INUIAddVoiceShortcutButton, action: @escaping () -> ()) {
            button.publisher(for: .touchUpInside)
                .sink { _ in
                    action()
                }
                .store(in: &cancellableBag)
        }
    }
}

struct AddToSiriButton_Previews: PreviewProvider {
    static var previews: some View {
        AddToSiriButton(action: { })
    }
}
