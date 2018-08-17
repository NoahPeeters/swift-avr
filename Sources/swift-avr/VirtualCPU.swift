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

public enum CombinedRegisters: Int {
    case X = 26
    case Y = 28
    case Z = 30
}

public protocol VirtualCPUDelegate: class {
    func virtualCPU(didExecuteInstruction: AssemblyInstruction, atAddress: Int)
}

public class VirtualCPU {
    public weak var delegate: VirtualCPUDelegate?

    public var programCounter = 0
    public let memory: ProgramMemory
    private let operationFactory: OperationFactory

    public init(memory: ProgramMemory, operationFactory: OperationFactory) {
        self.memory = memory
        self.operationFactory = operationFactory
    }

    public func getNextOperation() -> ScheduledExecution? {
        return operationFactory.scheduleExecution(inMemory: memory, atLocation: programCounter * 2)
    }

    public func cycle() -> Bool {
        let operationAddress = programCounter * 2

        if let operation = getNextOperation() {
            programCounter += operation.operationLength
            operation.executionOperation(self)
            delegate?.virtualCPU(didExecuteInstruction: operation.assemblyFetcher(), atAddress: operationAddress)
            return true
        } else {
            let doubleWord = memory.read(doubleWordAt: operationAddress)
            print("\(operationAddress.hex()):\t\(doubleWord.paddedHex())\t\t\tINVALID OPCODE")
            return false
        }
    }

    // MARK: Registers
    private var registers = [Byte](repeating: 0, count: 32)

    public func write(registerIndex index: Int, value: Byte) {
        registers[index] = value
    }

    public func write(wordAtRegisterIndex index: Int, value: Byte) {
        write(registerIndex: index, value: Byte(value))
        write(registerIndex: index + 1, value: Byte(value >> 8))
    }

    public func read(registerIndex index: Int) -> Byte {
        return registers[index]
    }

    public func read(wordAtRegisterIndex index: Int) -> Word {
        let upper = Word(read(registerIndex: index))
        let lower = Word(read(registerIndex: index + 1))
        return (lower << 8) + upper
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

    // MARK: I/O Spaces
    private var ioSpaces = [Byte](repeating: 0, count: 64)

    public func write(ioLocation index: Int, value: Byte) {
        ioSpaces[index] = value
    }

    public func read(ioLocation index: Int) -> Byte {
        return ioSpaces[index]
    }

    // MARK: Stack
    private var stack: [Byte] = []

    public func pushOntoStack(_ value: Byte) {
        stack.append(value)
    }

    public func popFromStack() -> Byte {
        return stack.popLast()!
    }
}
