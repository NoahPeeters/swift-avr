//
//  OperationCode.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public struct OpCodeType<BitWidth: BinaryInteger> {
    public typealias ExecutionClosure = (VirtualCPU, BitWidth) -> Void

    private let identifier: BitWidth
    private let identifierBitmask: BitWidth
    private let execute: ExecutionClosure

    public init(identifier: BitWidth, opcBitmask: BitWidth, execute: @escaping ExecutionClosure) {
        self.identifier = identifier
        self.identifierBitmask = opcBitmask
        self.execute = execute
    }

    public func match(operation: BitWidth) -> Bool {
        return (operation & identifierBitmask) == identifier
    }

    public func execute(onCPU cpu: VirtualCPU, operation: BitWidth) {
        self.execute(cpu, operation)
    }
}
