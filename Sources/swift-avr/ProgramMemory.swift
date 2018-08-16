//
//  ProgramMemory.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class ProgramMemory {
    private let memory: [Byte]

    public init(memoryContent: [Byte]) {
        self.memory = memoryContent
    }

    public init(contentOfHexFileAt url: URL) throws {
        let data = try String(contentsOf: url)

        var memory = [Byte]()
        memory.reserveCapacity(data.count/4)

        let lines = data.components(separatedBy: .newlines)

        for line in lines {
            // Convert line and filter empty lines.
            guard let lineData = line.data(using: .ascii), lineData.count > 9 else {
                continue
            }

            // Extract content.
            let lineContent = lineData.advanced(by: 9).map {
                hexAsciiDigitToValue($0)
            }

            // Create bytes.
            for index in 0..<lineContent.count/2 {
                memory.append(lineContent[index * 2] << 4 + lineContent[index * 2 + 1])
            }
        }

        self.memory = memory
    }

    public func read(byteAt index: Int) -> Byte {
        return memory[index]
    }

    public func read(wordAt index: Int) -> Word {
        let upper = Word(read(byteAt: index))
        let lower = Word(read(byteAt: index + 1))

        return (upper << 8) + lower
    }

    public func read(doubleWordAt index: Int) -> DoubleWord {
        let upper = DoubleWord(read(wordAt: index))
        let lower = DoubleWord(read(wordAt: index + 2))

        return (upper << 16) + lower
    }
}

private func hexAsciiDigitToValue(_ hexDigit: Byte) -> Byte {
    if hexDigit > 60 {
        return hexDigit - 65 + 10
    } else {
        return hexDigit - 48
    }
}
