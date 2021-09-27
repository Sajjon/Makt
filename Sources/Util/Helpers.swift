//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public func UNUSED(_: Any) { /* noop */ }

public func fantasticUseThisSolution(
    insteadOf: String,
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    fatalError("Fantastic! Use this solution, instead of \(insteadOf).", file: file, line: line)
}

public func incorrectImplementation(
    reason: String,
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    fatalError("Incorrect implementation, \(reason)", file: file, line: line)
}


public func incorrectImplementation(
    shouldAlwaysBeAbleTo actionExpectedToAlwaysBeAbleToPerform: String,
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    incorrectImplementation(reason: "should always be able to \(actionExpectedToAlwaysBeAbleToPerform)", file: file, line: line)
}


public func implementMe(
    comment maybeComment: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    let comment = maybeComment.map { " (\($0)" } ?? ""
    incorrectImplementation(reason: "Implement me please\(comment)", file: file, line: line)
}


public func incorrectImplementation(
    shouldAlreadyHave actionThatShouldHaveBeenPerformed: String,
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    incorrectImplementation(reason: "should already have \(actionThatShouldHaveBeenPerformed)", file: file, line: line)
}

public func uncaught<E: Swift.Error>(
    error: Swift.Error,
    expectedType: E.Type,
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    incorrectImplementation(reason: "Uncaught error: \(error), expected to only catch errors of type: \(E.self)", file: file, line: line)
}

public func uncaught(
    error: Swift.Error,
    expectedToNeverFailBecause reason: String = "reasons",
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    incorrectImplementation(reason: "Uncaught error: \(String(describing: error)), expected to never fail, because: \(reason)", file: file, line: line)
}

