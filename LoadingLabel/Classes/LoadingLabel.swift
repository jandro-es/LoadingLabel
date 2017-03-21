// Copyright (c) 2017 Filtercode Ltd <jandro@filtercode.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

open class LoadingLabel: UIView {
  
  // MARK: - Private properties
  
  private var dotLayers = [DotLayer]()
  
  private let dots = 3
  
  // MARK: - Public properties
  
  public let label = UILabel()
  
  @IBInspectable public var color: UIColor = .black {
    didSet {
      updateFrames()
    }
  }
  
  @IBInspectable public var startWithAnimation: Bool = true {
    didSet {
      updateFrames()
    }
  }
  
  // MARK: - Initializers
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  // MARK: - Private methods
  
  private func commonInit() {
    if dotLayers.count < dots {
      for _ in 0..<dots {
        let dotLayer = DotLayer()
        dotLayer.parent = self
        dotLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(dotLayer)
        dotLayers.append(dotLayer)
      }
      addSubview(label)
      setupAnimation()
    }
    updateFrames()
  }
  
  private func updateFrames() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    label.frame = bounds
    label.setNeedsDisplay()
    if startWithAnimation {
      label.alpha = 0.0
    } else {
      label.alpha = 1.0
    }
    
    let margin = (bounds.width / CGFloat(dotLayers.count)) / 2.0
    let width = (bounds.width - margin * 2) / CGFloat(dots)
    let scaledWidth = width - width / 3.0
    for (index, _) in dotLayers.enumerated() {
      let centerPoint = CGPoint(x: (bounds.origin.x + bounds.width) / 2.0, y: (bounds.origin.y + bounds.height) / 2.0)
      dotLayers[index].frame = CGRect(x: CGFloat(index) * (width + margin), y: centerPoint.y - scaledWidth / 2.0, width: scaledWidth, height: scaledWidth)
      dotLayers[index].setNeedsDisplay()
    }
    
    CATransaction.commit()
  }
  
  private func setupAnimation() {
    let duration: CFTimeInterval = 0.9
    let beginTime = CACurrentMediaTime()
    let beginTimes = [0, 0.3, 0.6]
    
    let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    scaleAnimation.keyTimes = [0, 0.5, 1]
    scaleAnimation.values = [1, 0.75, 1]
    scaleAnimation.duration = duration
    
    let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
    opacityAnimation.keyTimes = [0, 0.5, 1]
    opacityAnimation.values = [1, 0.2, 1]
    opacityAnimation.duration = duration

    let animation = CAAnimationGroup()
    animation.animations = [scaleAnimation, opacityAnimation]
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.duration = duration
    animation.repeatCount = Float.infinity
    animation.isRemovedOnCompletion = false
    
    for index in 0 ..< dotLayers.count {
      animation.beginTime = beginTime + beginTimes[index]
      UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { 
        self.dotLayers[index].opacity = 1.0
      }, completion: nil)
      dotLayers[index].isHidden = false
      dotLayers[index].add(animation, forKey: "animation")
    }
  }
  
  private func endAnimation() {
    for dot in dotLayers {
      dot.removeAllAnimations()
      dot.opacity = 0.0
    }
  }
  
  // MARK: - Public methods
  
  public func stopAnimation(with text: String) {
    endAnimation()
    label.text = text
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
      self.label.alpha = 1.0
    }, completion: nil)
  }
  
  public func stopAnimation(attrText: NSAttributedString) {
    endAnimation()
    label.attributedText = attrText
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
      self.label.alpha = 1.0
    }, completion: nil)
  }
  
  public func startAnimation() {
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
      self.label.alpha = 0.0
    }) { (_) in
      self.setupAnimation()
    }
  }
}

private final class DotLayer: CAShapeLayer {
  
  weak var parent: LoadingLabel?
  
  fileprivate override func draw(in ctx: CGContext) {
    if let parent = parent {
      ctx.setFillColor(parent.color.cgColor)
      let path = UIBezierPath(ovalIn: CGRect(x: bounds.origin.x + lineWidth, y: bounds.origin.y + lineWidth, width: bounds.width - lineWidth * 2, height: bounds.height - lineWidth * 2.0))
      ctx.addPath(path.cgPath)
      ctx.fillPath()
    }
  }
}
