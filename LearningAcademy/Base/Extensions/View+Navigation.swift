//
//  View.swift
//  LearningAcademy
//
//  Created by Manish Parihar on 24.10.23.
//

import SwiftUI

extension View {
    @ViewBuilder
    func embedInNavigation() -> some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                self
            }
        } else {
            NavigationView {
                self // ios < 16.0
            }
        }
    }
}
