//
//  OR.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 17.08.18.
//

import Foundation

//swiftlint:disable:next type_name
public class OR: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b0010_1000_0000_0000,
                   opcBitmask: 0b1111_1100_0000_0000)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let (destination, source) = getDefaultParameterAddresses(fromOperation: operation)

        let result = destination | source

        cpu.write(statusRegister: .twosComplementOverflowIndicator, value: false)
        cpu.write(statusRegister: .negativeFlag, value: (result >> 8) != 0)
        cpu.write(statusRegister: .zeroFlag, value: result == 0)
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "OR",
                                   parameters: getDefaultAssemblyParameters(fromOperation: operation))
    }
}
