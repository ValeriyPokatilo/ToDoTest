//
//  Ext+Date.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation

extension Date {
    func toString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}
