import SwiftUI

struct selectstory: View {
    var name: String   // ← هذا يستقبل الاسم من الصفحة السابقة
    
    var body: some View {
        ZStack {
            
            Color.backgroundcolor // اللون اللي تبغاه
                .ignoresSafeArea()
            
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: 780, height: 580)
            
            
            VStack {

                Text("أهلاً \(name) !")
                    .fontWeight(.bold)
                    .foregroundColor(.textcolor)
                    .padding(.top, 20)
                    .font(.custom("Tajawal-Regular", size: 50))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 50)
                
                Spacer()
            }
            
            // الأزرار
            VStack {
                Spacer()
                Button(action: {
                    print("تم الضغط على الزر")
                }) {
                    Image("story1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 280)
                        .offset(x:160 , y:-810)
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
                        .offset(x:-170 , y:-540)
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
                        .offset(x:170 , y:-300)
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
                        .offset(x:-160, y:-25)
                }
            }
        }
    }
}

#Preview {
    selectstory(name: "ريم")
}
