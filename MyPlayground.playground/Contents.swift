import UIKit

var greeting = "Hello, playground"


final class RateProductVerticalView: UIView {
    
    private enum Constants {
        static let rateText = "Оценить\nтовар"
        
        static let corners = 2.0
    }

    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var starView: UIView!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var rateButton: UIButton!
    
    private var product: C4ProductFull?
    private let theme = Theme.current()
    private var actionClosure: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAppearance()
        setupNewDesign()
    }
    
    @IBAction
    private func rateAction(_ sender: Any) {
        Utils.vibration(.light)
        actionClosure?()
    }
}

extension RateProductVerticalView {
    @objc
    func setupView(product: C4ProductFull? = nil, actionClosure: (() -> Void)? = nil) {
        if let product {
            self.product = product
            
            let canEstimate = product.can_estimate == .C4ProductEstimateTypeCan
            setupInterfaceBy(canEstimate: canEstimate)
        }
        
        if let actionClosure {
            self.actionClosure = actionClosure
        }
    }
    
    @objc
    func instance() -> Self? {
        R.nib.rateProductVerticalView(withOwner: nil) as? Self
    }
    
    private func setupInterfaceBy(canEstimate: Bool) {
        if canEstimate {
            starView.backgroundColor = theme.mode == .light
            ? UIColor(hex: "#FFF1E6")
            : theme.gray100
            starImageView.tintColor = UIColor(hex: "#D36B1B")
            setupNewDesign()
        } else {
            setupStarView(
                tintColor: theme.sysColors.tertiary,
                textColor: theme.sysColors.tertiary
            )
        }
        
        setupNewDesign()
    }
    
    private func setupNewDesign() {
        if ABTestManager.getABTest(for: .abTest316) == .b {
            setupStarView(tintColor: theme.sysColors.secondary, textColor: theme.sysColors.primary)
        }
    }
    
    private func setupStarView(tintColor: UIColor, textColor: UIColor) {
        starView.backgroundColor = .clear
        starImageView.image = R.image.product_review_redesign()?.withRenderingMode(.alwaysTemplate)
        starImageView.tintColor = tintColor
        rateLabel.textColor = textColor
        starView.backgroundColor = theme.gray150
        starImageView.tintColor = theme.prductStarColor
    }
    
    private func setupAppearance() {
        rateLabel.textColor = theme.gray600
        rateLabel.text = Constants.rateText
        
        starView.layer.cornerRadius = starView.frame.width / Constants.corners
        starView.backgroundColor = theme.gray100
        
        rateButton.setTitle("", for: .normal)
    }
}
