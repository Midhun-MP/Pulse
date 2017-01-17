//
//  MMPPulseConstants.swift
//  MMPPulseView
//
//  Created by Midhun on 16/01/17.
//  Copyright © 2017 Midhun. All rights reserved.
//  Constants which is used for the pulse animation
//

enum MMPPulseType
{
    case radar
    case continous
}

extension MMPPulseType
{
    func getPulseFrequency() -> Float
    {
        var frequency : Float = 1.0
        
        switch self
        {
            case .radar:     frequency = 1.6
            case .continous: frequency = 1.2
        }
        return frequency
    }
    
    func getPulseScaleFactor() -> Float
    {
        var scaleFactor : Float = 1.0
        
        switch self
        {
        case .radar:     scaleFactor = 1.0
        case .continous: scaleFactor = 1.3
        }
        return scaleFactor
    }
}

struct MMPPulseConstants
{
    struct Layers
    {
        static let outerLayer = "MMPOuterLayer"
    }
    
    struct Animations
    {
        static let scale   = "transform.scale"
        static let opacity = "opacity"
    }
    
    struct AnimKeys
    {
        static let pulseAnim = "MMP_Pulse"
        static let fadeAnim  = "MMP_Fade"
    }
}
