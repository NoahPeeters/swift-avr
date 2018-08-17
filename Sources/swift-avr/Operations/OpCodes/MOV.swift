//
//  MOV.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class MOV: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b0010_1100_0000_0000,
                   opcBitmask: 0b1111_1100_0000_0000)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let (destination, source) = getDefaultParameterAddresses(fromOperation: operation)

        cpu.write(registerIndex: destination, value: cpu.read(registerIndex: source))
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let parameters = getDefaultAssemblyParameters(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "MOV",
                                   parameters: parameters)
    }
}
