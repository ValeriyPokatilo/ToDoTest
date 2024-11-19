//
//  Ext+Date.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation

extension Optional where Wrapped == Date {
    var toString: String {
        guard let self else {
            return .empty
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}
