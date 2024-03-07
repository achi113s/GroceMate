//
//  Utilities.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/27/24.
//

import SwiftUI
import UIKit

final class Utilities {
    @MainActor
    static func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController

        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension Utilities {
    /// Calculates the size of the region of interest (ROI) normalized to the size of the input image.
    static public func convertBoundingBoxToNormalizedBox(boxLocation: CGPoint,
                                                         boxSize: CGSize, imageSize: CGSize) -> CGRect {
        let normalizedWidth = boxSize.width / imageSize.width
        let normalizedHeight = boxSize.height / imageSize.height

        /// Now calculate the x and y coordinate of the region of interest assuming the lower
        /// left corner is the origin rather than the top left corner of the image.
        /// The origin of the bounding box is in its top leading corner. So the x
        /// is the same for the unnormalized and normalized regions.
        /// For y, we need to calculate the
        /// normalized coordinate of the lower left corner.
        let newOriginX = max(boxLocation.x, 0)
        let newOriginY = max(imageSize.height - (boxLocation.y + boxSize.height), 0)

        /// Normalize the new origin to the size of the input image.
        let normalizedOriginX = newOriginX / imageSize.width
        let normalizedOriginY = newOriginY / imageSize.height

        let finalROICGRect = CGRect(
            x: normalizedOriginX, y: normalizedOriginY,
            width: normalizedWidth, height: normalizedHeight
        )

        return finalROICGRect
    }
}
