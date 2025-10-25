import Foundation
import CoreData
import SwiftUI

class ContactManager: ObservableObject {
    @Published var contacts: [NetworkContact] = []
    @Published var searchText: String = ""
    @Published var selectedRole: String? = nil
    @Published var selectedConnection: String? = nil
    
    private let persistenceController = PersistenceController.shared
    private var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    init() {
        fetchContacts()
    }
    
    func fetchContacts() {
        let request: NSFetchRequest<NetworkContact> = NetworkContact.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \NetworkContact.name, ascending: true)]
        
        do {
            contacts = try viewContext.fetch(request)
        } catch {
            print("Error fetching contacts: \(error)")
        }
    }
    
    var filteredContacts: [NetworkContact] {
        var filtered = contacts
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { contact in
                let name = contact.name?.lowercased() ?? ""
                let company = contact.company?.lowercased() ?? ""
                let role = contact.role?.lowercased() ?? ""
                let education = contact.education?.lowercased() ?? ""
                let connection = contact.connection?.lowercased() ?? ""
                
                return name.contains(searchText.lowercased()) ||
                       company.contains(searchText.lowercased()) ||
                       role.contains(searchText.lowercased()) ||
                       education.contains(searchText.lowercased()) ||
                       connection.contains(searchText.lowercased())
            }
        }
        
        // Filter by role
        if let selectedRole = selectedRole {
            filtered = filtered.filter { $0.role == selectedRole }
        }
        
        // Filter by connection
        if let selectedConnection = selectedConnection {
            filtered = filtered.filter { $0.connection == selectedConnection }
        }
        
        return filtered
    }
    
    var uniqueRoles: [String] {
        let roles = contacts.compactMap { $0.role }.filter { !$0.isEmpty }
        return Array(Set(roles)).sorted()
    }
    
    var uniqueConnections: [String] {
        let connections = contacts.compactMap { $0.connection }.filter { !$0.isEmpty }
        return Array(Set(connections)).sorted()
    }
    
    func addContact(name: String, company: String?, role: String?, education: String?, connection: String?, phone: String?, email: String?, linkedin: String?, instagram: String?, twitter: String?, notes: String?) {
        let newContact = NetworkContact(context: viewContext)
        newContact.name = name
        newContact.company = company
        newContact.role = role
        newContact.education = education
        newContact.connection = connection
        newContact.phone = phone
        newContact.email = email
        newContact.linkedin = linkedin
        newContact.instagram = instagram
        newContact.twitter = twitter
        newContact.notes = notes
        newContact.dateAdded = Date()
        
        saveContext()
    }
    
    func updateContact(_ contact: NetworkContact, name: String, company: String?, role: String?, education: String?, connection: String?, phone: String?, email: String?, linkedin: String?, instagram: String?, twitter: String?, notes: String?) {
        contact.name = name
        contact.company = company
        contact.role = role
        contact.education = education
        contact.connection = connection
        contact.phone = phone
        contact.email = email
        contact.linkedin = linkedin
        contact.instagram = instagram
        contact.twitter = twitter
        contact.notes = notes
        
        saveContext()
    }
    
    func deleteContact(_ contact: NetworkContact) {
        viewContext.delete(contact)
        saveContext()
    }
    
    func updateLastContact(_ contact: NetworkContact) {
        contact.lastContact = Date()
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            fetchContacts()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
