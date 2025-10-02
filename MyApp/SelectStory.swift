import SwiftUI

struct SelectStory: View {
    var name: String // TODO: get the name from prev page.
    
    var body: some View {
        NavigationStack {
            
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
                
                // --- Story Buttons ---
                
                // Story 1: ID 1
                VStack {
                    Spacer()
                    NavigationLink(destination: SelectChar(name: self.name, storyID: 1)) {
                        Image("story1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 280)
                    }
                    .contentShape(Rectangle())

                    .offset(x:140 , y:-765)

                }
                
                // Story 2: ID 2
                VStack {
                    Spacer()
                    NavigationLink(destination: SelectChar(name: self.name, storyID: 2)) {
                        Image("story2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 280)
                    }
                    .contentShape(Rectangle())

                    .offset(x:-140 , y:-540)

                }
                
                // Story 3: ID 3
                VStack {
                    Spacer()
                    NavigationLink(destination: SelectChar(name: self.name, storyID: 3)) {
                        Image("story3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 280)
                    }
                    .contentShape(Rectangle())

                    .offset(x:140 , y:-300)

                }
                
                // Story 4: ID 4
                VStack {
                    Spacer()
                    NavigationLink(destination: SelectChar(name: self.name, storyID: 4)) {
                        Image("story4")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 280)
                    }
                    .contentShape(Rectangle())
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
