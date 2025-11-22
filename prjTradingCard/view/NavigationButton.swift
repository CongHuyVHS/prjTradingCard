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
    var onTap: () -> Void = {}

    var body: some View {
        ZStack(alignment: .center) {
            Button(action: { onTap() }) { 
                VStack(spacing: 4) {
                    Image(systemName: iconName)
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
            }

            if hasBadge {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                    .offset(x: 8, y: 8)
            }
        }
    }
}

struct NavigationButton_Preview: PreviewProvider {
    static var previews: some View {
        NavigationButton(iconName: "house.fill", isSelected: true, hasBadge: true)
    }
}
