
import SwiftUI

struct Splash: View {
    @State private var goToHome: Bool = false
    var body: some View {
        NavigationStack{
            
            
            ZStack{
                Color(red:195/255 , green:235/255 , blue: 241/255)
                    .ignoresSafeArea(edges: .all)
                VStack(spacing:-200){
                    Image("bird")
                        .resizable()
                        .frame(width: 650, height: 800)
                        .offset(x: 100, y: 0)
                        .padding()
                    
                    Text("صوتك يغير القصة")
                        .font(.custom("Tajawal-Regular", size: 50))
                        .foregroundColor(.textcolor)
                }
                
                
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    goToHome = true
                }
            }
            .navigationDestination(isPresented: $goToHome){
                HomePage()
            }
        }
        
        
     
    }
}
  

#Preview {
    Splash()
}
