//
//  DatabaseManager.swift
//  Nirmal_PracticalTest
//
//  Created by cdp on 24/07/21.
//

import Foundation
import CoreData

class DatabaseManager {

    private init() {}

    //Returns the current Persistent Container for CoreData
    class func getContext () -> NSManagedObjectContext {
        return DatabaseManager.persistentContainer.viewContext
    }


    static var persistentContainer: NSPersistentContainer = {
        //The container that holds both data model entities
        let container = NSPersistentContainer(name: "Nirmal_PracticalTest")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    class func saveContext() {
        let context = self.getContext()
        if context.hasChanges {
            do {
                try context.save()
                print("Data Saved to Context")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                //You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    class func getAllNews() -> Array<NewsModel> {
        let all = NSFetchRequest<NewsModel>(entityName: "NewsModel")
        var allShows = [NewsModel]()

        do {
            let fetched = try DatabaseManager.getContext().fetch(all)
            allShows = fetched
        } catch {
            let nserror = error as NSError
            print(nserror.description)
        }

        return allShows
    }

    // Get Show by uuid
    class func getShowWith(uuid: String) -> NewsModel? {
        let requested = NSFetchRequest<NewsModel>(entityName: "NewsModel")
        requested.predicate = NSPredicate(format: "uuid == %@", uuid)

        do {
            let fetched = try DatabaseManager.getContext().fetch(requested)

            //fetched is an array we need to convert it to a single object
            if (fetched.count > 1) {
                //TODO: handle duplicate records
            } else {
                return fetched.first //only use the first object..
            }
        } catch {
            let nserror = error as NSError
            //TODO: Handle error
            print(nserror.description)
        }

        return nil
    }
    
    class func deleteAllNews() {
        do {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsModel")
            let deleteALL = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            try DatabaseManager.getContext().execute(deleteALL)
            DatabaseManager.saveContext()
        } catch {
            print ("There is an error in deleting records")
        }
    }
}

