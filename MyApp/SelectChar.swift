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
    SelectChar()
}

