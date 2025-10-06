import SwiftUI
import AVFoundation
import Combine

// MARK: - Audio Coordinator (Moved from CongratsPage)
// This class handles loading and playing audio, and crucially,
// publishes the `currentTime` which we need to sync the highlighting.
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
        player?.currentTime = 0
        self.isPlaying = false
        self.currentTime = 0.0
        timer?.cancel()
    }
    var onAudioFinished: (() -> Void)?
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
        onAudioFinished?()
    }
}


// MARK: - Data Models & Helpers

// Represents one chunk of text with its timing and emoji.
struct ChunkTimestamp: Codable, Identifiable {
    var id: Double { start }
    let text: String
    let start: Double
    let end: Double
    let emoji: String
}

// Generic helper to load any Codable type from a JSON file in the app bundle.
private func loadJSON<T: Decodable>(_ name: String, as type: T.Type) -> T? {
    guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        print("Error: Could not find or load \(name).json")
        return nil
    }
    return try? JSONDecoder().decode(T.self, from: data)
}

// load the full story text from your "fullStories.json" file.
func loadFullStoryText(for storyKey: String) -> String {
    guard let allStories = loadJSON("fullStories", as: [String: String].self),
          let storyText = allStories[storyKey] else {
        print("Failed to load story content for key: \(storyKey)")
        return "حدث خطأ في تحميل القصة."
    }
    return storyText
}


// MARK: - Main Story View

struct StoryView: View {
    // --- Inputs passed from SelectChar ---
    let name: String
    let storyID: Int
    let characterImage: String
    let backgroundColor: Color
    let audioFileName: String // e.g., "girl_story1"

    // --- State for Audio and Highlighting ---
    @StateObject private var audioCoordinator = AudioCoordinator()
    @State private var fullStoryText: String = ""
    @State private var chunks: [ChunkTimestamp] = []
    @State private var activeChunkIndex: Int = -1
    @State private var showPopup = false


    // Your original state property
    @State private var showEmojis = false

