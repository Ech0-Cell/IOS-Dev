import UIKit

class PercentageCircleView: UIView {
    
    var percentage: CGFloat = 0.75 {
        didSet {
            setNeedsDisplay()
            percentageLabel.text = "\(Int(percentage * 100))%"
        }
    }
    
    var circleColor: UIColor = .blue
    var circleBackgroundColor: UIColor = .lightGray
    var lineWidth: CGFloat = 10.0
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        setupLabel()
    }
    
    private func setupLabel() {
        addSubview(percentageLabel)
        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        percentageLabel.text = "\(Int(percentage * 100))%"
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2 - lineWidth / 2
        
        // Draw the background circle
        context.setLineWidth(lineWidth)
        context.setStrokeColor(circleBackgroundColor.cgColor)
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        context.strokePath()
        
        // Draw the percentage arc
        context.setStrokeColor(circleColor.cgColor)
        let endAngle = -(.pi / 2) + (2 * .pi * percentage)
        context.addArc(center: center, radius: radius, startAngle: -(.pi / 2), endAngle: endAngle, clockwise: false)
        context.strokePath()
    }
}
