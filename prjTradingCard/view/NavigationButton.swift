//
//  NavigationButton.swift
//  prjTradingCard
//
//  Created by Bu on 3/11/25.
//

import SwiftUI

struct NavigationButton: View {
    let iconName: String
    let isSelected: Bool
    var hasBadge: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            Button(action: {}) {
                VStack(spacing: 4) {
                    Image(systemName: iconName)
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
            }
            // notification dot (use this if needed if implemented collection pack in the future)
            if hasBadge {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                    .offset(x: 8, y: 8)
            }
        }
    }
}

#Preview {
    NavigationButton(iconName: "house.fill", isSelected: true, hasBadge: true)
}
