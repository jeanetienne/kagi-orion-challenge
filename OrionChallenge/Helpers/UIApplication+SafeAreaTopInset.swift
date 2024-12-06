//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

extension UIApplication {

    var safeAreaTopInset: CGFloat {
        windows.first?.safeAreaInsets.top ?? 0
    }

}
