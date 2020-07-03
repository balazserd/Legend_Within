//
//  ViewController.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    let x = AccountLookupModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.present(UIHostingController(rootView: AccountLookupPage()), animated: true, completion: nil)
    }
}

