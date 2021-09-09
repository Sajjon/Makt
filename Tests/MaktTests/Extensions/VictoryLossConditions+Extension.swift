//
//  VictoryLossConditions+Extension.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-08.
//

import Makt

extension Map.LossCondition.Kind {
    static func timeLimitMonths(_ monthCount: Int) -> Self { Self.timeLimit(dayCount: 7*4*monthCount) }
    static let timeLimit6Months: Self = .timeLimitMonths(6)
}
