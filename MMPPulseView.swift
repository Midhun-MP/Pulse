//
//  MMPPulseView.swift
//  MMPPulseView
//
//  Created by Midhun on 16/01/17.
//  Copyright © 2017 Midhun. All rights reserved.
//  UIView extension which implements the pulse animations
//

import UIKit

// MARK: Pulse Functions
extension UIView
{
    
    /// Create and adds pulse animation to the view
    ///
    /// - Parameters:
    ///   - color: Color of pulse
    ///   - type: Animation type
    func addPulse(withColor color : UIColor, andType type: MMPPulseType)
    {
        let outerLayer             = CALayer()
        outerLayer.frame           = self.frame
        outerLayer.cornerRadius    = self.layer.cornerRadius
        outerLayer.backgroundColor = color.cgColor
        outerLayer.opacity         = 0.7
        outerLayer.name            = MMPPulseConstants.Layers.outerLayer
        self.layer.masksToBounds   = false
        self.layer.superlayer?.insertSublayer(outerLayer, below: self.layer)
        
        self.addScaleAnim(toLayer: outerLayer, forType: type)
        
        if (type == MMPPulseType.radar)
        {
            self.addFadeAnim(toLayer: outerLayer, forType: type)
        }
    }
    
    
    /// Removes the pulse animation
    func removePulse()
    {
        self.layer.removeAnimation(forKey: MMPPulseConstants.AnimKeys.pulseAnim)
        self.layer.removeAnimation(forKey: MMPPulseConstants.AnimKeys.fadeAnim)
        
        if let outerLayer = self.getOuterLayer()
        {
            outerLayer.removeFromSuperlayer()
        }
    }
}

// MARK: Utility Functions
extension UIView
{
    
    /// Returns the layer that shows the pulse animation
    ///
    /// - Returns: Pulse animation layer
    func getOuterLayer() -> CALayer?
    {
        var layer : CALayer?
        if let subLayers = self.layer.superlayer?.sublayers
        {
            for sublayer in subLayers
            {
                if sublayer.name == MMPPulseConstants.Layers.outerLayer
                {
                    layer = sublayer
                    break
                }
            }
        }
        return layer
    }
    
    
    /// Adds scale animation
    ///
    /// - Parameters:
    ///   - layer: Layer to which the animation need to be added
    ///   - type: Animation type
    func addScaleAnim(toLayer layer : CALayer, forType type : MMPPulseType)
    {
        let scaleAnimation          = CABasicAnimation(keyPath: MMPPulseConstants.Animations.scale)
        scaleAnimation.fromValue    = type.getPulseScaleFactor()
        scaleAnimation.toValue      = 1.4
        scaleAnimation.duration     = CFTimeInterval(type.getPulseFrequency())
        scaleAnimation.autoreverses = type == MMPPulseType.continous
        scaleAnimation.repeatCount  = Float(INT32_MAX)
        layer.add(scaleAnimation, forKey: MMPPulseConstants.AnimKeys.pulseAnim)
    }
    
    
    /// Adds fade animation
    ///
    /// - Parameters:
    ///   - layer: Layer to which the animation need to be added
    ///   - type: Animation type
    func addFadeAnim(toLayer layer : CALayer, forType type : MMPPulseType)
    {
        let opacityAnimation = CABasicAnimation(keyPath: MMPPulseConstants.Animations.opacity)
        opacityAnimation.fromValue    = 0.7
        opacityAnimation.toValue      = 0.0
        opacityAnimation.duration     = CFTimeInterval(type.getPulseFrequency());
        opacityAnimation.autoreverses = false
        opacityAnimation.repeatCount  = Float(INT32_MAX);
        layer.add(opacityAnimation, forKey: MMPPulseConstants.AnimKeys.fadeAnim)
    }
}
