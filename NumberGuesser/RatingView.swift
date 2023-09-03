import Foundation
import SwiftUI

struct RatingView: View {
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.score, order: .reverse)]) private var scores: FetchedResults<GameResult>
    
    @State private var listOpacity: Double = 0.0
    @State private var rowScale: CGFloat = 0.1
    
    var body: some View {
        NavigationView {
            List {
                Text("User Ratings and High Scores")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 20)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            listOpacity = 1.0
                        }
                    }
                    .opacity(listOpacity)
                
                ForEach(scores, id: \.self) { score in
                    HStack {
                        Text("\(score.username ?? "Unknown User")")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                        Text("Score: \(Int(score.score))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .scaleEffect(rowScale)
                    .onAppear {
                        withAnimation(.spring()) {
                            rowScale = 1.0
                        }
                    }
                    .onDisappear {
                        rowScale = 0.95
                    }
                }
            }
            .padding(.horizontal)
            .navigationBarTitle("Rating")
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
