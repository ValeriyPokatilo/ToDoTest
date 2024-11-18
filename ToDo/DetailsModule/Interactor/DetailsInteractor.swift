//
//  DetailsInteractor.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation

protocol DetailsInteractorProtocol: AnyObject {
    var presenter: DetailsPresenterProtocol? { get set }
    var task: Task? { get set }
}

final class DetailsInteractor: DetailsInteractorProtocol {
    
    var task: Task?
    
    weak var presenter: DetailsPresenterProtocol?
}
