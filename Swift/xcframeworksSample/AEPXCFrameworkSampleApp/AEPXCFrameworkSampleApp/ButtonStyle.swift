/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI
import Foundation

public struct CustomButtonStyle: ButtonStyle {
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .font(.caption)
            .cornerRadius(5)
    }
}
