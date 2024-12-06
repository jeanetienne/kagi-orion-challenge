//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

class BrowserTabCollectionViewCell: UICollectionViewCell {

    static let nib = UINib(nibName: "BrowserTabCollectionViewCell", bundle: nil)
    static let reuseIdentifier = "BrowserTabCollectionViewCell"

    @IBOutlet private weak var imageViewTopConstraint: NSLayoutConstraint!
    private var widthRatio: CGFloat = 0.1

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageContainer: UIView!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!

    @IBOutlet private weak var closeButton: UIButton!

    private var imageViewAspectRatioConstraint: NSLayoutConstraint?
    private var closeAction: (() -> Void)?

    var frameForTransition: CGRect {
        return imageContainer.frame
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageViewTopConstraint.constant = frame.width * widthRatio * -1
        imageContainer.layer.cornerRadius = 16
        imageContainer.layer.cornerCurve = .continuous
        imageContainer.clipsToBounds = true
        iconImageView.image = UIImage(systemName: "globe")
        closeButton.setTitle(nil, for: .normal)
        closeButton.setImage(UIImage(named: "saltire_circle"), for: .normal)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        imageViewAspectRatioConstraint?.isActive = false
        imageViewAspectRatioConstraint = nil
        titleLabel.text = nil
        iconImageView.image = UIImage(systemName: "globe")
        closeAction = nil
    }

    func configure(image: UIImage, title: String, icon: UIImage?, widthRatio: CGFloat, closeAction: @escaping (() -> Void)) {
        imageView.image = image
        imageViewAspectRatioConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: image.size.height / image.size.width)
        imageViewAspectRatioConstraint?.isActive = true
        titleLabel.text = title
        if let icon {
            iconImageView.image = icon
        }
        self.widthRatio = widthRatio
        self.closeAction = closeAction
    }

    @IBAction func closeButtonDidTouchUpInside(_ sender: UIButton, forEvent event: UIEvent) {
        closeAction?()
    }

}
