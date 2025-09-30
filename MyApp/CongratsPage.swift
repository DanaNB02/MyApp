// ContentView.swift
//
// REMOVE the extra TimedWord and ChunkTimestamp structs from here.
// Keep only ONE definition of ChunkTimestamp (the one with Identifiable).

import SwiftUI
import AVFoundation
import Combine



// AudioCoordinator.swift (Pasted into ContentView.swift)
import Foundation
import Combine
import AVFoundation

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
    
    func stop() {
        player?.stop()
        self.isPlaying = false
        self.currentTime = 0.0
        timer?.cancel()
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }
}

// Using the preferred structure: ChunkTimestamp defined once.
struct ChunkTimestamp: Codable, Identifiable {
    var id: Double { start } // Use start time as a simple unique ID
    let text: String
    let start: Double
    let end: Double
}

struct CongratsPage: View {
    // AudioCoordinator must be in a separate file OR defined before this struct.
    @StateObject private var audio = AudioCoordinator()
    
    @State private var chunks: [ChunkTimestamp] = []
    @State private var activeChunkIndex: Int = -1
    
    // The full story text (must match the concatenation of chunks.text)
    // NOTE: This fullStory string is now just for reference. The logic below
    // constructs the paragraph from the 'chunks' array.
    private let fullStory: String = "قصة٢ : كان هناك أسدٌ قويٌ استلقى للنوم، فمرّ فأرٌ صغير فوقه فأيقظه. أمسك الأسد بالفأر وتوسل إليه ليتركه قائلًا: ‘قد أساعدك يومًا ما’. ضحك الأسد وأطلق سراحه، وبعد أيام وقع الأسد في شبكة صيادين، فجاء الفأر وقطع الحبال بأسنانه لينقذ الأسد"

    var body: some View {
        NavigationStack {
            ZStack {
                let bgColor =  Color(red: 0.763, green: 0.946, blue: 0.943)
                let textColor =  Color(red: 0.125, green: 0.181, blue: 0.443)
                
                Color(bgColor).ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    
                    // MARK: - Playback Button & Status
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

                            // Show current time
                            Text(String(format: "%.2f ث", audio.currentTime))
                                .monospaced()
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                        
                        // MARK: - Highlighted Story Text (using AttributedString)
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
                    
                    // Logo and Congrats Text (Rest of your UI)
                    Image("congratsImage")
                        .resizable().scaledToFit().frame(maxWidth: 500)
                    
                    let str = "أنت رائع\nالعالم ينتظر صوتك!"
                    Text(str)
                        .font(.custom("Tajawal-Bold", size: 40))
                        .foregroundColor(textColor)
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
            // MARK: - Lifecycle Handlers
            .onAppear {
                audio.loadAudio(named: "story2")
                chunks = loadJSON("story2_timing", as: [ChunkTimestamp].self) ?? []
                
                // Automatically start playing and tracking
                audio.play()
            }
            .onDisappear {
                audio.stop()
            }
            // MARK: - Time Tracking / Highlighting Logic
            .onChange(of: audio.currentTime) { newTime in
                // Find the index of the chunk whose time range includes the current audio time
                activeChunkIndex = chunks.firstIndex(where: { newTime >= $0.start && newTime < $0.end }) ?? activeChunkIndex
            }
        }
    }
    
    // MARK: - AttributedString Builder (Updated to use fullStory as base)
    private func attributedParagraph() -> AttributedString {
        // 1. Initialize the AttributedString with the entire story text.
        let paragraph = fullStory // Use the complete, hardcoded story string
        var attr = AttributedString(paragraph)
        
        // 2. Set up search index to handle repeated phrases correctly.
        var currentSearchIndex = paragraph.startIndex
        
        // 3. Define base attributes once
        let normalFont = AttributeContainer.font(.custom("Tajawal-Bold", size: 32))
        let highlightedFont = AttributeContainer.font(.custom("Tajawal-Bold", size: 34))
        let highlightedBackground = AttributeContainer.backgroundColor(Color.yellow.opacity(0.8))

        // Set the base font for the entire paragraph first
        attr.mergeAttributes(normalFont, mergePolicy: .keepNew)
        attr.foregroundColor = .black
        
        for (i, chunk) in chunks.enumerated() {
            // Clean the chunk text for a reliable match (remove leading/trailing spaces)
            let segmentToFind = chunk.text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Find the range of the current chunk's text in the full story string
            if let textRange = paragraph.range(of: segmentToFind, range: currentSearchIndex..<paragraph.endIndex) {
                
                let attributedRange = Range(textRange, in: attr)!
                
                // Apply a consistent space *after* the segment (except for the last one)
                // This is complex with AttributedString. We'll stick to styling the segment itself.
                
                if i == activeChunkIndex {
                    // Apply highlight style
                    attr[attributedRange].mergeAttributes(highlightedFont, mergePolicy: .keepNew)
                    attr[attributedRange].mergeAttributes(highlightedBackground, mergePolicy: .keepNew)
                } else {
                    // Remove highlight (must do this explicitly, as the base styles are already set)
                    attr[attributedRange].backgroundColor = .clear
                    // Restore normal font size for non-active chunks (if the base set it to 34)
                    attr[attributedRange].mergeAttributes(normalFont, mergePolicy: .keepNew)
                }
                
                // Move the search cursor past the found segment to ensure the next search starts after it
                currentSearchIndex = textRange.upperBound
            }
        }
        return attr
    }

    // MARK: - JSON Loader Helper
    private func loadJSON<T: Decodable>(_ name: String, as type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error: Could not find or load \(name).json")
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
