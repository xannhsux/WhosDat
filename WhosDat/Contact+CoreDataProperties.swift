import Foundation
import CoreData

extension NetworkContact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NetworkContact> {
        return NSFetchRequest<NetworkContact>(entityName: "NetworkContact")
    }

    @NSManaged public var name: String?
    @NSManaged public var company: String?
    @NSManaged public var role: String?
    @NSManaged public var education: String?
    @NSManaged public var connection: String?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?
    @NSManaged public var linkedin: String?
    @NSManaged public var instagram: String?
    @NSManaged public var twitter: String?
    @NSManaged public var notes: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var lastContact: Date?

}

extension NetworkContact : Identifiable {

}
