import SwiftUI

struct SelectStory: View {
    var name: String // TODO: get the name from prev page.
    
    var body: some View {
        ZStack {
            Color.backgroundcolor
                .ignoresSafeArea()

                        
            Image("backgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: 700, height: 500)
            
            
            VStack {

                Text("أهلاً \(name) !")
                    .fontWeight(.bold)
                    .foregroundColor(.textcolor)
                    .font(.custom("Tajawal-Regular", size: 50))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 50)
                    .offset(x: 10, y: -25)
                
                Spacer()
            }
            
            // الأزرار
            // all buttons lead to the same page 'selectChar' but you need to store the story id
            VStack {
                Spacer()
                Button(action: {
                    print("تم الضغط على الزر")
                }) {
                    Image("story1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 280)
                        .offset(x:140 , y:-765)
                }
            }
            
            VStack {
                Spacer()
                Button(action: {
                    print("تم الضغط على الزر")
                }) {
                    Image("story2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 280)
                        .offset(x:-140 , y:-540)
                }
            }
            
            VStack {
                Spacer()
                Button(action: {
                    print("تم الضغط على الزر")
                }) {
                    Image("story3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 280)
                        .offset(x:140 , y:-300)
                }
            }
            
            VStack {
                Spacer()
                Button(action: {
                    print("تم الضغط على الزر")
                }) {
                    Image("story4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 280)
                        .offset(x:-140, y:-70)
                }
            }
        }
    }
}

#Preview {
    // TODO: get the name from prev page.
    SelectStory(name: "")
}
