//
//  ViewConfiguration.swift
//  ProjectFive
//
//  Created by Mateus Amorim on 12/09/22.
//

import Foundation
protocol ViewConfiguration {
    func setupConfiguration()
    func viewHierarchy()
    func setupContrants()
}

extension ViewConfiguration {
    func setupConfiguration () {
        viewHierarchy()
        setupContrants()
    }
}
