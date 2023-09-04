import Foundation
import SwiftUI

struct RatingView: View {
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.score, order: .reverse)]) private var scores: FetchedResults<GameResult>
    
    @State private var listOpacity: Double = 0.0
    @State private var rowScale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            List {
                header
                scoreRows
            }
            .padding(.horizontal)
            .navigationBarTitle("Rating")
        }
    }
    
    private var header: some View {
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
    }
    
    private var scoreRows: some View {
        ForEach(scores, id: \.self) { score in
            scoreRow(for: score)
        }
    }
    
    private func scoreRow(for score: GameResult) -> some View {
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
                rowScale = 1.05
            }
        }
        .onDisappear {
            rowScale = 1.0
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
