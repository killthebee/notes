import UIKit

class AnimatorFactory {

    @discardableResult
    static func rotateRepeat(view: UIView) -> UIViewPropertyAnimator {
        let rotate = UIViewPropertyAnimator(duration: 1.5, curve: .linear)
        rotate.addAnimations {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            view.alpha = 0.4
        }
        rotate.addCompletion { _ in
            view.transform = .identity
            view.alpha = 1.0
        }

        return rotate
    }

}
