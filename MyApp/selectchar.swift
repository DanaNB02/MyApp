//
//  selectchar.swift
//  MyApp
//
//  Created by Reem alghamdi on 09/04/1447 AH.
//
//select character


import SwiftUI

struct selectchar: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack  {
            let bcolor = Color.backgroundcolor
            Color(bcolor).ignoresSafeArea()
            VStack(spacing: 30) {
                // العنوان الرئيسي
                Text("اختر شخصيتك المفضلة!")
                    .font(.custom("Tajawal-Regular", size: 50))
                    .bold()
                    .padding(.top, 80)
                    .foregroundColor(Color.textcolor)
                    .multilineTextAlignment(.trailing) // النص يبدأ من اليمين
                    .shadow(color: .black.opacity(0.2), radius: 10, x: -4, y: 10) // ظل النص
                
                // الكروت
                CharacterCard(
                    imageName: "elsa",
                    name: "ايلسا",
                    description: "عبّري عن مشاعرك بصوت جميل مثل الثلج المتلألئ",
                    backgroundColor: Color.elsacolor,
                    textColor: .white
                )
                
                CharacterCard(
                    imageName: "spiderman",
                    name: "سبايدر مان",
                    description: "استخدم قوتك بالكلام كما أستخدم قوتي للخير",
                    backgroundColor: Color.spidermancolor,
                    textColor: .red
                )
                
                CharacterCard(
                    imageName: "blossom",
                    name: "بلوسم",
                    description: "لتتحدث بشجاعة وابتسامة جميلة",
                    backgroundColor: Color.blosoomcolor,
                    textColor: .orange
                )
                
                CharacterCard(
                    imageName: "hulk",
                    name: "هولك",
                    description: "تكلم بثقة وأظهر قوتك الإيجابية",
                    backgroundColor: Color.hulkcolor,
                    textColor: .green
                )
                
                Spacer()
            }
            .padding()
        }
    }
}

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
                   // .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
                
                Text(description)
                    .font(.custom("Tajawal-Extrabold", size: 21))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.trailing)
                    //.shadow(color: .black.opacity(0.3), radius: 3, x: 2, y: 2)
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

// مساعد لتحويل Hex إلى Color
//extension Color {
//    init(hex: String) {
//        let scanner = Scanner(string: hex)
//        _ = scanner.scanString("#")
//
//        var rgb: UInt64 = 0
//        scanner.scanHexInt64(&rgb)
//
//        let r = Double((rgb >> 16) & 0xFF) / 255
//        let g = Double((rgb >> 8) & 0xFF) / 255
//        let b = Double(rgb & 0xFF) / 255
//
//        self.init(red: r, green: g, blue: b)
//    }
//}

#Preview {
    selectchar()
}

