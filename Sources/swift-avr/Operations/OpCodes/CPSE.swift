//
//  CPSE.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 17.08.18.
//

import Foundation

public class CPSE: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b0001_0000_0000_0000,
                   opcBitmask: 0b1111_1100_0000_0000)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let (destination, source) = getDefaultParameterAddresses(fromOperation: operation)

        if cpu.read(registerIndex: source) == cpu.read(registerIndex: destination),
            let operation = cpu.getNextOperation() {
            cpu.programCounter += operation.operationLength
        }
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "CPSE",
                                   parameters: getDefaultAssemblyParameters(fromOperation: operation))
    }
}
