//
//  ContentView.swift
//  PruebaTecnica
//
//  Created by Frannck Villanueva on 22/02/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTIES
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Persona.id, ascending: true)],
        animation: .default)
    
    var personas: FetchedResults<Persona>
    
    @State private var showAddPersona: Bool = false
    @State private var animatingButton: Bool = false
    @State private var isAnimating: Bool = false
    @State private var zeroPersonas: Bool = false
    
    
    // MARK: - FUNCTIONS
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { personas[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - HEADER
                VStack {
                    HStack{
                        // TITLE
                        Text("Personas")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        Spacer()
                        
                        // EDIT BUTTON
                        
                        if personas.count > 0 {
                            EditButton()
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 10)
                                .frame(minWidth: 70, minHeight: 24)
                                .background(
                                    Capsule().stroke(acentColor, lineWidth: 2)
                                )
                        }
                        
                        // APPEAREANCE BUTTON
                        
                        Button(action: {
                            // TOGGLE APPEREANCE
                            isDarkMode.toggle()
                            feedback.notificationOccurred(.success)
                        }, label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        })

                    } //: HSTACK
                    .padding()
                    .foregroundColor(acentColor)
                    // MARK: - PERSONAS LIST
                    List {
                        ForEach(personas) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.nombre!)
                                        .font(.system(size: 24, design: .rounded))
                                        .fontWeight(.bold)
                                    Text(item.apellido!)
                                        .font(.footnote)
                                } //:VSTACK
                                
                                Spacer()
                                VStack(alignment: .trailing){
                                    Spacer()
                                    Text(item.email!)
                                        .font(.footnote)
                                        .foregroundColor(grayColor)
                                        .padding(3)
                                        .frame(minWidth: 62)
                                        .overlay(
                                            Capsule().stroke(grayColor, lineWidth: 0.75)
                                        )
                                    Text(item.telefono!)
                                        .font(.footnote)
                                        .foregroundColor(themeColor)
                                        .padding(3)
                                        .frame(minWidth: 62)
                                        .overlay(
                                            Capsule().stroke(themeColor, lineWidth: 0.75)
                                        )
                                } //: VSTACK
                            } //: HSTACK
                        }
                        .onDelete(perform: deleteItems)
                    } //: LIST
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                        ToolbarItem {
                            Button(action: {
                                showAddPersona = true
                                feedback.notificationOccurred(.success)
                            }) {
                                Label("Add Persona", systemImage: "plus")
                            }
                        }
                    } //: TOOLBAR, PERSONAS SECTION
                   
                } //: VSTACK
                .blur(radius: showAddPersona ? 8.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)

                // MARK: - BUTTON
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack() {
                            Group {
                                Circle()
                                    .fill(themeColor)
                                    .opacity( animatingButton ? 0.2 : 0)
                                    .scaleEffect(animatingButton ? 1 : 0.1)
                                    .frame(width: 68, height: 68, alignment: .center)
                                Circle()
                                    .fill(themeColor)
                                    .opacity( animatingButton ? 0.2 : 0)
                                    .scaleEffect(animatingButton ? 1 : 0.1)
                                    .frame(width: 88, height: 88, alignment: .center)
                                
                            } //: GROUP
                            .onAppear{
                                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                                    animatingButton.toggle()
                                }
                            }
                            Button(action: {
                                showAddPersona = true
                            }, label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .background(Circle().fill(baseColor))
                                    .frame(width: 48, height: 48, alignment: .center)
                                    .accentColor(themeColor)
                            }) //: BUTTON
                        } //: ZSTACK
                        .padding(.bottom, 15)
                        .padding(.trailing, 15)
                        .drawingGroup()
                        .frame(alignment: .bottomTrailing)
                        .blur(radius: showAddPersona ? 8.0 : 0, opaque: false)
                    }
                } //: BUTTON SECTION

                // MARK: - NO PERSONAS
                if personas.count == 0 {
                    withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        EmptyListView()
                            .zIndex(0)
                            .blur(radius: showAddPersona ? 8.0 : 0, opaque: false)
                    }
                }
                // MARK: - NEW PERSONA
                if showAddPersona {
                    BlankView(
                        backgroundColor: isDarkMode ? Color.black : Color.gray,
                        backgroundOpacity: isDarkMode ? 0.3 : 0.5
                    )
                    .onTapGesture {
                            withAnimation() {
                                showAddPersona = false
                            }
                    }
                    .zIndex(1)
                AddPersonaView(isShowing: $showAddPersona)
                        .zIndex(2)
                }
            } //: ZSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
                isAnimating = true
            }
            .navigationBarHidden(true)
            
        } //: NAVIGATION
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


// MARK: - ITEM FORMATTER
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
