//
//  selectchar.swift
//  MyApp
//
//  Created by Reem alghamdi on 09/04/1447 AH.
//
//select character


import SwiftUI

struct SelectChar: View {
    @Environment(\.dismiss) var dismiss
    var name: String // Passed from SelectStory
    var storyID: Int // Passed from SelectStory

    // Function to implement the audio selection logic
    func getAudioFileName(for characterName: String) -> String {
        let voicePrefix: String
        
        // 1. Determine the voice based on the Arabic character name
        switch characterName {
        case "ايلسا", "بلوسم": // Girl Voice
            voicePrefix = "girl"
        case "سبايدر مان", "هولك": // Boy Voice
            voicePrefix = "boy"
        default:
            // This case should ideally not be hit
            voicePrefix = "default"
        }
        
        // 2. Combine the voice prefix and the story ID
        // Final file name format: "girl_story1", "boy_story3", etc.
        return "\(voicePrefix)_story\(storyID)"
    }
    
    var body: some View {
        ZStack {
            let bcolor = Color.backgroundcolor
            Color(bcolor).ignoresSafeArea()
            
            VStack(spacing: 30) {
                // العنوان الرئيسي
                Text("اختر شخصيتك المفضلة!")
                    .font(.custom("Tajawal-Regular", size: 50))
                    .bold()
                    .padding(.top, 80)
                    .foregroundColor(Color.textcolor)
                    .multilineTextAlignment(.trailing)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: -4, y: 10)
                
                // الكروت - Wrapped in NavigationLink and data logic applied
                
                // Elsa Card (ID: ايلسا -> girl)
                NavigationLink(destination: StoryView(
                    storyID: self.storyID,
                    characterImage: "elsa",
                    backgroundColor: Color.elsacolor,
                    audioFileName: getAudioFileName(for: "ايلسا") // Calls the audio logic
                )) {
                    CharacterCard(
                        imageName: "elsa",
                        name: "ايلسا",
                        description: "عبّري عن مشاعرك بصوت جميل مثل الثلج المتلألئ",
                        backgroundColor: Color.elsacolor,
                        textColor: .white
                    )
                }
                .buttonStyle(.plain) // Keeps the custom card look
                
                // Spiderman Card (ID: سبايدر مان -> boy)
                NavigationLink(destination: StoryView(
                    storyID: self.storyID,
                    characterImage: "spiderman",
                    backgroundColor: Color.spidermancolor,
                    audioFileName: getAudioFileName(for: "سبايدر مان") // Calls the audio logic
                )) {
                    CharacterCard(
                        imageName: "spiderman",
                        name: "سبايدر مان",
                        description: "استخدم قوتك بالكلام كما أستخدم قوتي للخير",
                        backgroundColor: Color.spidermancolor,
                        textColor: .red
                    )
                }
                .buttonStyle(.plain)
                
                // Blossom Card (ID: بلوسم -> girl)
                NavigationLink(destination: StoryView(
                    storyID: self.storyID,
                    characterImage: "blossom",
                    backgroundColor: Color.blosoomcolor,                    audioFileName: getAudioFileName(for: "بلوسم") // Calls the audio logic
                )) {
                    CharacterCard(
                        imageName: "blossom",
                        name: "بلوسم",
                        description: "لتتحدث بشجاعة وابتسامة جميلة",
                        backgroundColor: Color.blosoomcolor,
                        textColor: .orange
                    )
                }
                .buttonStyle(.plain)
                
                // Hulk Card (ID: هولك -> boy)
                NavigationLink(destination: StoryView(
                    storyID: self.storyID,
                    characterImage: "hulk",
                    backgroundColor: Color.hulkcolor,
                    audioFileName: getAudioFileName(for: "هولك") // Calls the audio logic
                )) {
                    CharacterCard(
                        imageName: "hulk",
                        name: "هولك",
                        description: "تكلم بثقة وأظهر قوتك الإيجابية",
                        backgroundColor: Color.hulkcolor,
                        textColor: .green
                    )
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding()
        }
    }
}

// CharacterCard struct remains exactly as you provided
struct CharacterCard: View {
    let imageName: String
    let name: String
    let description: String
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        HStack(spacing: 20) {
            // صورة الشخصية + ظل
            Image(imageName)
                .resizable()
                .frame(width: 200, height: 290)
                .padding(.top, 70)
                .shadow(color: .black.opacity(0.2), radius: 10, x: -3, y: 10)
            
            // النصوص (يمين لليسار + ظل)
            VStack(alignment: .trailing, spacing: 10) {
                Text(name)
                    .font(.custom("Tajawal-Regular", size: 50))
                    .bold()
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.trailing)
                
                Text(description)
                    .font(.custom("Tajawal-Extrabold", size: 21))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.trailing)
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(width: 689, height: 170)
        .padding()
        .background(backgroundColor)
        .cornerRadius(25)
        .shadow(color: .gray.opacity(0.2), radius: 10, x: -4, y: 10)
    }
}


#Preview {
    // Wrap in NavigationStack for the preview to work correctly
    NavigationStack {
        SelectChar(name: "سالم", storyID: 3)
    }
    
}
