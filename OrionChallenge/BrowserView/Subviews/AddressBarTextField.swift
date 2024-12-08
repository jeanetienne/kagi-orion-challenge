//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

protocol AddressBarTextFieldDelegate: AnyObject {
    func addressBarTextFieldDidStopLoading(_ addressBarTextField: AddressBarTextField)
    func addressBarTextFieldDidReload(_ addressBarTextField: AddressBarTextField)
    func addressBarTextFieldDidReturn(_ addressBarTextField: AddressBarTextField)
    func addressBarTextFieldDidExpand(_ addressBarTextField: AddressBarTextField)
}

class AddressBarTextField: UIView {

    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var summaryContainerView: UIView!
    @IBOutlet private weak var summarySecurityImageView: UIImageView!
    @IBOutlet private weak var summarySearchImageView: UIImageView!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var stopReloadContainerView: UIView!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var reloadButton: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var expandButton: UIButton!

    private var heightConstraint: NSLayoutConstraint!

    weak var delegate: AddressBarTextFieldDelegate?

    var textFieldIsFirstResponder: Bool {
        return textField.isFirstResponder
    }

    var addressBarString: String {
        return textField.text ?? ""
    }

    var isLoading: Bool = false {
        didSet {
            updateButtons()
            displayProgressView()
        }
    }

    var loadingProgress: Double = 0.0 {
        didSet {
            progressView.setProgress(Float(max(loadingProgress, 0.1)), animated: true)
        }
    }

    var representsSecureContent: Bool = false {
        didSet {
            summarySecurityImageView.isHidden = false
            if representsSecureContent {
                summarySecurityImageView.image = UIImage(systemName: "lock.fill")
            } else {
                summarySecurityImageView.image = UIImage(systemName: "lock.trianglebadge.exclamationmark.fill")
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
        setupUI()
    }

    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textField.resignFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    private func setupUI() {
        self.backgroundColor = .tertiarySystemFill
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 10
        self.clipsToBounds = true

        heightConstraint = self.heightAnchor.constraint(equalToConstant: 46)
        heightConstraint.isActive = true

        textField.delegate = self
        progressView.isHidden = true
        summarySearchImageView.isHidden = true
        summarySearchImageView.isHidden = true
        summaryLabel.text = ""
        updateButtons()
        resetSecureContentIndicator()
    }

    @IBAction private func editButtonDidTouchUpInside(_ sender: UIButton, forEvent event: UIEvent) {
        textField.becomeFirstResponder()
        updateButtons()
    }

    @IBAction private func stopButtonDidTouchUpInside(_ sender: UIButton, forEvent event: UIEvent) {
        delegate?.addressBarTextFieldDidStopLoading(self)
    }

    @IBAction private func reloadButtonDidTouchUpInside(_ sender: UIButton, forEvent event: UIEvent) {
        delegate?.addressBarTextFieldDidReload(self)
    }

    @IBAction private func expandButtonDidTouchUpInside(_ sender: UIButton, forEvent event: UIEvent) {
        delegate?.addressBarTextFieldDidExpand(self)
    }
    
    private func updateButtons() {
        editButton.isHidden = textField.isFirstResponder
        summaryContainerView.isHidden = textField.isFirstResponder
        textField.isHidden = !textField.isFirstResponder

        stopReloadContainerView.isHidden = summaryLabel.text?.isEmpty ?? true
        stopButton.isHidden = !isLoading || textField.isFirstResponder
        reloadButton.isHidden = isLoading || textField.isFirstResponder
    }

    private func displayProgressView() {
        if isLoading {
            progressView.isHidden = false
        } else {
            self.progressView.setProgress(1, animated: true)
            UIView.animate(withDuration: 0.75) { [self] in
                self.progressView.alpha = 0.0
            } completion: { [self] _ in
                self.progressView.isHidden = true
                self.progressView.alpha = 1.0
                self.progressView.setProgress(0.1, animated: false)
            }
        }
    }

}

extension AddressBarTextField {

    func setURL(_ url: URL?) {
        guard let url else { return }
        textField.text = url.absoluteString
    }

    func setSummary(_ summary: String?, isSearch: Bool) {
        summarySearchImageView.isHidden = !isSearch
        summaryLabel.text = summary
    }

    func resetSecureContentIndicator() {
        summarySecurityImageView.image = nil
        summarySecurityImageView.isHidden = true
    }

    func layoutChangesForCollapse() {
        backgroundColor = .clear
        heightConstraint.constant = 16
        stopReloadContainerView.alpha = 0
        summaryLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        summarySecurityImageView.updateSymbolFontSize(to: .caption2)
        summarySearchImageView.updateSymbolFontSize(to: .caption2)
        expandButton.isHidden = false
    }

    func layoutChangesForExpand() {
        backgroundColor = .tertiarySystemFill
        heightConstraint.constant = 46
        stopReloadContainerView.alpha = 1
        summaryLabel.font = UIFont.preferredFont(forTextStyle: .body)
        summarySecurityImageView.updateSymbolFontSize(to: .body)
        summarySearchImageView.updateSymbolFontSize(to: .body)
        expandButton.isHidden = true
    }

}

extension AddressBarTextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateButtons()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtons()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.addressBarTextFieldDidReturn(self)
        textField.resignFirstResponder()
        return true
    }

}
