

import SwiftUI
import UIKit

// MARK: - Public SwiftUI wrapper
// Emits the provided emoji in an "explosion" across the entire view while `isEmitting` is true.
struct EmojiEmitter: UIViewRepresentable {
    let emoji: String
    let isEmitting: Bool
    var birthRate: Float = 4.0 // total emojis per second when emitting
    
    func makeUIView(context: Context) -> EmitterUIView {
        let view = EmitterUIView()
        view.isUserInteractionEnabled = false
        return view
    }
    
    func updateUIView(_ uiView: EmitterUIView, context: Context) {
        // Keep emitter covering the whole view
        uiView.updateEmitterLayout()
        
        // Update the emoji (trims whitespace like " 💪" -> "💪")
        uiView.setEmoji(emoji)
        
        // Start/stop emission
        uiView.setEmitting(isEmitting, birthRate: birthRate)
    }
}

// MARK: - Internal UIView hosting CAEmitterLayer
final class EmitterUIView: UIView {
    private var emitterLayerRef: CAEmitterLayer { layer as! CAEmitterLayer }
    private var currentEmoji: String = ""
    private var cells: [CAEmitterCell] = []
    
    override class var layerClass: AnyClass { CAEmitterLayer.self }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureEmitter()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureEmitter()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the emitter fills the whole view after any size changes
        updateEmitterLayout()
    }
    
    private func configureEmitter() {
        let emitter = emitterLayerRef
        // Fill the entire view and emit from anywhere within it
        emitter.emitterShape = .rectangle
        emitter.emitterMode = .surface
        emitter.renderMode = .unordered
        
        // Layer birthRate must be > 0 for cells to emit
        emitter.birthRate = 1.0
        
        updateEmitterLayout()
    }
    
    func updateEmitterLayout() {
        // Cover the entire view; center position and full size for "everywhere" emission
        let emitter = emitterLayerRef
        emitter.frame = bounds
        emitter.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        emitter.emitterSize = bounds.size
    }
    
    func setEmoji(_ emoji: String) {
        let trimmed = emoji.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed != currentEmoji else { return }
        currentEmoji = trimmed
        
        guard !trimmed.isEmpty, let cgImage = makeEmojiImage(emoji: trimmed, fontSize: 72)?.cgImage else {
            // No emoji -> stop emitting and clear cells
            setEmitting(false, birthRate: 0)
            emitterLayerRef.emitterCells = nil
            cells = []
            return
        }
        
        // Single cell configured to emit in 360° with varied speeds and sizes
        let cell = CAEmitterCell()
        cell.name = "emoji"
        cell.contents = cgImage
        
        // Size and variation
        cell.scale = 0.9
        cell.scaleRange = 0.4
        cell.scaleSpeed = -0.1 // slight shrink
        
        // Fade out
        cell.alphaSpeed = -0.5
        
        // Lifetime
        cell.lifetime = 2.5
        cell.lifetimeRange = 1.2
        
        // Velocity and spread in all directions (360°)
        cell.velocity = 220
        cell.velocityRange = 180
        cell.emissionLongitude = 0 // base direction
        cell.emissionRange = .pi * 2 // full circle
        
        // Slight gravity so some fall down after the burst
        cell.yAcceleration = 60
        
        // Rotation
        cell.spin = 0.6
        cell.spinRange = 1.2
        
        cells = [cell]
        emitterLayerRef.emitterCells = cells
    }
    
    func setEmitting(_ on: Bool, birthRate: Float) {
        // Enable/disable the layer too
        emitterLayerRef.birthRate = on ? 1.0 : 0.0
        
        guard !cells.isEmpty else { return }
        // Single cell -> use provided birthRate directly
        let perCell = on ? max(0, birthRate) : 0
        for c in cells {
            c.birthRate = perCell
        }
        // Reassign to force CAEmitterLayer to pick up property changes immediately
        emitterLayerRef.emitterCells = cells
    }
    
    // Renders the emoji into a UIImage for use as the emitter cell content
    private func makeEmojiImage(emoji: String, fontSize: CGFloat = 72, padding: CGFloat = 8) -> UIImage? {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let nsStr = NSString(string: emoji)
        
        let textSize = nsStr.size(withAttributes: attributes)
        let imageSize = CGSize(width: textSize.width + padding * 2,
                               height: textSize.height + padding * 2)
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: imageSize, format: format)
        let image = renderer.image { ctx in
            UIColor.clear.setFill()
            ctx.fill(CGRect(origin: .zero, size: imageSize))
            let drawPoint = CGPoint(
                x: (imageSize.width - textSize.width) / 2,
                y: (imageSize.height - textSize.height) / 2
            )
            nsStr.draw(at: drawPoint, withAttributes: attributes)
        }
        return image
    }
}
