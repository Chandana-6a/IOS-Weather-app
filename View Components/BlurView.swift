//
//  BlurView.swift
//  WeatherApp
//
//  Created by chandana on 25/08/24.
//

import SwiftUI

struct BlurView: View {
    let radius: CGFloat
    
    @ViewBuilder
    var body: some View {
        BackdropView()
            .frame(width: UIScreen.main.bounds.width)
            .blur(radius: radius)
    }
}

#Preview {
    BlurView(radius: 5)
}

struct BackdropView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect()
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }    
}
