//
//  PackData.swift
//  prjTradingCard
//
//  Created by Bu on 9/11/25.
//

import Foundation
import SwiftUI

struct PackData: Identifiable {
    let id = UUID()
    let name: String
    let colors: [Color]
    let isAvailable: Bool 
}
