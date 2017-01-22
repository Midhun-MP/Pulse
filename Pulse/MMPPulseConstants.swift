//
//  MMPPulseConstants.swift
//  MMPPulseView
//
//  Created by Midhun on 16/01/17.
//  Copyright © 2017 Midhun. All rights reserved.
//  Constants which is used for the pulse animation
//

// MARK:- Enums

/// Enum which defines the different type of pulse animation
///
/// - radar: Single wave like animation, one at a time
/// - continous: Pulse expands and shrinks continuously
/// - multiRadar: Multiple waves continuously displayed
enum MMPPulseType
{
    case radar
    case continous
    case multiRadar
}

// MARK:- Structs

/// Defines the constants used in the library
struct MMPPulseConstants
{
    // MARK:- Layer names
    struct Layers
    {
        static let outerLayer = "MMPOuterLayer"
    }
    
    // MARK:- Animation keypaths
    struct Animations
    {
        static let scale   = "transform.scale.xy"
        static let opacity = "opacity"
    }
    
    // MARK: Animation keys
    struct AnimKeys
    {
        static let pulseAnimation = "MMP_Pulse_Animation"
    }
}
