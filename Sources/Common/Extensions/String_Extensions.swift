//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-13.
//

import Foundation

public extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    var fileExtension: String? {
        guard let fileExtensionComponent = split(separator: ".").last else {
            return nil
        }
        return String(fileExtensionComponent)
    }
    
}
