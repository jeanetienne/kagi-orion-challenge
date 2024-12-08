//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

protocol PagesContainerViewControllerDelegate: AnyObject {
    func pagesContainerViewController(_ viewController: PagesContainerViewController, didSelectTab tab: BrowserTab)
}

class PagesContainerViewController: UIPageViewController {

    private let viewModel: TabsCollectionViewModel
    private var initialIndex: Int

    weak var pagingDelegate: PagesContainerViewControllerDelegate?
    weak var browserDelegate: BrowserViewControllerDelegate?

    init(viewModel: TabsCollectionViewModel, initialIndex: Int) {
        self.viewModel = viewModel
        self.initialIndex = initialIndex
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.dataSource = self
        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let initialViewController = makeBrowserViewController(for: initialIndex).flatMap { [$0] }
        setViewControllers(initialViewController, direction: .forward, animated: false, completion: nil)
    }

    private func makeBrowserViewController(for index: Int) -> BrowserViewController? {
        guard let tab = viewModel.tab(at: index) else { return nil }
        let browserVC = BrowserViewController(viewModel: BrowserViewModel(tab: tab))
        browserVC.delegate = browserDelegate
        return browserVC
    }

}

extension PagesContainerViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentBrowserViewController = viewController as? BrowserViewController else { return nil }
        let tab = currentBrowserViewController.browsedTab
        let index = viewModel.index(of: tab) - 1
        return makeBrowserViewController(for: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentBrowserViewController = viewController as? BrowserViewController else { return nil }
        let tab = currentBrowserViewController.browsedTab
        let index = viewModel.index(of: tab) + 1
        return makeBrowserViewController(for: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentBrowserViewController = viewControllers?.first as? BrowserViewController else { return }
        pagingDelegate?.pagesContainerViewController(self, didSelectTab: currentBrowserViewController.browsedTab)
    }

}

extension PagesContainerViewController: UIPageViewControllerDelegate {}

extension PagesContainerViewController: ZoomTransitionProvider {

    func transitionWillStart(style: ZoomTransitionStyle) {
        if style == .interactive {
            guard let currentBrowserViewController = viewControllers?.first as? BrowserViewController else { return }
            currentBrowserViewController.triggerScreenshotUpdate()
        }
    }

    func transitionDidEnd(style: ZoomTransitionStyle) {}

    func target() -> any ZoomTransitionTarget {
        return ZoomTransitionSimpleTarget(image: nil, frame: view.frame)
    }

}
