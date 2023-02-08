//
//  MovieLocalData.swift
//  TestMovie
//
//  Created by Tung Phan on 03/02/2023.
//

import CoreData
import UIKit

class MovieLocalData: NSObject {
    static let shared = MovieLocalData()
    
    private var context: NSManagedObjectContext!
    
    override init() {
        super.init()
    }
    
    init(context: NSManagedObjectContext) {
        super.init()
        self.context = context
        fetchAllData().forEach {
            GlobalVariables.shared.favoriteMovies["\($0.id)"] = $0.isFavorite
        }
    }
    
    func saveOrUpdate(movie: MovieData, isFavorite: Bool = false, success: () -> Void, failure: (_ error: Error) -> Void) {
        let fetchMovie: NSFetchRequest<MovieLocal> = MovieLocal.fetchRequest()
        fetchMovie.predicate = NSPredicate(format: "id == %@", "\(movie.getId())")
        guard let result = try? context.fetch(fetchMovie) else { return }
        let movieLocal: MovieLocal!
        if result.count == 0 {
            movieLocal = MovieLocal(context: context)
            movieLocal.isFavorite = false
        } else {
            movieLocal = result[0]
            
        }
        
        movieLocal.id = movie.getId()
        movieLocal.backdropPath = movie.getBackdropPath()
        movieLocal.overview = movie.getOverview()
        movieLocal.posterPath = movie.getPosterPath()
        movieLocal.releaseDate = movie.getReleaseDate()
        movieLocal.title = movie.getTitle()
        movieLocal.voteCount = Int16(movie.getVoteCount()) ?? 1
        movieLocal.voteAverage = Double(movie.getVoteAverage()) ?? 0.0
        movieLocal.genresId = ""
        movieLocal.isFavorite = isFavorite
        do {
            try context.save()
            success()
        } catch let error {
            failure(error)
        }
    }
    
    func fetchAllData() -> [MovieLocal] {
        let fetchMovie: NSFetchRequest<MovieLocal> = MovieLocal.fetchRequest()
        guard let result: [MovieLocal] = try? context.fetch(fetchMovie) else {
            return []
        }
        return result
    }
    
    func getMovieLocal(id: String) -> MovieLocal? {
        let fetchMovie: NSFetchRequest<MovieLocal> = MovieLocal.fetchRequest()
        fetchMovie.predicate = NSPredicate(format: "id == %@", "\(id)")
        guard let result = try? context.fetch(fetchMovie).first else { return nil }
        return result
    }
    
    func updateFavoriteMovie(id: String, isFavorite: Bool) {
        let fetchMovie: NSFetchRequest<MovieLocal> = MovieLocal.fetchRequest()
        fetchMovie.predicate = NSPredicate(format: "id == %@", "\(id)")
        guard let result = try? context.fetch(fetchMovie).first else { return }
        result.isFavorite = isFavorite
    }
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
            let moduleName = "TestMovie"
            do {
                let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                let modelURL = Bundle.main.url(forResource: moduleName, withExtension:"momd")
                let newObjectModel = NSManagedObjectModel.init(contentsOf: modelURL!)
                let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel : newObjectModel!)
                try  persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)

                managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
                return managedObjectContext
            } catch let error as NSError {
            }
            return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        } 
}

