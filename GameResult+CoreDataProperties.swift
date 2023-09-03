//
//  GameResult+CoreDataProperties.swift
//  NumberGuesser
//
//  Created by Boris Vedernikov on 03/09/2023.
//
//

import Foundation
import CoreData


extension GameResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameResult> {
        return NSFetchRequest<GameResult>(entityName: "GameResult")
    }

    @NSManaged public var name: String?
    @NSManaged public var score: Float

}

extension GameResult : Identifiable {

}
