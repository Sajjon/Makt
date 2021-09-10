//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public func UNUSED(_: Any) { /* noop */ }

public func incorrectImplementation(
    reason: String,
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    fatalError("Incorrect implementation, \(reason), in file: \(file), line: \(line)")
}


public func incorrectImplementation(
    shouldAlwaysBeAbleTo actionExpectedToAlwaysBeAbleToPerform: String,
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    incorrectImplementation(reason: "should always be able to \(actionExpectedToAlwaysBeAbleToPerform)", file: file, line: line)
}


public func incorrectImplementation(
    shouldAlreadyHave actionThatShouldHaveBeenPerformed: String,
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    incorrectImplementation(reason: "should already have \(actionThatShouldHaveBeenPerformed)", file: file, line: line)
}


