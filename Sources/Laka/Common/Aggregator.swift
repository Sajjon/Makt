//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-07.
//

import Malm

final class Aggregator<Input: File> {
    
    typealias Aggregate = ([Input]) throws -> [File]
    
    private let _aggregate: Aggregate
    
    init(_ aggregate: @escaping Aggregate) {
        self._aggregate = aggregate
    }
    
    func aggregate(files: [Input]) throws -> [File] {
        try _aggregate(files)
    }
}
