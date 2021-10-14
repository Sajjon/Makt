/// Copyright (c) 2017 Fickle Bits, LLC.
///
/// Use of the code provided on this repository is subject to the MIT License.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without
/// limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following
/// conditions:
///
/// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT
/// SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
/// OTHER DEALINGS IN THE SOFTWARE.

// From: https://github.com/nsscreencast/469-swift-command-line-progress-bar

//  OutputBuffer.swift
//  SwiftProgressBar
//
//  Created by Ben Scheirman on 12/4/20.
//
import Foundation

public protocol OutputBuffer {
    mutating func write(_ text: String)
    mutating func clearLine(width: Int, final: Bool)
}

extension FileHandle: OutputBuffer {
    public func write(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        write(data)
    }
    
    public func clearLine(width: Int, final: Bool = false) {
        write("\r")
        if final {
            write(String(repeating: " ", count: width * 2))
            write("\r")
        }
    }
}

public struct ProgressBar {
    
    public let width: Int
    private var output: OutputBuffer
    private let clearOnCompletion: Bool
    
    public init(
        output: OutputBuffer = FileHandle.standardOutput,
        clearOnCompletion: Bool = true,
        width: Int = 80
    ) {
        self.output = output
        self.width = width
        self.clearOnCompletion = clearOnCompletion
        
        self.output.write("")
    }
    
    private mutating func clearLine(final: Bool = false) {
        output.clearLine(width: width, final: final)
    }
    
    public mutating func render(count: Int, total: Int) {
        let progress = Float(count) / Float(total)
        let numberOfBars = Int(floor(progress * Float(width)))
        let numberOfTicks = width - numberOfBars
        let bars = "🁢" * numberOfBars
        let ticks = "-" * numberOfTicks
        
        let percentage = Int(floor(progress * 100))
        clearLine(final: false)
        output.write("[\(bars)\(ticks)] \(percentage)%")
        
        if count == total, clearOnCompletion {
            clearLine(final: true)
        }
    }
}

extension String {
    static func *(char: String, count: Int) -> String {
        var s = ""
        for _ in 0..<count {
            s.append(char)
        }
        return s
    }
}
