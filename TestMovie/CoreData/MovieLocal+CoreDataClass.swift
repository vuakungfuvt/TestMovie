//
//  MovieLocal+CoreDataClass.swift
//  
//
//  Created by Tung Phan on 03/02/2023.
//
//

import Foundation
import CoreData

//@objc(MovieLocal)
public class MovieLocal: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "MovieLocal", in: context)!
        self.init(entity: entity, insertInto: context)
    }

}
