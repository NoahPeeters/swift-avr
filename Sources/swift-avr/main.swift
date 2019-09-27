import Foundation

private class PrintDelegate: VirtualCPUDelegate {
    fileprivate func virtualCPU(didExecuteInstruction instruction: AssemblyInstruction, atAddress address: Int) {
        print("\(address.hex()):\t\(instruction.description)")
    }
}

private let printDelegate = PrintDelegate()
private let operationFactory = OperationFactory()

guard CommandLine.arguments.count >= 2 else {
    print("Please specify path to executable avr program")
    exit(0)
}

private let url = URL(fileURLWithPath: CommandLine.arguments[1])
private let memory = try ProgramMemory(contentOfHexFileAt: url)
private let cpu = VirtualCPU(memory: memory, operationFactory: operationFactory)

cpu.delegate = printDelegate
operationFactory.registerDefaultOperations()

for _ in 0..<100 {
    _ = cpu.cycle()
}
