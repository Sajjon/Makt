//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation

struct Stepper {
    
    private var count = 0
    
    private var startOfLast: CFAbsoluteTime?
    private var inProgresStep: String?
    private let startOfAll: CFAbsoluteTime
    
    let totalStepCount: Int
    
    init(totalStepCount: Int) {
        self.totalStepCount = totalStepCount
        self.startOfAll = CFAbsoluteTimeGetCurrent()
    }

}

extension Stepper {
    
    mutating func step(_ stepName: String) {
        assert(inProgresStep == nil)
     
        print(startNewStep(stepName), terminator: "")
    }
    
    private mutating func startNewStep(_ stepName: String) -> String {
        finishedStepIfNeeded()
        startOfLast = CFAbsoluteTimeGetCurrent()
        count += 1
        return "[Step \(count)/\(totalStepCount)]: \(stepName)"
    }
    
    mutating func start(_ stepName: String, note: String? = nil) {
        let newStep = startNewStep(stepName)
        print("\(newStep)\(note.map { " \($0)" } ?? "")")
        inProgresStep = newStep
    }
    
    private mutating func elapsedString() -> String? {
        guard let startOfLast = startOfLast else { return nil }
        let diff = CFAbsoluteTimeGetCurrent() - startOfLast
        let elapsedString  = String(format: " - took %.2f seconds.", diff)
       return elapsedString
    }
    
    mutating func finishedStep() {
        defer {
            self.inProgresStep = nil
            self.startOfLast = nil
        }
        guard let inProgresStep = inProgresStep else { return }
        print("\(inProgresStep)\(elapsedString()!)")
    }
    
    private mutating func finishedStepIfNeeded() {
        if inProgresStep == nil {
            if let elapsed = elapsedString() {
                print(elapsed)
            }
        }
    }
    
    mutating func done(_ message: String) {
        finishedStepIfNeeded()
        let diff = CFAbsoluteTimeGetCurrent() - startOfAll
        print(String(format: "\n%@ - took %.2f seconds.", message, diff))
    }
}
