//
//  OperationCode.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public class OpCodeType<BitWidth: FixedWidthInteger> {
    private let identifier: BitWidth
    private let identifierBitmask: BitWidth

    public init(identifier: BitWidth, opcBitmask: BitWidth) {
        self.identifier = identifier
        self.identifierBitmask = opcBitmask
    }

    public func match(operation: BitWidth) -> Bool {
        return (operation & identifierBitmask) == identifier
    }

    open func execute(onCPU cpu: VirtualCPU, operation: BitWidth) {
        // Dummy implementation
    }

    open func generateAssembly(fromOperation operation: BitWidth) -> AssemblyInstruction {
        return AssemblyInstruction(operationCode: operation.hex(), name: "", parameters: [])
    }
}
