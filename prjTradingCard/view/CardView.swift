//
//  CardView.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-18.
//


import SwiftUI

struct CardView: View {
    @State var currentCard: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.pink)
                .shadow(radius: 10)

            VStack(spacing: 10) {

                Text(currentCard.cardName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Image(currentCard.cardImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 160)
                    .padding(.top, 15)

                Text(currentCard.cardDescription)
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.3))
                    )
                    .padding(.horizontal, 12)

                Spacer()
            }
            .padding()
        }
        .frame(width: 260, height: 380)
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(currentCard: card_data)
    }
}
