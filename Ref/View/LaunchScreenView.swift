//
//  LaunchScreenView.swift
//  desafio9
//
//  Created by Turma02-2 on 03/04/25.
//

import SwiftUI

struct LaunchScreenView: View {
    var paleta: ColorPalette?
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [paleta!.background1, paleta!.background2]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            Image("presentations")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        }
    }
}

#Preview {
    LaunchScreenView(paleta: paleta1)
}
