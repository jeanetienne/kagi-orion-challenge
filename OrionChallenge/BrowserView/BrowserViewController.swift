//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var addressBarTextField: AddressBarTextField!
    @IBOutlet private weak var addressBarBottomConstraint: NSLayoutConstraint!

    private lazy var backwardNavigationButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backwardNavigationButtonDidTouch))
    private lazy var forwardNavigationButton = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: self, action: #selector(forwardNavigationButtonDidTouch))
    private lazy var homeButton = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(homeButtonDidTouch))
    private lazy var tabSwitcherButton = UIBarButtonItem(image: UIImage(systemName: "square.on.square"), style: .plain, target: self, action: #selector(tabSwitcherButtonDidTouch))

    private let viewModel = BrowserViewModel()

    private var webViewLoadingObservation: NSKeyValueObservation?
    private var webViewEstimatedProgressObservation: NSKeyValueObservation?

    private let keyboardObserver = KeyboardObserver()

    private var lastContentOffset: CGFloat = 0
    private var isChromeCollapsed = false

    override func viewDidLoad() {
        super.viewDidLoad()

        configureWebViewPreferences()
        configureUI()
        configureKeyboard()
        loadHomePage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.toolbar.browserAppearance()
    }

}

// MARK: Helpers
extension BrowserViewController {

    private func configureWebViewPreferences() {
        let preferences = WKWebpagePreferences()

        let configuration = webView.configuration
        configuration.defaultWebpagePreferences = preferences
        configuration.websiteDataStore = WKWebsiteDataStore.default()
    }

    private func configureUI() {
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = true
        webView.scrollView.adjustBottomInsetsForHiddenKeyboard(additionalContentInset: 56)
        addressBarTextField.delegate = self

        self.setToolbarItems([
            backwardNavigationButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            forwardNavigationButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            homeButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            tabSwitcherButton
        ], animated: false)

        webViewEstimatedProgressObservation = observe(\.webView.estimatedProgress) { viewController, observedProperty in
            viewController.addressBarTextField.loadingProgress = viewController.webView.estimatedProgress
        }
        webViewLoadingObservation = observe(\.webView?.hasOnlySecureContent) { viewController, observedProperty in
            viewController.addressBarTextField.representsSecureContent = viewController.webView.hasOnlySecureContent
        }
    }

    private func configureKeyboard() {
        keyboardObserver.willShow = { [unowned self] keyboardSize in
            if !addressBarTextField.textFieldIsFirstResponder {
                self.collapseChrome(animated: false)
            }

            self.webView.scrollView.adjustBottomInsetsForKeyboard(ofSize: keyboardSize, additionalContentInset: 56)
            self.addressBarBottomConstraint.constant = 10 + self.heightWithinSafeArea(forKeyboardSize: keyboardSize)

            self.view.layoutIfNeeded()
        }
        keyboardObserver.willHide = { [unowned self] _ in
            self.webView.scrollView.adjustBottomInsetsForHiddenKeyboard(additionalContentInset: 56)
            self.addressBarBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        keyboardObserver.start()
    }

    private func loadHomePage() {
        let homeURL = viewModel.homePageURL()
        webView.load(URLRequest(url: homeURL))
        addressBarTextField.isLoading = true
        addressBarTextField.setSummary(viewModel.addressSummaryForInput(homeURL.absoluteString))
    }

    private func updateNavigationButtons() {
        backwardNavigationButton.isEnabled = webView.canGoBack
        forwardNavigationButton.isEnabled = webView.canGoForward
    }

}

// MARK: Buttons actions
extension BrowserViewController {

    @objc private func backwardNavigationButtonDidTouch(_ barButtonItem: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
        _ = addressBarTextField.resignFirstResponder()
    }

    @objc private func forwardNavigationButtonDidTouch(_ barButtonItem: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
        _ = addressBarTextField.resignFirstResponder()
    }

    @objc private func homeButtonDidTouch(_ barButtonItem: UIBarButtonItem) {
        loadHomePage()
        _ = addressBarTextField.resignFirstResponder()
    }

    @objc private func tabSwitcherButtonDidTouch(_ barButtonItem: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        _ = addressBarTextField.resignFirstResponder()
    }

}

extension BrowserViewController: UIScrollViewDelegate {

    private enum Constants {
        static let animationDuration: TimeInterval = 0.15
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isTracking else { return }
        let currentOffset = max(scrollView.contentOffset.y + scrollView.adjustedContentInset.top, 0)

        if currentOffset > lastContentOffset && !isChromeCollapsed {
            collapseChrome(animated: true)
        } else if currentOffset <= lastContentOffset && isChromeCollapsed {
            expandChrome()
        }

        lastContentOffset = currentOffset
    }

    private func collapseChrome(animated: Bool) {
        isChromeCollapsed = true

        self.webView.scrollView.adjustBottomInsetsForHiddenKeyboard(additionalContentInset: 26)

        if animated {
            UIView.animate(withDuration: Constants.animationDuration) { [self] in
                addressBarTextField.layoutChangesForCollapse()
                navigationController?.setToolbarHidden(true, animated: true)
                view.layoutIfNeeded()
            }
        } else {
            addressBarTextField.layoutChangesForCollapse()
            navigationController?.setToolbarHidden(true, animated: true)
        }
    }

    private func expandChrome() {
        isChromeCollapsed = false

        self.webView.scrollView.adjustBottomInsetsForHiddenKeyboard(additionalContentInset: 56)
        UIView.animate(withDuration: Constants.animationDuration) { [self] in
            addressBarTextField.layoutChangesForExpand()
            navigationController?.setToolbarHidden(false, animated: true)
            view.layoutIfNeeded()
        }
    }

}

extension BrowserViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        addressBarTextField.isLoading = true
        updateNavigationButtons()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        addressBarTextField.isLoading = false
        addressBarTextField.setURL(webView.url)
        updateNavigationButtons()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        updateNavigationButtons()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        updateNavigationButtons()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        if let url = navigationAction.request.url,
            navigationAction.navigationType == .linkActivated
            || navigationAction.navigationType == .formSubmitted
            || navigationAction.navigationType == .formResubmitted {
            addressBarTextField.setURL(url)
            addressBarTextField.setSummary(viewModel.addressSummaryForInput(url.absoluteString))
            expandChrome()
        }

        return .allow
    }

}

extension BrowserViewController: AddressBarTextFieldDelegate {

    func addressBarTextFieldDidStopLoading(_ addressBarTextField: AddressBarTextField) {
        webView.stopLoading()
        addressBarTextField.isLoading = false
    }

    func addressBarTextFieldDidReload(_ addressBarTextField: AddressBarTextField) {
        webView.reload()
    }

    func addressBarTextFieldDidReturn(_ addressBarTextField: AddressBarTextField) {
        guard !addressBarTextField.addressBarString.isEmpty else { return }
        let url = viewModel.urlForInput(addressBarTextField.addressBarString)
        webView.load(URLRequest(url: url))
        addressBarTextField.isLoading = true
        addressBarTextField.setSummary(viewModel.addressSummaryForInput(addressBarTextField.addressBarString))
    }

    func addressBarTextFieldDidExpand(_ addressBarTextField: AddressBarTextField) {
        expandChrome()
    }

}

fileprivate extension AddressBarTextField {

    func setSummary(_ summary: BrowserViewModel.AddressBarSummary) {
        switch summary {
            case .search(query: let query):
                setSummary(query, isSearch: true)
            case .address(host: let host):
                setSummary(host, isSearch: false)
        }
    }

}
