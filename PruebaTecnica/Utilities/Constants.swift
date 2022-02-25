//
//  Constants.swift
//  PruebaTecnica
//
//  Created by Frannck Villanueva on 22/02/22.
//

import SwiftUI

// MARK: - MEDIA
let icono = "icono"

// MARK: - COLOR
let baseColor: Color = Color("BaseColor")
let themeColor: Color = Color("ThemeColor")
let acentColor: Color = Color("AccentColor")
let grayColor: Color = Color("GrayColor")

// MARK: - UX
let feedback = UINotificationFeedbackGenerator()

// MARK: - VALIDATORS
let nameOrLastnameRegex = "[A-Za-z ñÑáéíóúÁÉÍÓÚ]{2,64}"
let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
let phoneRegex = "^[0-9]{6,14}$"

func validateField(_ input:String, withRegex: String) -> Bool {
    let inputPred = NSPredicate(format:"SELF MATCHES %@", withRegex)
    return inputPred.evaluate(with: input)
}

func validateGeneral(nombre: String, apellido: String, email: String, telefono: String) -> String {
    var messsageReturn = "SUCCESS"
    
    if !validateField(nombre, withRegex: nameOrLastnameRegex) {
        messsageReturn = "Ingresa un nombre válido."
        return messsageReturn
    } else if !validateField(apellido, withRegex: nameOrLastnameRegex) {
        messsageReturn = "Ingresa un apellido válido."
        return messsageReturn
    } else if !validateField(email, withRegex: emailRegex) {
        messsageReturn = "Ingresa un email válido."
        return messsageReturn
    } else if !validateField(telefono, withRegex: phoneRegex) {
        messsageReturn = "Ingresa un número de teléfono válido."
        return messsageReturn
    }
    return messsageReturn
}

