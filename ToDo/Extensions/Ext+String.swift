//
//  Ext+String.swift
//  ToDo
//
//  Created by Valeriy P on 20.11.2024.
//

import Foundation

extension Optional where Wrapped == String {
    var emptyIfNil: Wrapped {
        return self ?? .empty
    }
}