    // Current emoji for the active chunk (trimmed), empty if none
    private var currentEmoji: String {
        guard activeChunkIndex >= 0 && activeChunkIndex < chunks.count else { return "" }
        return chunks[activeChunkIndex].emoji.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Should the emitter be on right now?
    private var isEmitting: Bool {
        audioCoordinator.isPlaying && !currentEmoji.isEmpty && activeChunkIndex != -1
    }

    // --- View Body ---
    var body: some View {
        NavigationStack {
            
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                // Place the emitter BEHIND everything so it never shows inside the white board,
                // and appears visually behind the character image.
                EmojiEmitter(
                    emoji: currentEmoji,
                    isEmitting: isEmitting,
                    birthRate: 5.0 // tweak as you like
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
                
                VStack(spacing: 30) {
                 
                    ZStack {
                        // Image (Dynamic)
                        Image(characterImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 800)
                            .shadow(radius: 8)
                            .cornerRadius(16)
                            .offset(x: 0, y: -100)
                        
                        // --- CHANGED: This now displays the Attributed String ---
                        
                        Text(attributedParagraph()) // Display the styled, highlighted text
                            .font(.custom("Tajawal-bold", size: 27))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.nextprevcolor)
                            .padding(.horizontal, 15)
                            .lineSpacing(15)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                            .frame(width: 830, height: 600)// Give the scroll view a reasonable height
                            .offset(x: 0, y: 220)
                        
                        // Background Card (Your original design)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 60)
                                    .fill(Color.white)
                                    .frame(width: 830, height: 600)
                                    .offset(x: 0, y: 320)
                                    .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 4)
                            )
                        if showPopup {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(radius: 10)
                                
                                VStack(spacing: 12) {
                                    Text("حان دورك الآن")
                                        .font(.custom("Tajawal-Bold", size: 22))
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(width: 300, height: 150)
                            .overlay(
                                Button(action: {
                                    showPopup = false
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.gray)
                                }
                                .padding(8),
                                alignment: .topTrailing
                            )
                            .animation(.spring(), value: showPopup)
                        }
                        // --- CHANGED: Audio Controls now use AudioCoordinator ---
                        HStack(spacing: 50) {
                           
                            
                            NavigationLink(destination: SelectChar(name: self.name, storyID: storyID)){
                                Circle().fill(Color.nextprevcolor).frame(width: 64, height: 64).shadow(radius: 4).overlay(Image(systemName: "chevron.left").font(.system(size: 20, weight: .bold)).foregroundColor(.white))
                            }
                            
                            Button(action: {
                                // Use the coordinator to play or pause
                                audioCoordinator.isPlaying ? audioCoordinator.pause() : audioCoordinator.play()
                            }) {
                                Circle()
                                    .fill(Color.startcolor)
                                    .frame(width: 112, height: 112)
                                    .shadow(radius: 6)
                                    .overlay(
                                        Image(systemName: audioCoordinator.isPlaying ? "pause.fill" : "play.fill")
                                            .font(.system(size: 36, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .scaleEffect(audioCoordinator.isPlaying ? 1.05 : 1.0)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: audioCoordinator.isPlaying)
                            }
                            
                            
                            NavigationLink(destination: CongratsPage(name: self.name)){
                                Circle().fill(Color.nextprevcolor).frame(width: 64, height: 64).shadow(radius: 4).overlay(Image(systemName: "chevron.right").font(.system(size: 20, weight: .bold)).foregroundColor(.white))
                            }
                    
                        }
                        
                        .offset(x: 0, y: 460)
                        .padding(.top, 30)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            // Load all necessary data when the view appears
            let storyKey = "story\(storyID)"
            fullStoryText = loadFullStoryText(for: storyKey)
            
            // The audio file name is the same as the timing JSON file name
            chunks = loadJSON(audioFileName, as: [ChunkTimestamp].self) ?? []
            audioCoordinator.loadAudio(named: audioFileName)
            audioCoordinator.onAudioFinished = {
                showPopup = true
                // Hide popup automatically after 15 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    showPopup = false
                }
            }
            activeChunkIndex = -1
        }
        .onDisappear {
            // Stop audio and clean up when the view disappears
            audioCoordinator.stop()
        }
        // --- UPDATED: Link audio time to highlighting and reset index during gaps ---
        .onChange(of: audioCoordinator.currentTime) { newTime in
            if let idx = chunks.firstIndex(where: { newTime >= $0.start && newTime < $0.end }) {
                if idx != activeChunkIndex {
                    // Debug: print when chunk changes
                    print("Active chunk -> \(idx), emoji: \(chunks[idx].emoji)")
                }
                activeChunkIndex = idx
            } else {
                if activeChunkIndex != -1 {
                    print("No active chunk (gap)")
                }
                activeChunkIndex = -1
            }
        }
    }

    // MARK: - Highlighting Logic (Moved from CongratsPage)
    
    /// Creates a styled `AttributedString` where the currently active text chunk is highlighted.
    private func attributedParagraph() -> AttributedString {
        var attrString = AttributedString(fullStoryText)
        var searchStartIndex = fullStoryText.startIndex

        // Define styling attributes
        let normalFont = AttributeContainer.font(.custom("Tajawal-Bold", size: 27))
        let highlightedFont = AttributeContainer.font(.custom("Tajawal-Bold", size: 29)) // Slightly larger
        let highlightedBackground = AttributeContainer.backgroundColor(Color.yellow.opacity(0.5))
        
        attrString.mergeAttributes(normalFont, mergePolicy: .keepNew)

        for (index, chunk) in chunks.enumerated() {
            let textToFind = chunk.text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Search for the chunk's text within the full story
            if let range = fullStoryText.range(of: textToFind, range: searchStartIndex..<fullStoryText.endIndex) {
                if let attributedRange = Range(range, in: attrString) {
                    
                    // If this is the active chunk, apply highlighting
                    if index == activeChunkIndex {
                        attrString[attributedRange].mergeAttributes(highlightedFont, mergePolicy: .keepNew)
                        attrString[attributedRange].mergeAttributes(highlightedBackground, mergePolicy: .keepNew)
                    }
                    // (No 'else' needed because the default state is already set)
                }
                // Move the search position forward to avoid re-matching the same text
                searchStartIndex = range.upperBound
            }
        }
        
        return attrString
    }
}
