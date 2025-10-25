import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data for previews
        let sampleContact1 = NetworkContact(context: viewContext)
        sampleContact1.name = "John Smith"
        sampleContact1.company = "TechCorp"
        sampleContact1.role = "Founder"
        sampleContact1.education = "Stanford University"
        sampleContact1.connection = "LinkedIn"
        sampleContact1.email = "john@techcorp.com"
        sampleContact1.linkedin = "linkedin.com/in/johnsmith"
        sampleContact1.dateAdded = Date()
        
        let sampleContact2 = NetworkContact(context: viewContext)
        sampleContact2.name = "Sarah Johnson"
        sampleContact2.company = "VC Partners"
        sampleContact2.role = "VC"
        sampleContact2.education = "Harvard Business School"
        sampleContact2.connection = "Networking Event"
        sampleContact2.phone = "+1-555-0123"
        sampleContact2.email = "sarah@vcpartners.com"
        sampleContact2.dateAdded = Date()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WhosDatModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
