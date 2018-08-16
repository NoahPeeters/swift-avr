private let memory = ProgramMemory(memoryContent: [0, 0, 0])
private let cpu = VirtualCPU(memory: memory)
private let opCodeFactory = SingleBitWidthOperationFactory<UInt16>()

opCodeFactory.register(operation: ADD)

cpu.write(registerIndex: 0, value: 0b0000_0001)
cpu.write(registerIndex: 1, value: 0b1111_1111)

_ = opCodeFactory.execute(onCPU: cpu, operation: 0b0000_1100_0000_0001)

print(cpu.read(registerIndex: 0))
print(cpu.read(statusRegister: .carryFlag))
