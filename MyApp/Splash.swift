
import SwiftUI

struct Splash: View {
    var body: some View {
        ZStack{
            Color(red:195/255 , green:235/255 , blue: 241/255)
                .ignoresSafeArea(edges: .all)
            VStack(spacing:-200){
                Image("bird")
                    .resizable()
                    .frame(width: 800, height: 800)
                    .offset(x: 100, y: 0)
                       .padding()
                    
                Text("صوتك يغير القصة")
                    .font(.largeTitle)
                
            }
                
            
            
        }
        
        
     
       // .padding()
    }
}
  

#Preview {
    Splash()
}
