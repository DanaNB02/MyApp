import SwiftUI

struct HomePage: View {
    @State private var name: String = ""

    
    var body: some View {
        NavigationStack{
            ZStack {
                // Background color
                Color.backgroundcolor
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 20) {
                    Spacer() // pushes down
                    // Logo
                    Image("homePage")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 500)
                    
                    // Name text field
                    TextField("اسمك", text: $name)
                        .foregroundColor(Color.blue)
                        .font(.custom("Tajawal-Regular", size: 24))
                        .padding()
                        .frame(maxWidth: 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                        .multilineTextAlignment(.center)
                    // to remove the default styles
                        .textFieldStyle(.plain)
                    
                    
                    
                    
                    // Start button
                    NavigationLink(destination: SelectStory(name: name)){
                        Text("ابدأ")
                            .font(.custom("Tajawal-Bold", size: 30))
                            .fontWeight(.bold)
                            .frame(maxWidth: 270)
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
    HomePage()
}
