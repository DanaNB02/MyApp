//
//  ContentView.swift
//  CongratsPage
//
//  Created by Dana on 07/04/1447 AH.
//

import SwiftUI

struct CongratsPage: View {
    var body: some View {
        NavigationStack{
            ZStack {
                // Background color
                let bgColor = #colorLiteral(red: 0.7633937001, green: 0.9465207458, blue: 0.9436731935, alpha: 1)
                let textColor = #colorLiteral(red: 0.125461787, green: 0.1819829941, blue: 0.4435631931, alpha: 1)
                Color(bgColor)
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 20) {
                    Spacer() // pushes down
                    // Logo
                    Image("congratsImage")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 500)
                    
                    
                    let str = """
                   أنت رائع 
                   العالم ينتظر صوتك! 
                   """
                    // Congrats text
                    Text(str)
                        .font(.custom("Tajawal-Bold", size: 40))
                        .foregroundColor(Color(textColor))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    
                    
                    // Start button
                    NavigationLink(destination: HomePage()){
                        Text("إنهاء")
                            .font(.custom("Tajawal-Bold", size: 32))
                            .fontWeight(.bold)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                            .foregroundColor(Color.white)
                    }
                    
                    Spacer() // pushes up
                }
            }
        }
    }
}

#Preview {
    CongratsPage()
}
