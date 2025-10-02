import SwiftUI
import AVFoundation

// --- Data Models (Simplified for single text block) ---
struct StoryContent: Decodable {
    let id: Int
    let fullText: String
}

// --- Helper to load JSON Data ---
func loadFullStoryText(for storyID: Int) -> String {
    guard let url = Bundle.main.url(forResource: "stories", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let allStories = try? JSONDecoder().decode([StoryContent].self, from: data),
          let story = allStories.first(where: { $0.id == storyID }) else {
        print("Failed to load story content for ID: \(storyID)")
        return "حدث خطأ في تحميل القصة."
    }
    return story.fullText
}

// --- Dynamic Story View (The final playback screen) ---
struct StoryView: View {
    
    // Inputs passed from SelectChar
    let storyID: Int
    let characterImage: String
    let backgroundColor: Color
    let audioFileName: String // e.g., "girl_story3"

    // View State
    @State private var fullStoryText: String = "" // Holds the text loaded from JSON
    @State private var isPlaying: Bool = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showEmojis = false // Kept for your original design

    // --- Audio Logic ---
    func prepareAudio() {
        guard let url = Bundle.main.url(forResource: audioFileName, withExtension: "mp3") else {
            print("Audio file \(audioFileName).mp3 not found.")
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

    // --- View Body ---
    var body: some View {
        ZStack {
            // Use dynamic background color
            backgroundColor.ignoresSafeArea()

                VStack(spacing: 30) {
                    ZStack {
                        // Your Emoji Emitter goes here if needed
                        if showEmojis {
                            // Replace with your actual EmojiEmitter view
                            // EmojiEmitter()
                        }
                        
                        // Image (Dynamic)
                        Image(characterImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 800)
                            .shadow(radius: 8)
                            .cornerRadius(16)
                            .offset(x: 0 , y:-100)
                        
                        // Text Content (Now a single text block)
                        VStack(alignment: .center, spacing: 16) {
                            Text(fullStoryText) // Display the single string
                                .font(.custom("Tajawal-bold", size: 27))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.nextprevcolor)
                                .padding(.horizontal, 15)
                                .lineSpacing(15)// Add padding for better reading
                                .offset(x: 0 , y:220)
                        }
                        // Background Card (Your original design)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 60)
                                .fill(Color.white)
                                .frame(width: 830, height: 600)
                                .offset(x: 0 , y:320)
                                .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 4)
                        )
                        
                        // Audio Controls
                        HStack(spacing: 50) {
                            // Previous Button
                            Button(action: { print("Previous tapped") }) {
                                Circle()
                                    .fill(Color.nextprevcolor)
                                    .frame(width: 64, height: 64)
                                    .shadow(radius: 4)
                                    .overlay(Image(systemName: "chevron.left").font(.system(size: 20, weight: .bold)).foregroundColor(.white))
                            }
                            
                            // Play/Pause Button
                            Button(action: { playPause() }) {
                                Circle()
                                    .fill(Color.startcolor)
                                    .frame(width: 112, height: 112)
                                    .shadow(radius: 6)
                                    .overlay(
                                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                            .font(.system(size: 36, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .scaleEffect(isPlaying ? 1.05 : 1.0)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isPlaying)
                            }
                            
                            // Next Button
                            Button(action: { print("Next tapped") }) {
                                Circle()
                                    .fill(Color.nextprevcolor)
                                    .frame(width: 64, height: 64)
                                    .shadow(radius: 4)
                                    .overlay(Image(systemName: "chevron.right").font(.system(size: 20, weight: .bold)).foregroundColor(.white))
                            }
                        }
                        .offset(x: 0 , y:460)
                        .padding(.top, 30)
                    }
                    .padding()
                }
            }
        
        .onAppear {
            // Load content and prepare audio when the view appears
            fullStoryText = loadFullStoryText(for: storyID)
            prepareAudio()
        }
        .onDisappear {
            // Stop audio when navigating away
            stopAudioIfNeeded()
        }
    }
}
