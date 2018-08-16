private class PrintDelegate: VirtualCPUDelegate {
    fileprivate func virtualCPU(didExecuteInstruction instruction: AssemblyInstruction, atAddress address: Int) {
        print("\(address.hex()):\t\(instruction.description)")
    }
}

private let operationFactory = OperationFactory()
private let printDelegate = PrintDelegate()

private let memory = ProgramMemory(memoryContent: [0b0000_0001, 0b0000_1100,
                                                   0b0000_1100, 0b1001_0100, 0b0000_0000, 0b0000_0000])
private let cpu = VirtualCPU(memory: memory, operationFactory: operationFactory)

operationFactory.register(wordOperation: ADD())
operationFactory.register(wordOperation: RJMP())
operationFactory.register(doubleWordOperation: JMP())

cpu.delegate = printDelegate
cpu.write(registerIndex: 0, value: 0b0000_0000)
cpu.write(registerIndex: 1, value: 0b0000_0001)

for _ in 0..<10 {
    _ = cpu.cycle()

//    print(cpu.read(registerIndex: 0))
//    print(cpu.read(statusRegister: .carryFlag))
    print()
}
