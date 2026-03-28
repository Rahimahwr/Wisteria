//
//  CheckboxToggleStyle.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 27/03/2026.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        } label: {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(configuration.isOn ? Color(red: 0.38, green: 0.31, blue: 0.37) : Color.clear)
                        )
                        .frame(width: 22, height: 22)

                    if configuration.isOn {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                configuration.label
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
