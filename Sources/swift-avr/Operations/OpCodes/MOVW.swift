//
//  MOVW.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class MOVW: OpCodeType<Word> {
    public init() {
        super.init(identifier: 0b0000_0001_0000_0000,
                   opcBitmask: 0b1111_1111_0000_0000)
    }

    public func getParameters(forOperation operation: Word) -> (destination: Int, source: Int) {
        return (destination: Int(operation.getValue(withBitmask: 0b0000_0000_1111_0000)) * 2,
                source:      Int(operation.getValue(withBitmask: 0b0000_0000_0000_1111)) * 2)
    }

    public override func execute(onCPU cpu: VirtualCPU, operation: Word) {
        let (destination, source) = getParameters(forOperation: operation)

        cpu.write(registerIndex: destination, value: cpu.read(registerIndex: source))
        cpu.write(registerIndex: destination + 1, value: cpu.read(registerIndex: source + 1))
    }

    public override func generateAssembly(fromOperation operation: Word) -> AssemblyInstruction {
        let (destination, source) = getParameters(forOperation: operation)
        return AssemblyInstruction(operationCode: operation.paddedHex(),
                                   name: "MOVW",
                                   parameters: [
                                    "r\(destination)",
                                    "r\(source)"])
    }
}
