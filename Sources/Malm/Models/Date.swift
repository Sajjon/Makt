//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-13.
//

import Foundation

public struct Date: Hashable, ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = UInt
    public init(integerLiteral daysPassed: IntegerLiteralType) {
        self.init(daysPassed: daysPassed)
    }
    public let daysPassed: IntegerLiteralType
    public init(daysPassed: IntegerLiteralType) {
        self.daysPassed = daysPassed
    }
}

public extension Date {
    static func of(month: IntegerLiteralType, week: IntegerLiteralType, day: IntegerLiteralType) -> Self {
        precondition(month > 0)
        precondition(week > 0)
        precondition(day > 0)
        precondition(day <= Self.daysPerWeek)
        precondition(week <= Self.weeksPerMonth)
        return Self(daysPassed: (month - 1) * Self.daysPerMonth + (week - 1) * Self.daysPerWeek + (day - 1))
    }
}


public extension Date {
    static let daysPerWeek: IntegerLiteralType = 7
    static let weeksPerMonth: IntegerLiteralType = 4
    static let daysPerMonth: IntegerLiteralType = Self.daysPerWeek * Self.weeksPerMonth
    
    var weeksPassed: IntegerLiteralType {
        daysPassed.quotientAndRemainder(dividingBy: Self.daysPerWeek).quotient
    }
    
    var monthsPassed: IntegerLiteralType {
        daysPassed.quotientAndRemainder(dividingBy: Self.daysPerMonth).remainder
    }
    
    var currentDayInWeek: IntegerLiteralType {
        daysPassed.quotientAndRemainder(dividingBy: Self.daysPerWeek).remainder
    }
    
    var currentWeekInMonth: IntegerLiteralType {
        let daysToNextMonth = daysPassed - monthsPassed * Self.daysPerMonth
        return daysToNextMonth.quotientAndRemainder(dividingBy: Self.daysPerWeek).remainder
    }
}
