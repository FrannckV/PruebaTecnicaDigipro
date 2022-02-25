//
//  AddPersonaView.swift
//  PruebaTecnica
//
//  Created by Frannck Villanueva on 22/02/22.
//

import SwiftUI

struct AddPersonaView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var nombre: String = ""
    @State private var apellido: String = ""
    @State private var email: String = ""
    @State private var telefono: String = ""
    @State var showAlert: Bool = false
    @State private var validationMessage: String = ""
    @Binding var isShowing: Bool
    
    private var isButtonDisabled: Bool {
        nombre.isEmpty ||
        apellido.isEmpty ||
        email.isEmpty ||
        telefono.isEmpty
    }
    
    // MARK: - FUNCTIONS
    private func addItem() {
        withAnimation {
            let newItem = Persona(context: viewContext)
            newItem.id = UUID()
            newItem.nombre = nombre
            newItem.apellido = apellido
            newItem.email = email
            newItem.telefono = telefono

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            nombre = ""
            apellido = ""
            email = ""
            telefono = ""
            isShowing = false
        }
    }

    // MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
            
            VStack() {
                TextField("Nombre", text: $nombre)
                    .foregroundColor(themeColor)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)
                
                TextField("Apellido", text: $apellido)
                    .foregroundColor(themeColor)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .foregroundColor(themeColor)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)
            
                TextField("Teléfono", text: $telefono)
                    .keyboardType(.numberPad)
                    .foregroundColor(themeColor)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)

                Button(action: {
                    validationMessage = validateGeneral(nombre: nombre, apellido: apellido, email: email, telefono: telefono)
                    if validationMessage == "SUCCESS" {
                        addItem()
                        feedback.notificationOccurred(.success)
                    } else {
                        showAlert = true
                    }
                }, label: {
                    Spacer()
                    Text("GUARDAR")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                })
                    .disabled(isButtonDisabled)
                    .onTapGesture{
                        if isButtonDisabled {
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(isButtonDisabled ? grayColor : themeColor)
                    .cornerRadius(10)
                
            } //: VSTACK
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white
            )
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
            .frame(maxWidth: 640)
        } //: VSTACK
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(validationMessage), dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - PREVIEW
struct AddPersonaView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonaView(isShowing: .constant(true))
            .background(.gray, ignoresSafeAreaEdges: .all)
    }
}


