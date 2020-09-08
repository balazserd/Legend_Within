//
//  PageView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 24..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI

struct PageView : UIViewControllerRepresentable {
    typealias UIViewControllerType = UIPageViewController

    var pages: [UIViewController]

    @Binding var currentPage: Int
    @Binding var highestAllowedPage: Int

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .horizontal)

        pageVC.dataSource = context.coordinator
        pageVC.delegate = context.coordinator

        return pageVC
    }

    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers([self.pages[currentPage]], direction: .forward, animated: false)
        context.coordinator.parent = self
    }

    func makeCoordinator() -> Coordinator {
        PageView.Coordinator(with: self)
    }

    //MARK:- Coordinator class
    class Coordinator : NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageView

        init(with pageVC: PageView) {
            self.parent = pageVC
        }

        //MARK: UIPageViewControllerDataSource
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.pages.firstIndex(of: viewController) else {
                return nil
            }

            if index == 0 {
                return nil
            }

            return parent.pages[index - 1]
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.pages.firstIndex(of: viewController) else {
                return nil
            }

            if index == parent.pages.endIndex - 1 {
                return nil
            }

            if parent.highestAllowedPage - 1 < index + 1 {
                return nil
            } else {
                return parent.pages[index + 1]
            }
        }

        //MARK: UIPageViewControllerDelegate
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            guard completed else { return }

            if
            let visibleViewController = pageViewController.viewControllers?.first,
            let index = parent.pages.firstIndex(of: visibleViewController) {
                self.parent.currentPage = index
            }
        }
    }
}

