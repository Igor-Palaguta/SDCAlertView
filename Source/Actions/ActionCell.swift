import UIKit

final class ActionCell: UICollectionViewCell {

    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private var highlightedBackgroundView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var imageWidthToHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var hiddenImageConstraint: NSLayoutConstraint!

    private var textColor: UIColor?

    var enabled = true {
        didSet { self.titleLabel.enabled = self.enabled }
    }

    var image: UIImage? {
        didSet {
            self.imageView.image = self.image
            self.imageWidthToHeightConstraint.constant = self.image.map { $0.size.width / $0.size.height } ?? 1
            self.hiddenImageConstraint.priority = self.image == nil ? 999 : 1
        }
    }

    override var highlighted: Bool {
        didSet { self.highlightedBackgroundView.hidden = !self.highlighted }
    }

    func setAction(action: AlertAction, withVisualStyle visualStyle: AlertVisualStyle) {
        action.actionView = self

        self.titleLabel.font = visualStyle.font(forAction: action)
        
        self.textColor = visualStyle.textColor(forAction: action)
        self.titleLabel.textColor = self.textColor ?? self.tintColor
        
        self.titleLabel.attributedText = action.attributedTitle

        self.highlightedBackgroundView.backgroundColor = visualStyle.actionHighlightColor

        self.image = action.image

        self.accessibilityLabel = action.attributedTitle?.string
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.isAccessibilityElement = true
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.titleLabel.textColor = textColor ?? self.tintColor
    }
}

final class ActionSeparatorView: UICollectionReusableView {

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)

        if let attributes = layoutAttributes as? ActionsCollectionViewLayoutAttributes {
            self.backgroundColor = attributes.backgroundColor
        }
    }
}
