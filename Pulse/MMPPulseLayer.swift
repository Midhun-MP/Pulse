//
//  MMPPulseLayer.swift
//  MMPPulseView
//
//  Created by Midhun on 18/01/17.
//  Copyright © 2017 Midhun. All rights reserved.
//  Pulse layer class which handles the animation
//

import UIKit

// MARK:- Class Definition -
class MMPPulseLayer: CAReplicatorLayer
{
    // MARK:- Properties
    
    // Interval between two pulses
    var pulseInterval     : TimeInterval!
    
    // Indicates whether timing function need to be enabled or not
    var enableTimingFunc  : Bool!
    
    // Layer that shows the animation
    var animationLayer    : CALayer!
    
    // Animation group
    var animationGroup    : CAAnimationGroup!
    
    // Animation type
    var animationType     : MMPPulseType!
    
    // Frame property
    override var frame: CGRect
    {
        didSet
        {
            self.animationLayer.frame = self.bounds
        }
    }
    
    // Radius of pulse animation
    var pulseRadius       : CGFloat!
    {
        didSet
        {
            self.masksToBounds               = false
            let diameter                     = self.pulseRadius * 2
            self.animationLayer.bounds       = CGRect(x: 0,y: 0,width: diameter,height: diameter)
            self.animationLayer.cornerRadius = self.pulseRadius
        }
    }
    
    // Duration of animation
    var animationDuration : TimeInterval!
    {
        didSet
        {
            self.calculateInstanceDelay()
        }
    }
    
    // Number of pulses (Only applicable for Multiradar type)
    var numberOfPulse     : Int!
    {
        didSet
        {
            self.instanceCount = numberOfPulse
            self.calculateInstanceDelay()
        }
    }
    
    // Number of repeat type
    var pulseRepeatCount  : Float!
    {
        didSet
        {
            super.repeatCount     = pulseRepeatCount
            if let animationGroup = self.animationGroup
            {
                animationGroup.repeatCount = pulseRepeatCount
            }
        }
    }
    
    // Background color used for pulse
    var bgColor: CGColor?
    {
        didSet
        {
            self.animationLayer.backgroundColor = bgColor
        }
    }
    
    required init(type : MMPPulseType)
    {
        super.init()
        animationLayer               = CALayer()
        animationLayer.contentsScale = UIScreen.main.scale
        animationLayer.opacity       = 0.0
        addSublayer(animationLayer)
        configureAnimation()
        animationType = type
        
    }
    
    // MARK:- Initializers
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

// MARK:- Public functions
extension MMPPulseLayer
{
    
    /// Starts the animation
    func startAnimation()
    {
        self.configureAnimationGroup()
        self.animationLayer.add(self.animationGroup, forKey: MMPPulseConstants.AnimKeys.pulseAnimation)
    }
    
    
    /// Stops the animation
    func stopAnimation()
    {
        self.animationLayer.removeAnimation(forKey: MMPPulseConstants.AnimKeys.pulseAnimation)
    }
}


// MARK:- Private functions
extension MMPPulseLayer
{
    
    /// Calculates the delay needed between each instances of pulse layer
    fileprivate func calculateInstanceDelay()
    {
        if let duration = self.animationDuration, let interval = self.pulseInterval, let numberOfPulse = self.numberOfPulse
        {
            self.instanceDelay = (duration + interval) / Double(numberOfPulse)
        }
    }
    
    
    /// Configures the initial value for each property
    fileprivate func configureAnimation()
    {
        animationDuration = 3
        pulseInterval     = 1
        enableTimingFunc  = true
        
        pulseRepeatCount  = FLT_MAX
        pulseRadius       = 30
        numberOfPulse     = 1
        bgColor           = UIColor(red: 0.000, green: 0.455, blue: 0.756, alpha: 0.45).cgColor
    }
    
    
    /// Configures the animation group
    fileprivate func configureAnimationGroup()
    {
        let animationGroup         = CAAnimationGroup()
        animationGroup.duration    = self.animationDuration + self.pulseInterval
        animationGroup.repeatCount = self.repeatCount
        
        if enableTimingFunc!
        {
            let curve                     = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animationGroup.timingFunction = curve
        }
        
        let scaleAnimation          = CABasicAnimation(keyPath: MMPPulseConstants.Animations.scale)
        scaleAnimation.fromValue    = 0.0
        scaleAnimation.toValue      = 1.0
        scaleAnimation.duration     = self.animationDuration
        //scaleAnimation.autoreverses = true
        
        let opacityAnimation        = CAKeyframeAnimation(keyPath: MMPPulseConstants.Animations.opacity)
        opacityAnimation.duration   = self.animationDuration
        if let bgColor              = self.bgColor
        {
            let alpha               = bgColor.alpha
            opacityAnimation.values = [alpha, (alpha * 0.5), 0]
        }
        else
        {
            opacityAnimation.values = [1, 0.5, 0]
            
        }
        opacityAnimation.keyTimes   = [0, 0.5, 1]
        
        var animations              = [CAAnimation]()
        
        if animationType == MMPPulseType.radar
        {
            animations.append(scaleAnimation)
            animationLayer.opacity       = 1.0
            scaleAnimation.autoreverses  = true
            self.numberOfPulse           = 1
            self.pulseInterval           = self.animationDuration
            self.animationDuration       = self.pulseInterval
            animationGroup.duration      = self.animationDuration + self.pulseInterval
        }
        else if animationType == MMPPulseType.continous
        {
            animations.append(scaleAnimation)
            animations.append(opacityAnimation)
            self.numberOfPulse = 1
        }
        else if animationType == MMPPulseType.multiRadar
        {
            animations.append(scaleAnimation)
            animations.append(opacityAnimation)
        }
        
        animationGroup.animations = animations;
        self.animationGroup       = animationGroup;
    }
}
