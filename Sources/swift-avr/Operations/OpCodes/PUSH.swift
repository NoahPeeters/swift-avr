//
//  PUSH.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class PUSH: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b1001_0010_0000_1111,
                   opcBitmask: 0b1111_1110_0000_1111)
    }

    private func getParameter(forOperation operation: Word) -> Int {
        return Int(operation.getValue(withBitmask: 0b0000_0001_1111_0000))
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let register = getParameter(forOperation: operation)
        cpu.pushOntoStack(cpu.read(registerIndex: register))
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let parameter = getParameter(forOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(), name: "PUSH", parameters: ["r\(parameter)"])
    }
}
