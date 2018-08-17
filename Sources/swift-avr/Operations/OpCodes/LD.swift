//
//  LD.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 17.08.18.
//

import Foundation

// MARK: LD-X

public class LDX1: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1001_0000_0000_1100,
                   opcBitmask: 0b1111_1110_0000_1111)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        // TODO Implement LD1
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "LD",
                                   parameters: [])
    }
}

public class LDX2: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1001_0000_0000_1101,
                   opcBitmask: 0b1111_1110_0000_1111)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        // TODO Implement LD2
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "LD",
                                   parameters: [])
    }
}

public class LDX3: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1001_0000_0000_1110,
                   opcBitmask: 0b1111_1110_0000_1111)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        // TODO Implement LD3
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "LD",
                                   parameters: [])
    }
}

// MARK: LD-Y

public class LDY1: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1000_0000_0000_1000,
                   opcBitmask: 0b1111_1110_0000_1111)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        // TODO Implement LD3
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "LD",
                                   parameters: [])
    }
}
