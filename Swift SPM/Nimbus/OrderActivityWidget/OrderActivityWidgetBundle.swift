//
//  OrderActivityWidgetBundle.swift
//  OrderActivityWidget
//
//  Entry point for the widget extension. If Xcode's template already generated
//  a @main bundle, either replace it with this or just add
//  OrderActivityLiveActivity() to the existing bundle's body.
//

import WidgetKit
import SwiftUI

@main
struct OrderActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        OrderActivityLiveActivity()
    }
}
