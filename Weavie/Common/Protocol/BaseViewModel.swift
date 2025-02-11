//
//  BaseViewModel.swift
//  Weavie
//
//  Created by 정인선 on 2/10/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    func transform()
}
