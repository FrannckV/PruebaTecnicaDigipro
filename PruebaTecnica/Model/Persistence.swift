//
//  Persistence.swift
//  PruebaTecnica
//
//  Created by Frannck Villanueva on 22/02/22.
//

import CoreData

struct PersistenceController {
    // MARK: - PERSISTENT CONTROLLER
    static let shared = PersistenceController()
    
    // MARK: - PERSISTENT CONTAINER
    let container: NSPersistentContainer

    // MARK: - INITIALIZER
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PruebaTecnica")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    // MARK: - PREVIEW
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newItem = Persona(context: viewContext)
            newItem.nombre = "Nombre \(i)"
            newItem.apellido = "Apellido \(i)"
            newItem.email = "something\(i)@mail.com"
            newItem.telefono = "44-444-444-44"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
