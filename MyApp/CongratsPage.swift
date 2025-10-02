import SwiftUI
import AVFoundation
import Combine



import Foundation
import Combine
import AVFoundation


// For audio load, play, pause, and stop. Also ublishes the currentTime to the UI.
class AudioCoordinator: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0.0
    
    private var player: AVAudioPlayer?
    private var timer: AnyCancellable?
    
    func loadAudio(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Error: Audio file '\(name).mp3' not found.")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            self.isPlaying = false
        } catch {
            print("Error loading or setting up audio: \(error.localizedDescription)")
        }
    }
    
    func play() {
        guard let player = player else { return }
        player.play()
        self.isPlaying = true
        
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, player.isPlaying else { return }
                self.currentTime = player.currentTime
            }
    }
    
    func pause() {
        player?.pause()
        self.isPlaying = false
        timer?.cancel()
    }
    
    // stop when the user click off the page.
    func stop() {
        player?.stop()
        self.isPlaying = false
        self.currentTime = 0.0
        timer?.cancel()
    }
    
    // stop when the audio finishes.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }
}


// ----------------------------

// Data model for chunk of text with its corresponding time. Read data from JSON.
struct ChunkTimestamp: Codable, Identifiable {
    var id: Double { start }
    let text: String
    let start: Double
    let end: Double
}

// ----------------------------

// The UI
struct CongratsPage: View {
    @StateObject private var audio = AudioCoordinator()
    
    // Texts from JSON
    @State private var chunks: [ChunkTimestamp] = []
    @State private var activeChunkIndex: Int = -1
    
    
    // Used as a reference later.
    private let fullStory: String =  "بحث غرابٌ عن الماء في صيفٍ حار، فوجد إناءً فيه قليل من الماء في القاع لا يستطيع الوصول إليه. لم يستسلم الغراب، بل بدأ بجمع الحجارة الصغيرة وأسقطها في الإناء، فارتفع مستوى الماء، وهكذا شرب الماء بنجاح."

    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.backgroundcolor.ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    
                    
                    // Playback button.
                    VStack (alignment: .center, spacing: 10){
                        HStack(spacing: 20) {
                            Button(audio.isPlaying ? "⏸ إيقاف مؤقت" : "▶️ تشغيل") {
                                audio.isPlaying ? audio.pause() : audio.play()
                            }
                            .font(.custom("Tajawal-Bold", size: 28))
                            .padding()
                            .frame(maxWidth: 250)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                                                    }
                                                    
                                                    // Call attributedParagraph to display highlited text.
                                                    ScrollView {
                                                        Text(attributedParagraph())
                                                            .font(.custom("Tajawal-Bold", size: 32))
                                                            .foregroundColor(Color.black)
                                                            .environment(\.layoutDirection, .rightToLeft)
                                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                                            .padding(.horizontal)
                                                    }
                                                    .frame(height: 300)
                                                }
                                                
                                                // Logo and Congrats Text
                                                Image("congratsImage")
                                                    .resizable().scaledToFit().frame(maxWidth: 500)
                                                
                                                let str = "أنت رائع\nالعالم ينتظر صوتك!"
                                                Text(str)
                                                    .font(.custom("Tajawal-Bold", size: 40))
                                                    .foregroundColor(Color.textcolor)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.bottom, 20)
                                                
                                                // End Button
                                                NavigationLink(destination: Text("Home Page Placeholder")) {
                                                    Text("إنهاء")
                                                        .font(.custom("Tajawal-Bold", size: 32)).fontWeight(.bold)
                                                        .frame(maxWidth: 270).padding()
                                                        .background(Color.orange).cornerRadius(12).foregroundColor(.white)
                                                }
                                                
                                                Spacer()
                                            }
                                        }
                                        // Lifecycle Handlers
                                        .onAppear {
                                            audio.loadAudio(named: "story1")
                                            chunks = loadJSON("story1_timing", as: [ChunkTimestamp].self) ?? []
                                            
                                            // Automatically start playing and tracking
                                            audio.play()
                                        }
                                        .onDisappear {
                                            audio.stop()
                                        }
                                        // Time tracking & highlighting logic
                                        .onChange(of: audio.currentTime) { newTime in
                                            // Find the index of the chunk whose time range includes the current audio time
                                            activeChunkIndex = chunks.firstIndex(where: { newTime >= $0.start && newTime < $0.end }) ?? activeChunkIndex
                                        }
                                    }
                                }
                                
                                
                            // ----------------------------

                                // AttributedString builder - compare base paragraph with JSON file to highlight text based on their timestamp.
    private func attributedParagraph() -> AttributedString {
        // 1. Initialize the AttributedString with the entire story text.
        let paragraph = fullStory
        var attr = AttributedString(paragraph)
        
        // 2. Starting index for tracking
        var currentSearchIndex = paragraph.startIndex
        
        // Define styling attributes
        let normalFont = AttributeContainer.font(.custom("Tajawal-Bold", size: 32))
        let highlightedFont = AttributeContainer.font(.custom("Tajawal-Bold", size: 34))
        let highlightedBackground = AttributeContainer.backgroundColor(Color.yellow.opacity(0.8))
        attr.mergeAttributes(normalFont, mergePolicy: .keepNew)
                attr.foregroundColor = .black
                
                for (i, chunk) in chunks.enumerated() {
                    // 3- Clean the text chunk for better comparison.
                    let segmentToFind = chunk.text.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // 4- Search for the text chunk inside the full story.
                    if let textRange = paragraph.range(of: segmentToFind, range: currentSearchIndex..<paragraph.endIndex) {
                        
                        let attributedRange = Range(textRange, in: attr)!
                                        
                        if i == activeChunkIndex {
                            // 5- Once we find the chunk highlight it.
                            attr[attributedRange].mergeAttributes(highlightedFont, mergePolicy: .keepNew)
                            attr[attributedRange].mergeAttributes(highlightedBackground, mergePolicy: .keepNew)
                        } else {
                            // 6- Cleaning
                            // Remove highlight
                            attr[attributedRange].backgroundColor = .clear
                            // Restore normal font size for non-active chunks
                            attr[attributedRange].mergeAttributes(normalFont, mergePolicy: .keepNew)
                        }
                        
                        // Increase the index.
                        currentSearchIndex = textRange.upperBound
                    }
                }
                return attr
            }

            
        // ----------------------------

            // JSON loader to convert from and to JSON.
            private func loadJSON<T: Decodable>(_ name: String, as type: T.Type) -> T? {
                guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
                      let data = try? Data(contentsOf: url) else {
                    print("Error: Could not find or load \(name).json")
                    return nil
                }
                return try? JSONDecoder().decode(T.self, from: data)
            }
        }
