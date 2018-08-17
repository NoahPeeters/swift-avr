//
//  SUBI.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class SUBI: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b0101_0000_0000_0000,
                   opcBitmask: 0b1111_0000_0000_0000)
    }

    private func getParameters(fromOperation operation: Word) -> (register: Int, constant: Byte) {
        return (register: Int(operation.getValue(withBitmask: 0b0000_0000_1111_0000)) + 16,
                constant: Byte(operation.getValue(withBitmask: 0b0000_1111_0000_1111)))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let (register, constant) = getParameters(fromOperation: operation)
        let registerValue = cpu.read(registerIndex: register)

        let (diff, carry) = registerValue.subtractingReportingOverflow(constant)
        let (_, halfCarry) = (registerValue << 4).subtractingReportingOverflow(constant << 4)
        let (_, overflowIndicator) = (registerValue << 1).subtractingReportingOverflow(constant << 1)

        cpu.write(statusRegister: .carryFlag, value: carry)
        cpu.write(statusRegister: .zeroFlag, value: diff == 0)
        cpu.write(statusRegister: .negativeFlag, value: (diff >> 7) == 1)
        cpu.write(statusRegister: .twosComplementOverflowIndicator, value: overflowIndicator)
        cpu.write(statusRegister: .halfCarryFlag, value: halfCarry)

        cpu.write(registerIndex: register, value: diff)
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let (register, constant) = getParameters(fromOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "SUBI",
                                   parameters: ["r\(register)", constant.hex()])
    }
}
