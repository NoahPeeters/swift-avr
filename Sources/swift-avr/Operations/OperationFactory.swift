//
//  OperationFactory.swift
//  swift-avr
//
//  Created by Til Blechschmidt on 16.08.18.
//

import Foundation

public protocol SingleBitWidthOperationFactoryProtocol {
    associatedtype BitWidth: FixedWidthInteger

    func register(operation: OpCodeType<BitWidth>)
    func matchingOpCodeType(forOperation operation: BitWidth) -> OpCodeType<BitWidth>?
}

public class SingleBitWidthOperationFactory<BitWidth: FixedWidthInteger>: SingleBitWidthOperationFactoryProtocol {
    private var opCodes: [OpCodeType<BitWidth>] = []

    public init() {}

    public func register(operation: OpCodeType<BitWidth>) {
        opCodes.append(operation)
    }

    public func matchingOpCodeType(forOperation operation: BitWidth) -> OpCodeType<BitWidth>? {
        return opCodes.first { $0.match(operation: operation) }
    }
}

public class OperationFactory {
    private let wordFactory: SingleBitWidthOperationFactory<Word>
    private let doubleWordFactory: SingleBitWidthOperationFactory<DoubleWord>

    public init(wordFactory: SingleBitWidthOperationFactory<Word>,
                doubleWordFactory: SingleBitWidthOperationFactory<DoubleWord>) {
        self.wordFactory = wordFactory
        self.doubleWordFactory = doubleWordFactory
    }

    public convenience init() {
        self.init(wordFactory: SingleBitWidthOperationFactory<Word>(),
                  doubleWordFactory: SingleBitWidthOperationFactory<DoubleWord>())
    }

    public func register(wordOperation: OpCodeType<Word>) {
        wordFactory.register(operation: wordOperation)
    }

    public func register(doubleWordOperation: OpCodeType<DoubleWord>) {
        doubleWordFactory.register(operation: doubleWordOperation)
    }

    public func scheduleExecution(inMemory memory: ProgramMemory, atLocation address: Int)
        -> (operationLength: Int, executeOperation: (VirtualCPU) -> Void, assemblyFetcher: () -> AssemblyInstruction)? {

            let wordOpCode = memory.read(wordAt: address)
            if let wordOperation = wordFactory.matchingOpCodeType(forOperation: wordOpCode) {
                let executor = { cpu in
                    wordOperation.execute(onCPU: cpu, operation: wordOpCode)
                }

                let assemblyFetcher = { wordOperation.generateAssembly(fromOperation: wordOpCode) }

                return (2, executor, assemblyFetcher)
            }

            let doubleWordOpCode = memory.read(doubleWordAt: address)
            if let doubleWordOperation = doubleWordFactory.matchingOpCodeType(forOperation: doubleWordOpCode) {
                let executor = { cpu in
                    doubleWordOperation.execute(onCPU: cpu, operation: doubleWordOpCode)
                }

                let assemblyFetcher = { doubleWordOperation.generateAssembly(fromOperation: doubleWordOpCode) }

                return (4, executor, assemblyFetcher)
            }

            return nil
    }
}
