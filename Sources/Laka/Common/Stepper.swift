//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import Common

struct Stepper {
    
    private var count = 0
    
    private var startOfLast: CFAbsoluteTime?
    private var inProgresStep: String?
    private let startOfAll: CFAbsoluteTime
    
    let totalStepCount: Int
    private let logLevel: Logger.Level
    
    init(totalStepCount: Int, logLevel: Logger.Level) {
        self.totalStepCount = totalStepCount
        self.startOfAll = CFAbsoluteTimeGetCurrent()
        self.logLevel = logLevel
    }

}

extension Stepper {
    
    mutating func step(_ stepName: String) {
        assert(inProgresStep == nil)
     
        logger.debug(.init(stringLiteral: String(startNewStep(stepName))))
    }
    
    private mutating func startNewStep(_ stepName: String) -> String {
        finishedStepIfNeeded()
        startOfLast = CFAbsoluteTimeGetCurrent()
        count += 1
        return "[Step \(count)/\(totalStepCount)]: \(stepName)"
    }
    
    mutating func start(_ stepName: String, note: String? = nil) {
        let newStep = startNewStep(stepName)
        log("\(newStep)\(note.map { " \($0)" } ?? "")")
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
        log("\(inProgresStep)\(elapsedString()!)")
    }
    
    private mutating func finishedStepIfNeeded() {
        if inProgresStep == nil, let elapsed = elapsedString() {
            log(.init(stringLiteral: elapsed))
        }
    }
    
    mutating func done(_ message: String) {
        finishedStepIfNeeded()
//        let diff = CFAbsoluteTimeGetCurrent() - startOfAll
//        log(.init(stringLiteral: String(format: "\n%@ - took %.2f seconds.", message, diff)))
    }
}

private extension Stepper {
    
    /// Log a message passing the log level as a parameter.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates to. Currently, it defaults to the folder containing the
    ///              file that is emitting the log message, which usually is the module.
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    func log(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        source: @autoclosure () -> String? = nil,
        function: String = #function, line: UInt = #line) {
            logger.log(level: self.logLevel, message(), metadata: metadata(), source: source(), function: function, line: line)
        }
}
