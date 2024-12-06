//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

extension UIImageView {

    func updateSymbolFontSize(to textStyle: UIFont.TextStyle) {
        guard let currentImage = self.image else { return }
        let font = UIFont.preferredFont(forTextStyle: textStyle)
        let configuration = UIImage.SymbolConfiguration(pointSize: font.pointSize, weight: .regular, scale: .default)
        self.image = currentImage.withConfiguration(configuration)
    }

}
