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
