//
//  MMPPulseView.swift
//  MMPPulseView
//
//  Created by Midhun on 16/01/17.
//  Copyright © 2017 Midhun. All rights reserved.
//  UIView extension which implements the pulse animations
//

import UIKit

// MARK:- Pulse Functions
extension UIView
{
    
    /// Function for starting the pulse animation
    /// Excepty `type` all other parameters are optional
    /// - Parameters:
    ///   - type: Type of pulse animation (Defined in MMPPulseType)
    ///   - color: Color of pulse(s)
    ///   - pulseCount: Number of pulses need to be shown (Must be 1 for .radar and .continuos for better effect)
    ///   - repeatCount: Number of times the animation need to be repeated
    ///   - frequency: Frequency of consecutive animations
    ///   - radius: Radius of pulse
    ///   - duration: Animation duration
    func startPulse(withType type : MMPPulseType, color : UIColor = UIColor.black, pulseCount : Int = 1, repeatCount : Float = FLT_MAX, frequency : TimeInterval = 1, radius : CGFloat = 50, andDuration duration : TimeInterval = 1.0)
    {
        let outerLayer               = MMPPulseLayer(type: type)
        outerLayer.frame             = self.frame
        outerLayer.bgColor           = color.cgColor
        outerLayer.numberOfPulse     = pulseCount
        outerLayer.pulseRepeatCount  = repeatCount
        outerLayer.pulseInterval     = frequency
        outerLayer.pulseRadius       = radius
        outerLayer.animationDuration = duration
        outerLayer.name              = MMPPulseConstants.Layers.outerLayer
        self.layer.masksToBounds     = false
        self.layer.superlayer?.insertSublayer(outerLayer, below: self.layer)
        outerLayer.startAnimation()
    }
    
    /// Removes the pulse animation
    func removePulse()
    {        
        if let outerLayer = self.getOuterLayer()
        {
            outerLayer.stopAnimation()
            outerLayer.removeFromSuperlayer()
        }
    }
}

// MARK:- Utility Functions
extension UIView
{
    /// Returns the layer that shows the pulse animation
    ///
    /// - Returns: Pulse animation layer
    func getOuterLayer() -> MMPPulseLayer?
    {
        var layer : MMPPulseLayer?
        if let subLayers = self.layer.superlayer?.sublayers
        {
            for sublayer in subLayers
            {
                if sublayer.name == MMPPulseConstants.Layers.outerLayer
                {
                    layer = sublayer as? MMPPulseLayer
                    break
                }
            }
        }
        return layer
    }
}
