//
//  DataController.swift
//  NumberGuesser
//
//  Created by Boris Vedernikov on 03/09/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "Model")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load persistent store: \(error.localizedDescription)")
            }
        }
    }
    
    private func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Saved successfully!")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    func addResult(name: String, finalScore: Float, context: NSManagedObjectContext) {
        let result = GameResult(context: context)
        result.username = name
        result.score = finalScore
        save(context: context)
    }

    func fetchBestScore(for playerName: String) -> Int? {
        let request: NSFetchRequest<GameResult> = GameResult.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", playerName)
        request.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        request.fetchLimit = 1
        
        do {
            let results = try container.viewContext.fetch(request)
            return Int(results.first?.score ?? 0)
        } catch {
            print("Failed to fetch best score for \(playerName): \(error.localizedDescription)")
            return nil
        }
    }

    func deleteAllResults() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GameResult.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(batchDeleteRequest)
            print("Successfully deleted all results.")
        } catch {
            print("Failed to delete results: \(error.localizedDescription)")
        }
    }
}
