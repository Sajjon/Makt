//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-20.
//

import Foundation

/// https://github.com/apple/swift-log
@_exported import Logging


public var logger = Logger.init(label: "Makt")

public func setLogLevel(_ logLevel: Logger.Level) {
    logger.logLevel = logLevel
}
