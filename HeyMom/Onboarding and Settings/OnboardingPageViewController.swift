//
//  OnboardingViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var didFinishSetup: (() -> ())?

    
    // Lazy loader for instantiating view controllers.
    lazy var viewControllerList:[UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let welcomeVC         = sb.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
        let numberUpdateVC    = sb.instantiateViewController(withIdentifier: "NumberUpdateVC") as! NumberUpdateViewController
        let frequencyUpdateVC = sb.instantiateViewController(withIdentifier: "FrequencyUpdateVC") as! FrequencyUpdateViewController
        let finishSetupVC     = sb.instantiateViewController(withIdentifier: "FinishSetupVC") as! FinishSetupViewController

        // Wire up welcome screen.
        welcomeVC.didGoNext = { [weak self] in
            self?.goToNextPage()
        }

        // Wire up number update screen.
        numberUpdateVC.didGoBack = { [weak self] in
            self?.goToPreviousPage()
        }

        numberUpdateVC.didGoNext = { [weak self] in
            self?.goToNextPage()
        }

        // Wire up call frequency update screen.
        frequencyUpdateVC.didGoBack = { [weak self] in
            self?.goToPreviousPage()
        }

        frequencyUpdateVC.didGoNext = { [weak self] in
            self?.goToNextPage()
        }

        // Wire up call finish setup screen.
        finishSetupVC.didGoBack = { [weak self] in
            self?.goToPreviousPage()
        }

        finishSetupVC.didFinish = { [weak self] in
            self?.didFinishSetup?()
        }

        
        return [welcomeVC, numberUpdateVC, frequencyUpdateVC, finishSetupVC]
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set page view data source to current class.
        self.dataSource = self
        
        // Disable scrolling gesture since onboardings screen will advance with buttons.
        for view in view.subviews {
            if view is UIScrollView {
                (view as? UIScrollView)?.isScrollEnabled = false
            }
        }
        
        // Set initial view controller.
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    // Logic for navigating page view controller to previous page.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let prevIndex = vcIndex - 1
        
        guard prevIndex >= 0 else { return nil }
        
        guard viewControllerList.count > prevIndex else { return nil }
        
        return viewControllerList[prevIndex]
    }
    
    // Logic for navigating page view controller to next page.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else { return nil }
        
        guard viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
    }
    
    func goToNextPage() {
        guard let currentViewController = viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    
    func goToPreviousPage() {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
    }

//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return viewControllerList.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 0
//    }

}
