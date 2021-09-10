//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public extension Map {
    
    /// Time based global events, trigger on certain days
    /// You should sort them by date of ocurence, they might not be sorted acording to that.
    typealias TimedEvents = CollectionOf<TimedEvent>
}
