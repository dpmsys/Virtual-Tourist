//
//  DataController.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/10/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init (modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load (completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores() { storeDescriptor, error in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
