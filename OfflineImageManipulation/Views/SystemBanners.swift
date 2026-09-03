//
//  SystemBanners.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

import SwiftUI

struct CriticalBanner: View {
    let message: String
    var body: some View {
        Text(message)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity,maxHeight: 40)
                    .padding(.vertical, 8)
                    .background(.red)
    }
}
struct MessageToast: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.green.opacity(0.95), in: Capsule())
            .padding(.top, 8)
    }
}
