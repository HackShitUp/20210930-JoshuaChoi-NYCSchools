//
//  LinearRefresher.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



/**
 Abstract: Custom UIView for an indeterminate linear progress bar
 */
class LinearProgressBar: UIView {
    
    // MARK: - Class Vars
    
    // MARK: - UIColor
    var colors: [UIColor] = [Color(.Accent), Color(.Blue), Color(.Accent)] {
        didSet {
            // MARK: - CAGradientLayer
            gradientLayer.colors = colors.map({$0.cgColor})
            // Redraw the layer
            setNeedsDisplay()
        }
    }

    // Between 0 and 1 — Defaults to 1
    var progress: CGFloat = 1.0 {
        didSet {
            // Redraw the layer
            setNeedsDisplay()
        }
    }

    // MARK: - CALayer
    fileprivate let progressLayer = CALayer()
    
    // MARK: - CAGradientLayer
    fileprivate let gradientLayer = CAGradientLayer()
    
    // MARK: - CABasicAnimation
    fileprivate let flowAnimation = CABasicAnimation(keyPath: "locations")

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        frame = bounds
        backgroundColor = Color(.LightGray)
        layer.cornerRadius = bounds.height/3.0
        translatesAutoresizingMaskIntoConstraints = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // MARK: - CALayer
        progressLayer.frame = bounds
        
        // MARK: - CAGradientLayer
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
        gradientLayer.mask = progressLayer
        gradientLayer.locations = [0.35, 0.5, 0.65]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})
        
        // MARK: - CABasicAnimation
        flowAnimation.fromValue = [-0.3, -0.15, 0]
        flowAnimation.toValue = [1, 1.15, 1.3]
        flowAnimation.isRemovedOnCompletion = false
        flowAnimation.repeatCount = Float.infinity
        flowAnimation.duration = 1
        gradientLayer.add(flowAnimation, forKey: "flowAnimation")
        pauseAnimation()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // MARK: - CALayer
        progressLayer.frame = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
        progressLayer.backgroundColor = Color(.LightGray).cgColor
        
        // MARK: - CAGradientLayer
        gradientLayer.frame = rect
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.endPoint = CGPoint(x: progress, y: 0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // MARK: - CAGradientLayer
        // Update the gradient layer's frame
        gradientLayer.frame = bounds
    }
    
    /// Pause the CALayer's animation
    fileprivate func pauseAnimation() {
        let pausedTime = gradientLayer.convertTime(CACurrentMediaTime(), from: nil)
        gradientLayer.speed = 0.0
        gradientLayer.timeOffset = pausedTime
    }
    
    /// Resume the CALayer's animation
    fileprivate func resumeAnimation() {
        let pausedTime = gradientLayer.timeOffset
        gradientLayer.speed = 1.0
        gradientLayer.timeOffset = 0.0
        gradientLayer.beginTime = 0.0
        let timeSincePause = gradientLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        gradientLayer.beginTime = timeSincePause
    }

    /// Animate the linear progress bar
    /// - Parameter isAnimating: A Boolean value indicating whether the progress bar should animate or not
    func animate(_ isAnimating: Bool) {
        switch isAnimating {
        case true:
            resumeAnimation()
        case false:
            pauseAnimation()
        }
    }
}



/**
 Abstract: Custom UIRefreshControl
 */
class LinearRefresher: UIRefreshControl {
    
    // MARK: - Class Vars
    
    /// UIColors for the linear refresher
    var colors: [UIColor] = [] {
        didSet {
            // Update the linear progress bar's colors
            linearProgressBar.colors = colors
        }
    }
        
    /// Boolean used to determine if we're currently refreshing
    fileprivate var isCurrentlyRefreshing: Bool = false
    
    /// Boolean used to determine if this class is loaded
    fileprivate var isLoaded: Bool = false
    
    // MARK: - UIImageView
    fileprivate var imageView: UIImageView!
    
    // MARK: - LinearProgressBar
    fileprivate var linearProgressBar: LinearProgressBar!
    
    // MARK: - Timer
    fileprivate var timer: Timer?
    
    // MARK: - Init
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        // self
        frame = .zero
        backgroundColor = Color(.Clear)
        
        // MARK: - LinearProgressBar
        linearProgressBar = LinearProgressBar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 4.0))
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // Hide the refresher (setting the tint color to clear does NOT work)
        if let _ = superview {
            self.subviews.first?.alpha = 0
        }

        // MARK: - UIScrollView
        guard self.superview?.isKind(of: UIScrollView.self) == true else {
            return
        }
        
        // MARK: - KVO
        self.superview?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        // MARK: - UIViewController
        if let viewController = superview?.inViewController {
            // MARK: - LinearProgressBar
            viewController.view.addSubview(self.linearProgressBar)
            viewController.view.bringSubviewToFront(self.linearProgressBar)
            self.linearProgressBar.translatesAutoresizingMaskIntoConstraints = false
            self.linearProgressBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.linearProgressBar.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
            self.linearProgressBar.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.linearProgressBar.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
            self.linearProgressBar.heightAnchor.constraint(equalToConstant: self.linearProgressBar.bounds.height).isActive = true
            self.linearProgressBar.animate(true)
        }
    }

    /// Animates the image view rotation. We can think of this method as adopting the .beginRefreshing() and .endRefreshing() UIRefreshControl methods
    /// - Parameter isLoading: A Boolean indicating whether the refresh control should start spinning or not
    @objc func animate(_ isLoading: Bool) {
        switch isLoading {
        case true:
            // Start refreshing and immediately end the refresher
            self.beginRefreshing()
            self.endRefreshing()
            // MARK: - LinearProgressBar
            self.linearProgressBar.alpha = 1.0
            self.linearProgressBar.transform = CGAffineTransform.identity
            self.linearProgressBar.animate(true)
            // Determine if we're currently refreshing
            self.isCurrentlyRefreshing = true
            // Update the Boolean
            self.isLoaded = true
        case false:
            // MARK: - LinearProgressBar
            self.linearProgressBar.alpha = 0.0
            self.linearProgressBar.animate(false)
            // Determine if we're currently refreshing
            self.isCurrentlyRefreshing = false
        }

    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // MARK: - UIScrollView
        if let scrollView = superview as? UIScrollView, !isCurrentlyRefreshing && isLoaded {
            // Get the y value of the content offset
            let y = scrollView.contentOffset.y
            // Get the y-threshold
            let yThreshold = UIScreen.main.bounds.height * 0.18

            // Get the normalized scale value
            var normalizedScale = (y - 0)/(-yThreshold - 0)
            normalizedScale = normalizedScale < 0.0 ? 0.0 : normalizedScale > 1.0 ? 1.0 : normalizedScale

            // MARK: - LinearProgressBar
            self.linearProgressBar.alpha = scrollView.isDragging && y < 0.0 ? normalizedScale : 0.0
            self.linearProgressBar.transform = CGAffineTransform(scaleX: normalizedScale, y: 1.0)
        }
    }
}
