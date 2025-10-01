
import SwiftUI
import AVFoundation
import Combine

struct StorySentence1: Identifiable {
    let id = UUID()
    let text: String
    let isAngry: Bool
}

final class StoryViewModel1: ObservableObject {
    @Published var sentences: [StorySentence1] = [
        StorySentence1(text: "بحث غرابٌ عن الماء في صيفٍ حار.", isAngry: true),
        StorySentence1(text: "فوجد إناءً فيه قليل من الماء في القاع لا يستطيع الوصول إليه.", isAngry: false),
        StorySentence1(text: "لم يستسلم الغراب.", isAngry: false),
        StorySentence1(text: "بدأ بجمع الحجارة الصغيرة وأسقطها في الإناء.", isAngry: false),
        StorySentence1(text: "فارتفع مستوى الماء وهكذا شرب الماء بنجاح.", isAngry: false)
    ]

    @Published var isPlaying: Bool = false
    var audioPlayer: AVAudioPlayer?

    init() {
        prepareAudio()
    }

    func prepareAudio() {
        guard let url = Bundle.main.url(forResource: "story1", withExtension: "m4a") else {
            print("story1.m4a not found.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Audio error:", error)
        }
    }

    func playPause() {
        guard let player = audioPlayer else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func stopAudioIfNeeded() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
    }
}

struct HulkStory: View {
    @StateObject private var vm = StoryViewModel1()
    @State private var showEmojis = false

    var body: some View {
        ZStack {
            Color.hulkcolor.ignoresSafeArea()
        

            ScrollView {
                VStack(spacing: 30) {
                    ZStack {if showEmojis {
                        EmojiEmitter()
                            .frame(width: 200, height: 200)
                            .allowsHitTesting(false)
                            .transition(.opacity)
                    }
                        Image("hulk")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 800)
                            .shadow(radius: 8)
                            .cornerRadius(16)
                            .offset(x: 0 , y:0)
                        
                        
                        
                        
                        VStack(alignment: .center, spacing: 16) {
                            ForEach(vm.sentences) { sentence in
                                Text(sentence.text)
                                    .font(.custom("Tajawal-Regular", size: 25))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.nextprevcolor)
                                    .offset(x: 0 , y:220)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 60)
                                .fill(Color.white)
                                .frame(width: 830, height: 500)
                                .offset(x: 0 , y:320)
                                .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 4)
                        )
                        
                        HStack(spacing: 50) {
                            Button(action: {
                                print("Previous tapped")
                            }) {
                                Circle()
                                    .fill(Color.nextprevcolor)
                                    .frame(width: 64, height: 64)
                                    .shadow(radius: 4)
                                    .overlay(
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            Button(action: {
                                vm.playPause()
                                // نشغّل الإيموجيات إذا فيه أي جملة Angry
                                if vm.sentences.contains(where: { $0.isAngry }) && vm.isPlaying {
                                    withAnimation { showEmojis = true }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                                        withAnimation { showEmojis = false }
                                    }
                                }
                            }) {
                                Circle()
                                    .fill(Color.startcolor)
                                    .frame(width: 112, height: 112)
                                    .shadow(radius: 6)
                                    .overlay(
                                        Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                                            .font(.system(size: 36, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .scaleEffect(vm.isPlaying ? 1.05 : 1.0)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: vm.isPlaying)
                            }
                            
                            Button(action: {
                                print("Next tapped")
                            }) {
                                Circle()
                                    .fill(Color.nextprevcolor)
                                    .frame(width: 64, height: 64)
                                    .shadow(radius: 4)
                                    .overlay(
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                            }
                        }  .offset(x: 0 , y:460)
                        .padding(.top, 30)
                    }
                    .padding()
                }}
        }
        .onDisappear { vm.stopAudioIfNeeded() }
    }
}

// نفس مكوّن الإيموجيات القديم
struct EmojiEmitter1: View {
    @State private var particles: [EmojiParticle1] = []
    private let emojis = ["😠", ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { p in
                    Text(p.char)
                        .font(.system(size: p.size))
                        .opacity(p.opacity)
                        .scaleEffect(p.scale)
                        .position(x: p.x * geo.size.width, y: p.y * geo.size.height)
                        .animation(.easeInOut(duration: p.duration), value: p.opacity)
                        .animation(.easeOut(duration: p.duration), value: p.y)
                }
            }
//            .onAppear {
//                spawnLoop(in: geo.size)
            }
        }
    }

//    func spawnLoop(in size: CGSize) {
//        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true) { _ in
//            let count = Int.random(in: 4...7)
//            for _ in 0..<count {
//                let emoji = emojis.randomElement() ?? "😠"
//
//                let startX = CGFloat.random(in: 0.0...1.0)
//                let startY = CGFloat.random(in: 0.0...8.2) // يبدأ من أسفل
//                let endY = CGFloat.random(in: -0.2...0.0)  // يطلع فوق
//
//                let duration = Double.random(in: 5.0...10.0)
//
//                var p = EmojiParticle(
//                    char: emoji,
//                    x: startX,
//                    y: startY,
//                    size: CGFloat.random(in: 90...100),
//                    opacity: 10.0,
//                    scale: 1.0,
//                    duration: duration
//                )
//
//                particles.append(p)
//
//                // حركة ناعمة وسلسة تغطي كامل الصفحة
//                withAnimation(.interpolatingSpring(stiffness: 1000, damping: 10).speed(10)) {
//                    if let index = particles.firstIndex(where: { $0.id == p.id }) {
//                        particles[index].y = endY
//                        particles[index].opacity = 10
//                        particles[index].scale = CGFloat.random(in: 50...100)
//                    }
//                }
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
//                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
//                    particles.removeAll { $0.id == p.id }
//                }
//            }
//        }
//    }

//}

struct EmojiParticle1: Identifiable {
    let id = UUID()
    let char: String
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var scale: CGFloat
    var duration: Double
}

#Preview {
    HulkStory()
}
