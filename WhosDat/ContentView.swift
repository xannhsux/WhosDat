import SwiftUI

struct ContentView: View {
    @StateObject private var contactManager = ContactManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Contacts Tab
            ContactsTabView()
                .environmentObject(contactManager)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "person.2.fill" : "person.2")
                    Text("Contacts")
                }
                .tag(0)
            
            // Calendar Tab
            CalendarTabView()
                .environmentObject(contactManager)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "calendar" : "calendar")
                    Text("Calendar")
                }
                .tag(1)
        }
        .accentColor(.blue)
    }
}

struct ContactsTabView: View {
    @EnvironmentObject var contactManager: ContactManager
    @State private var showingAddContact = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Professional Background
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if contactManager.contacts.isEmpty {
                        // Professional Empty State
                        VStack(spacing: 30) {
                            Spacer()
                            
                            // Professional Icon
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: "person.2.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.blue)
                            }
                            
                            VStack(spacing: 12) {
                                Text("Build Your Professional Network")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("Connect with industry leaders,\ncolleagues, and business partners")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                            
                            Button(action: {
                                showingAddContact = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Your First Contact")
                                        .fontWeight(.semibold)
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .background(Color.blue)
                                .cornerRadius(25)
                                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 32)
                    } else {
                        // Contact list with professional header
                        VStack(spacing: 0) {
                            // Professional Header
                            VStack(spacing: 16) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("My Network")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                        
                                        Text("\(contactManager.contacts.count) professional connections")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        showingAddContact = true
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                                
                                ContactListView()
                            }
                        }
                    }
                }
                
                // Professional Floating Add Button
                if !contactManager.contacts.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                showingAddContact = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .shadow(color: Color.blue.opacity(0.4), radius: 8, x: 0, y: 4)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 100) // Account for tab bar
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddContact) {
                AddEditContactView()
                    .environmentObject(contactManager)
            }
        }
    }
}

struct CalendarTabView: View {
    @EnvironmentObject var contactManager: ContactManager
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Calendar View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Special dates and birthdays will appear here")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
