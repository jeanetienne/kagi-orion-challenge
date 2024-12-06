//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

protocol ZoomTransitionTarget {
    var image: UIImage? { get }
    var frame: CGRect { get }
}

protocol ZoomTransitionProvider: AnyObject {
    func transitionWillStart()
    func transitionDidEnd()
    func target() -> ZoomTransitionTarget
}

struct ZoomTransitionSimpleTarget: ZoomTransitionTarget {

    let image: UIImage?
    let frame: CGRect

    init(image: UIImage?, frame: CGRect) {
        self.image = image
        self.frame = frame
    }

}

class ZoomTransitionController: NSObject {

    private enum Constants {
        static let smallCornerRadius: CGFloat = 16
        static let fullCornerRadius: CGFloat = 50
    }

    weak private var navigationController: UINavigationController?
    private let safeAreaTopInset: CGFloat
    private let screenSize: CGSize

    private var operation: UINavigationController.Operation = .none
    private var isInteractive: Bool = false

    private var transitionContext: UIViewControllerContextTransitioning?
    private var interactiveTransitionView: UIView?

    private var panGestureRecognizer: UIPanGestureRecognizer!

    init(navigationController: UINavigationController, safeAreaTopInset: CGFloat, screenSize: CGSize) {
        self.safeAreaTopInset = safeAreaTopInset
        self.screenSize = screenSize
        super.init()
        navigationController.delegate = self
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.panGestureRecognizer.delegate = self
        navigationController.view.addGestureRecognizer(self.panGestureRecognizer)
        self.navigationController = navigationController
    }

    @objc func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
            case .began:
                self.isInteractive = true
                _ = self.navigationController?.popViewController(animated: true)
            case .ended:
                if self.isInteractive {
                    self.isInteractive = false
                    self.updateInteractiveTransition(with: gestureRecognizer)
                }
            default:
                if self.isInteractive {
                    self.updateInteractiveTransition(with: gestureRecognizer)
                }
        }
    }

}

extension ZoomTransitionController: UIGestureRecognizerDelegate {}

extension ZoomTransitionController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.operation = operation
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !self.isInteractive { return nil }
        return self
    }

}

extension ZoomTransitionController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if operation == .push {
            return 0.7
        } else {
            return 0.25
        }
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operation == .push {
            animateZoomInTransition(using: transitionContext)
        } else {
            animateZoomOutTransition(using: transitionContext)
        }
    }

    fileprivate func animateZoomInTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let fromProvider = fromViewController as? ZoomTransitionProvider,
              let toProvider = toViewController as? ZoomTransitionProvider
        else { return }

        fromProvider.transitionWillStart()
        toProvider.transitionWillStart()

        let fromTarget = fromProvider.target()
        let toTarget = toProvider.target()

        toViewController.view.alpha = 0
        containerView.addSubview(toViewController.view)

        let transitionView = transitionViewForImage(fromTarget.image, atRelativeSize: toTarget.frame.size)
        let animations = transitionContext.installTransitionViewAndPrepareFrameAnimation(transitionView, sourceFrame: fromTarget.frame, destinationFrame: toTarget.frame)
        containerView.layoutIfNeeded()

        transitionView.layer.cornerCurve = .continuous
        transitionView.layer.cornerRadius = Constants.smallCornerRadius
        let initialContentOffset = safeAreaTopInset * (fromTarget.frame.size.width / screenSize.width)
        transitionView.contentOffset = CGPoint(x: 0, y: initialContentOffset)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.99,
            initialSpringVelocity: 9,
            animations: {
                animations()
                transitionView.layer.cornerRadius = Constants.fullCornerRadius
                transitionView.contentOffset = CGPoint(x: 0, y: 0)
                containerView.layoutIfNeeded()
            },
            completion: { completed in
                toViewController.view.alpha = 1.0
                transitionView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                fromProvider.transitionDidEnd()
                toProvider.transitionDidEnd()
            })
    }

    fileprivate func animateZoomOutTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let fromProvider = fromViewController as? ZoomTransitionProvider,
              let toProvider = toViewController as? ZoomTransitionProvider
        else { return }

        fromProvider.transitionWillStart()
        toProvider.transitionWillStart()

        let fromTarget = fromProvider.target()
        let toTarget = toProvider.target()

        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        fromViewController.view.alpha = 0

        let transitionView = transitionViewForImage(toTarget.image, atRelativeSize: fromTarget.frame.size)
        let animations = transitionContext.installTransitionViewAndPrepareFrameAnimation(transitionView, sourceFrame: fromTarget.frame, destinationFrame: toTarget.frame)
        containerView.layoutIfNeeded()

        transitionView.layer.cornerCurve = .continuous
        transitionView.layer.cornerRadius = Constants.fullCornerRadius
        transitionView.contentOffset = CGPoint(x: 0, y: 0)
        let finalContentOffset = safeAreaTopInset * (toTarget.frame.size.width / screenSize.width)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.99,
            initialSpringVelocity: 6,
            animations: {
                animations()
                transitionView.layer.cornerRadius = Constants.smallCornerRadius
                transitionView.contentOffset = CGPoint(x: 0, y: -finalContentOffset)
                containerView.layoutIfNeeded()
            }, completion: { completed in
                transitionView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                fromProvider.transitionDidEnd()
                toProvider.transitionDidEnd()
            })
    }

    fileprivate func transitionViewForImage(_ image: UIImage?, atRelativeSize size: CGSize) -> UIScrollView {
        let aspectRatio = size.height / size.width

        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio)
        ])

        return scrollView
    }

}

