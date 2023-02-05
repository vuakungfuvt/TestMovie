//
//  MovieLocal+CoreDataProperties.swift
//  
//
//  Created by Tung Phan on 03/02/2023.
//
//

import Foundation
import CoreData


extension MovieLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieLocal> {
        return NSFetchRequest<MovieLocal>(entityName: "MovieLocal")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var backdropPath: String?
    @NSManaged public var genresId: String?
    @NSManaged public var id: String
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int16

}
