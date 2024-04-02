//
//  PreferenceKey.swift
//  scrollable-content-with-slider
//
//  Created by Venkatesham Boddula on 02/04/24.
//
import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

