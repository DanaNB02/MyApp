import SwiftUI

struct CongratsPage: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color for the page
                Color.backgroundcolor.ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    
                    // Logo and Congrats Text
                    Image("congratsImage")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 500)
                    
                    let str = "أنت رائع\nالعالم ينتظر صوتك!"
                    Text(str)
                        .font(.custom("Tajawal-Bold", size: 40))
                        .foregroundColor(Color.textcolor)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    // End Button to navigate to the next screen
                    NavigationLink(destination: Text("Home Page Placeholder")) {
                        Text("إنهاء")
                            .font(.custom("Tajawal-Bold", size: 32))
                            .fontWeight(.bold)
                            .frame(maxWidth: 270)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    CongratsPage()
}