extension ZoomTransitionController: UIViewControllerInteractiveTransitioning {

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext

        let containerView = transitionContext.containerView

        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let fromProvider = fromViewController as? ZoomTransitionProvider,
              let toProvider = toViewController as? ZoomTransitionProvider
        else { return }

        fromProvider.transitionWillStart()
        toProvider.transitionWillStart()

        let fromTarget = fromProvider.target()
        let toTarget = toProvider.target()

        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

        let transitionImageView = UIImageView(image: toTarget.image)
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        transitionImageView.frame = fromTarget.frame
        transitionImageView.layer.cornerCurve = .continuous
        transitionImageView.layer.cornerRadius = Constants.fullCornerRadius
        self.interactiveTransitionView = transitionImageView
        containerView.addSubview(transitionImageView)
    }

    fileprivate func updateInteractiveTransition(with gestureRecognizer: UIPanGestureRecognizer) {
        guard let transitionContext = self.transitionContext,
              let transitionImageView = self.interactiveTransitionView,
              let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let fromProvider = fromViewController as? ZoomTransitionProvider,
              let toProvider = toViewController as? ZoomTransitionProvider
        else { return }

        let fromTarget = fromProvider.target()
        let toTarget = toProvider.target()

        fromViewController.view.alpha = 0

        let anchorPoint = CGPoint(x: fromTarget.frame.minX, y: fromTarget.frame.minY)
        let translatedPoint = gestureRecognizer.translation(in: fromViewController.view)
        let verticalDelta: CGFloat = translatedPoint.y > 0 ? 0 : translatedPoint.y

        let scale = scaleFor(view: fromViewController.view, withPanningVerticalDelta: verticalDelta)
        transitionImageView.transform = CGAffineTransform(scaleX: scale, y: scale)

        let displacement = displacementFor(view: fromViewController.view, withPanningVerticalDelta: verticalDelta)
        let newOrigin = CGPoint(
            x: anchorPoint.x + translatedPoint.x + (fromTarget.frame.width - transitionImageView.frame.width) / 2,
            y: anchorPoint.y - displacement + (fromTarget.frame.height - transitionImageView.frame.height)
        )
        transitionImageView.frame.origin = newOrigin

        transitionContext.updateInteractiveTransition(1 - scale)

        if gestureRecognizer.state == .ended {
            let velocity = gestureRecognizer.velocity(in: fromViewController.view)

            if velocity.y > 0 || displacement < 50 {
                // Cancel interactive transition
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.99,
                    initialSpringVelocity: 4,
                    options: [],
                    animations: {
                        transitionImageView.frame = fromTarget.frame
                        fromViewController.view.alpha = 1.0
                    },
                    completion: { completed in
                        transitionImageView.removeFromSuperview()
                        transitionContext.cancelInteractiveTransition()
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        self.interactiveTransitionView = nil
                        self.transitionContext = nil
                        fromProvider.transitionDidEnd()
                        toProvider.transitionDidEnd()
                    })
                return
            }

            // Finalise interactive transition
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                usingSpringWithDamping: 0.99,
                initialSpringVelocity: 6,
                animations: {
                    transitionImageView.frame = toTarget.frame
                }, completion: { completed in
                    transitionImageView.removeFromSuperview()
                    self.transitionContext?.finishInteractiveTransition()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    self.interactiveTransitionView = nil
                    self.transitionContext = nil
                    fromProvider.transitionDidEnd()
                    toProvider.transitionDidEnd()
                })
        }
    }

    private func scaleFor(view: UIView, withPanningVerticalDelta verticalDelta: CGFloat) -> CGFloat {
        func transform(_ x: CGFloat) -> CGFloat {
            return 1 / pow(x + 1.414, 2) + 0.5
        }

        let maximumDelta = view.bounds.height
        let deltaAsPercentageOfMaximum = min(abs(verticalDelta) / maximumDelta, 1.0)
        let dragCoefficient = deltaAsPercentageOfMaximum * 10

        return transform(dragCoefficient)
    }

    private func displacementFor(view: UIView, withPanningVerticalDelta verticalDelta: CGFloat) -> CGFloat {
        func transform(_ x: CGFloat) -> CGFloat {
            return 1 - 0.5 * pow(x, 4)
        }

        let maximumDelta = view.bounds.height
        let dragCoefficient = min(abs(verticalDelta) / maximumDelta, 0.35)
        let result = transform(dragCoefficient) * maximumDelta * dragCoefficient
        return result
    }

}

fileprivate extension UIViewControllerContextTransitioning {

    func installTransitionViewAndPrepareFrameAnimation(_ transitionView: UIView, sourceFrame: CGRect, destinationFrame: CGRect) -> (() -> Void) {
        containerView.addSubview(transitionView)

        let topConstraint = transitionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: sourceFrame.origin.y)
        let leadingConstraint = transitionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: sourceFrame.origin.x)
        let widthConstraint = transitionView.widthAnchor.constraint(equalToConstant: sourceFrame.size.width)
        let heightConstraint = transitionView.heightAnchor.constraint(equalToConstant: sourceFrame.size.height)

        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            widthConstraint,
            heightConstraint
        ])

        return {
            topConstraint.constant = destinationFrame.origin.y
            leadingConstraint.constant = destinationFrame.origin.x
            widthConstraint.constant = destinationFrame.size.width
            heightConstraint.constant = destinationFrame.size.height
        }
    }

}
