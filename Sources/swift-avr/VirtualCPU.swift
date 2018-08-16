//
//  VirtualCPU.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public typealias Byte = UInt8
public typealias Word = UInt16
public typealias DoubleWord = UInt32

public enum StatusRegister: Int {
    case carryFlag = 0
    case zeroFlag = 1
    case negativeFlag = 2
    case twosComplementOverflowIndicator = 3
    case halfCarryFlag = 4
    case transferBit = 5
    case globalInterruptFlag = 6
    case xorSignedTest = 255
}

public class VirtualCPU {
    public var programCounter = 0
    private var programMemory: ProgramMemory

    public init(memory: ProgramMemory) {
        self.programMemory = memory
    }

    // MARK: Registers
    private var registers = [Byte](repeating: 0, count: 32)

    public func write(registerIndex index: Int, value: Byte) {
        registers[index] = value
    }

    public func read(registerIndex index: Int) -> Byte {
        return registers[index]
    }

    // MARK: Status registers
    private var statusRegisters = [Bool](repeating: false, count: 8)

    public func write(statusRegister flag: StatusRegister, value: Bool) {
        statusRegisters[flag.rawValue] = value
    }

    public func read(statusRegister flag: StatusRegister) -> Bool {
        if flag == .xorSignedTest {
            return read(statusRegister: .negativeFlag) != read(statusRegister: .twosComplementOverflowIndicator)
        } else {
            return statusRegisters[flag.rawValue]
        }
    }
}