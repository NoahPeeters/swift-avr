//
//  LPM.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

private func readMemoryAddress(fromCPU cpu: VirtualCPU) -> Int {
    return Int(cpu.read(wordAtRegisterIndex: CombinedRegisters.Z.rawValue))
}

public class LPM1: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1001_0101_1100_1000,
                   opcBitmask: 0b1111_1111_1111_1111)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let memoryAddress = readMemoryAddress(fromCPU: cpu)
        cpu.write(registerIndex: 0, value: cpu.memory.read(byteAt: memoryAddress))
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(), name: "LPM", parameters: [])
    }
}

public class LPM2: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1001_0000_0000_0100,
                   opcBitmask: 0b1111_1110_0000_1111)
    }

    public func getDestination(fromOperation operation: Word) -> Int {
        return Int(operation.getValue(withBitmask: 0b0000_0001_1111_0000))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let memoryAddress = readMemoryAddress(fromCPU: cpu)
        let destination = getDestination(fromOperation: operation)

        cpu.write(registerIndex: destination, value: cpu.memory.read(byteAt: memoryAddress))
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let destination = getDestination(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "LPM",
                                   parameters: ["r\(destination)", "Z"])
    }
}

public class LPM3: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1001_0000_0000_0101,
                   opcBitmask: 0b1111_1110_0000_1111)
    }

    public func getDestination(fromOperation operation: Word) -> Int {
        return Int(operation.getValue(withBitmask: 0b0000_0001_1111_0000))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let memoryAddress = readMemoryAddress(fromCPU: cpu)
        let destination = getDestination(fromOperation: operation)

        cpu.write(registerIndex: destination, value: cpu.memory.read(byteAt: memoryAddress))

        // Increment the memory address
        let newMemoryAddress = memoryAddress + 1
        cpu.write(registerIndex: 30, value: Byte(newMemoryAddress))
        cpu.write(registerIndex: 31, value: Byte(newMemoryAddress >> 8))
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let destination = getDestination(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "LPM",
                                   parameters: ["r\(destination)", "Z+"])
    }
}
