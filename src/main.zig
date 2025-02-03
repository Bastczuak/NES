const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const AddressingMode = enum(u8) {
    Immediate,
    ZeroPage,
    ZeroPageX,
    ZeroPageY,
    Absolute,
    AbsoluteX,
    AbsoluteY,
    IndirectX,
    IndirectY,
    Implied,
};

const OpCode = struct {
    mnemonic: []const u8,
    bytes: u8,
    decodingFn: *const fn (cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void,
    addressingMode: AddressingMode,
};

const Instruction = struct {
    key: u8,
    value: OpCode,

    pub fn getOpCode(key: u8) OpCode {
        for (Instructions) |instruction| {
            if (key == instruction.key) {
                return instruction.value;
            }
        }

        std.debug.panic("No Instruction found for ops code: 0x{X}", .{key});
    }
};

const Instructions = [_]Instruction{
    Instruction{
        .key = 0x29,
        .value = OpCode{
            .mnemonic = "AND",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.AND,
        },
    },
    Instruction{
        .key = 0x25,
        .value = OpCode{
            .mnemonic = "AND",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.AND,
        },
    },
    Instruction{
        .key = 0x35,
        .value = OpCode{
            .mnemonic = "AND",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.AND,
        },
    },
    Instruction{
        .key = 0x2D,
        .value = OpCode{
            .mnemonic = "AND",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.AND,
        },
    },
    Instruction{
        .key = 0x3D,
        .value = OpCode{
            .mnemonic = "AND",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.AND,
        },
    },
    Instruction{
        .key = 0x39,
        .value = OpCode{
            .mnemonic = "AND",
            .addressingMode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.AND,
        },
    },
    Instruction{
        .key = 0x21,
        .value = OpCode{
            .mnemonic = "AND",
            .addressingMode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.AND,
        },
    },
    Instruction{
        .key = 0x31,
        .value = OpCode{
            .mnemonic = "AND",
            .addressingMode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.AND,
        },
    },
    //
    Instruction{
        .key = 0x00,
        .value = OpCode{
            .mnemonic = "BRK",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.BRK,
        },
    },
    //
    Instruction{
        .key = 0x18,
        .value = OpCode{
            .mnemonic = "CLC",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.CLC,
        },
    },
    //
    Instruction{
        .key = 0xD8,
        .value = OpCode{
            .mnemonic = "CLD",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.CLD,
        },
    },
    //
    Instruction{
        .key = 0x58,
        .value = OpCode{
            .mnemonic = "CLI",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.CLI,
        },
    },
    //
    Instruction{
        .key = 0xB8,
        .value = OpCode{
            .mnemonic = "CLV",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.CLV,
        },
    },
    //
    Instruction{
        .key = 0xC9,
        .value = OpCode{
            .mnemonic = "CMP",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.CMP,
        },
    },
    Instruction{
        .key = 0xC5,
        .value = OpCode{
            .mnemonic = "CMP",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.CMP,
        },
    },
    Instruction{
        .key = 0xD5,
        .value = OpCode{
            .mnemonic = "CMP",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.CMP,
        },
    },
    Instruction{
        .key = 0xCD,
        .value = OpCode{
            .mnemonic = "CMP",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.CMP,
        },
    },
    Instruction{
        .key = 0xDD,
        .value = OpCode{
            .mnemonic = "CMP",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.CMP,
        },
    },
    Instruction{
        .key = 0xD9,
        .value = OpCode{
            .mnemonic = "CMP",
            .addressingMode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.CMP,
        },
    },
    Instruction{
        .key = 0xC1,
        .value = OpCode{
            .mnemonic = "CMP",
            .addressingMode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.CMP,
        },
    },
    Instruction{
        .key = 0xD1,
        .value = OpCode{
            .mnemonic = "CMP",
            .addressingMode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.CMP,
        },
    },
    //
    Instruction{
        .key = 0xE0,
        .value = OpCode{
            .mnemonic = "CPX",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.CPX,
        },
    },
    Instruction{
        .key = 0xE4,
        .value = OpCode{
            .mnemonic = "CPX",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.CPX,
        },
    },
    Instruction{
        .key = 0xEC,
        .value = OpCode{
            .mnemonic = "CPX",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.CPX,
        },
    },
    //
    Instruction{
        .key = 0xC0,
        .value = OpCode{
            .mnemonic = "CPY",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.CPY,
        },
    },
    Instruction{
        .key = 0xC4,
        .value = OpCode{
            .mnemonic = "CPY",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.CPY,
        },
    },
    Instruction{
        .key = 0xCC,
        .value = OpCode{
            .mnemonic = "CPY",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.CPY,
        },
    },
    //
    Instruction{
        .key = 0xC6,
        .value = OpCode{
            .mnemonic = "DEC",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.DEC,
        },
    },
    Instruction{
        .key = 0xD6,
        .value = OpCode{
            .mnemonic = "DEC",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.DEC,
        },
    },
    Instruction{
        .key = 0xCE,
        .value = OpCode{
            .mnemonic = "DEC",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.DEC,
        },
    },
    Instruction{
        .key = 0xDE,
        .value = OpCode{
            .mnemonic = "DEC",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.DEC,
        },
    },
    //
    Instruction{
        .key = 0xCA,
        .value = OpCode{
            .mnemonic = "DEX",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.DEX,
        },
    },
    //
    Instruction{
        .key = 0x88,
        .value = OpCode{
            .mnemonic = "DEY",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.DEY,
        },
    },
    //
    Instruction{
        .key = 0x49,
        .value = OpCode{
            .mnemonic = "EOR",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.EOR,
        },
    },
    Instruction{
        .key = 0x45,
        .value = OpCode{
            .mnemonic = "EOR",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.EOR,
        },
    },
    Instruction{
        .key = 0x55,
        .value = OpCode{
            .mnemonic = "EOR",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.EOR,
        },
    },
    Instruction{
        .key = 0x4D,
        .value = OpCode{
            .mnemonic = "EOR",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.EOR,
        },
    },
    Instruction{
        .key = 0x5D,
        .value = OpCode{
            .mnemonic = "EOR",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.EOR,
        },
    },
    Instruction{
        .key = 0x59,
        .value = OpCode{
            .mnemonic = "EOR",
            .addressingMode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.EOR,
        },
    },
    Instruction{
        .key = 0x41,
        .value = OpCode{
            .mnemonic = "EOR",
            .addressingMode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.EOR,
        },
    },
    Instruction{
        .key = 0x51,
        .value = OpCode{
            .mnemonic = "EOR",
            .addressingMode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.EOR,
        },
    },
    //
    Instruction{
        .key = 0xE6,
        .value = OpCode{
            .mnemonic = "INC",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.INC,
        },
    },
    Instruction{
        .key = 0xF6,
        .value = OpCode{
            .mnemonic = "INC",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.INC,
        },
    },
    Instruction{
        .key = 0xEE,
        .value = OpCode{
            .mnemonic = "INC",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.INC,
        },
    },
    Instruction{
        .key = 0xFE,
        .value = OpCode{
            .mnemonic = "INC",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.INC,
        },
    },
    //
    Instruction{
        .key = 0xE8,
        .value = OpCode{
            .mnemonic = "INX",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.INX,
        },
    },
    //
    Instruction{
        .key = 0xC8,
        .value = OpCode{
            .mnemonic = "INY",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.INY,
        },
    },
    //
    Instruction{
        .key = 0xAA,
        .value = OpCode{
            .mnemonic = "TAX",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.TAX,
        },
    },
    //
    Instruction{
        .key = 0xA8,
        .value = OpCode{
            .mnemonic = "TAY",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.TAY,
        },
    },
    //
    Instruction{
        .key = 0xA9,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.LDA,
        },
    },
    Instruction{
        .key = 0xA5,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.LDA,
        },
    },
    Instruction{
        .key = 0xB5,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.LDA,
        },
    },
    Instruction{
        .key = 0xAD,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.LDA,
        },
    },
    Instruction{
        .key = 0xBD,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.LDA,
        },
    },
    Instruction{
        .key = 0xB9,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.LDA,
        },
    },
    Instruction{
        .key = 0xA1,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.LDA,
        },
    },
    Instruction{
        .key = 0xB1,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.LDA,
        },
    },
    //
    Instruction{
        .key = 0xA2,
        .value = OpCode{
            .mnemonic = "LDX",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.LDX,
        },
    },
    Instruction{
        .key = 0xA6,
        .value = OpCode{
            .mnemonic = "LDX",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.LDX,
        },
    },
    Instruction{
        .key = 0xB6,
        .value = OpCode{
            .mnemonic = "LDX",
            .addressingMode = AddressingMode.ZeroPageY,
            .bytes = 2,
            .decodingFn = Cpu.LDX,
        },
    },
    Instruction{
        .key = 0xAE,
        .value = OpCode{
            .mnemonic = "LDX",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.LDX,
        },
    },
    Instruction{
        .key = 0xBE,
        .value = OpCode{
            .mnemonic = "LDX",
            .addressingMode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.LDX,
        },
    },
    //
    Instruction{
        .key = 0xA0,
        .value = OpCode{
            .mnemonic = "LDY",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.LDY,
        },
    },
    Instruction{
        .key = 0xA4,
        .value = OpCode{
            .mnemonic = "LDY",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.LDY,
        },
    },
    Instruction{
        .key = 0xB4,
        .value = OpCode{
            .mnemonic = "LDY",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.LDY,
        },
    },
    Instruction{
        .key = 0xAC,
        .value = OpCode{
            .mnemonic = "LDY",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.LDY,
        },
    },
    Instruction{
        .key = 0xBC,
        .value = OpCode{
            .mnemonic = "LDY",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.LDY,
        },
    },
    //
    Instruction{
        .key = 0x85,
        .value = OpCode{
            .mnemonic = "STA",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.STA,
        },
    },
    Instruction{
        .key = 0x95,
        .value = OpCode{
            .mnemonic = "STA",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.STA,
        },
    },
    Instruction{
        .key = 0x8D,
        .value = OpCode{
            .mnemonic = "STA",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.STA,
        },
    },
    Instruction{
        .key = 0x9D,
        .value = OpCode{
            .mnemonic = "STA",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.STA,
        },
    },
    Instruction{
        .key = 0x99,
        .value = OpCode{
            .mnemonic = "STA",
            .addressingMode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.STA,
        },
    },
    Instruction{
        .key = 0x81,
        .value = OpCode{
            .mnemonic = "STA",
            .addressingMode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.STA,
        },
    },
    Instruction{
        .key = 0x91,
        .value = OpCode{
            .mnemonic = "STA",
            .addressingMode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.STA,
        },
    },
    //
    Instruction{
        .key = 0x86,
        .value = OpCode{
            .mnemonic = "STX",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.STX,
        },
    },
    Instruction{
        .key = 0x96,
        .value = OpCode{
            .mnemonic = "STX",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.STX,
        },
    },
    Instruction{
        .key = 0x8E,
        .value = OpCode{
            .mnemonic = "STX",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.STX,
        },
    },
    //
    Instruction{
        .key = 0x84,
        .value = OpCode{
            .mnemonic = "STY",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.STY,
        },
    },
    Instruction{
        .key = 0x94,
        .value = OpCode{
            .mnemonic = "STY",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.STY,
        },
    },
    Instruction{
        .key = 0x8C,
        .value = OpCode{
            .mnemonic = "STY",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.STY,
        },
    },
    //
};

const Memory = struct {
    memory: [0xFFFF]u8,

    const ROM_START = 0x8000;
    const ROM_END = 0xFFFF;
    const ROM_PROGRAM_START = 0xFFFC;

    pub fn init(program: []const u8) Memory {
        const program_end = ROM_START + program.len;

        if (program_end > ROM_END) {
            std.debug.panic("Program size exceeds available memory space!\n", .{});
        }

        var memory = Memory{ .memory = [_]u8{0} ** 0xFFFF };
        @memcpy(memory.memory[ROM_START..program_end], program);
        memory.writeU16(Memory.ROM_PROGRAM_START, Memory.ROM_START);

        return memory;
    }

    pub fn readU16(self: *Memory, pos: u16) u16 {
        var buf = [_]u8{ self.memory[pos], self.memory[pos + 1] };
        return std.mem.readInt(u16, &buf, .little);
    }

    pub fn writeU16(self: *Memory, pos: u16, data: u16) void {
        var buf: [2]u8 = undefined;
        std.mem.writeInt(u16, &buf, data, .little);
        self.memory[pos] = buf[0];
        self.memory[pos + 1] = buf[1];
    }
};

const Cpu = struct {
    const CARRY_FLAG: u8 = 0b0000_0001;
    const ZERO_FLAG: u8 = 0b0000_0010;
    const INTERRUPT_DISABLE: u8 = 0b0000_0100;
    const DECIMAL_MODE_FLAG: u8 = 0b0000_1000;
    const OVERFLOW_FLAG: u8 = 0b0100_0000;
    const NEGATIVE_FLAG: u8 = 0b1000_0000;

    stop: bool,
    programCounter: u16,
    status: u8,
    registerA: u8, // a.k.a acumulator
    registerX: u8,
    registerY: u8,

    pub fn init(mem: *Memory) Cpu {
        return Cpu{
            .stop = false,
            .programCounter = mem.readU16(Memory.ROM_PROGRAM_START),
            .status = 0b0011_0000,
            .registerA = 0,
            .registerX = 0,
            .registerY = 0,
        };
    }

    pub fn AND(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.nextAddress(mem, addressingMode);

        cpu.registerA &= mem.memory[address];
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerA == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, 7)) NEGATIVE_FLAG else 0;
    }

    pub fn BRK(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.stop = true;
    }

    pub fn CLC(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.status &= ~CARRY_FLAG;
    }

    pub fn CLD(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.status &= ~DECIMAL_MODE_FLAG;
    }

    pub fn CLI(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.status &= ~INTERRUPT_DISABLE;
    }

    pub fn CLV(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.status &= ~OVERFLOW_FLAG;
    }

    inline fn compare(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode, register: *u8) void {
        const address = cpu.nextAddress(mem, addressingMode);
        const toCompareWith = mem.memory[address];
        const result = register.* -% toCompareWith;

        cpu.status = cpu.status & ~ZERO_FLAG | if (result == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~CARRY_FLAG | if (register.* >= result) CARRY_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, result, 7)) NEGATIVE_FLAG else 0;
    }

    pub fn CMP(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        return compare(cpu, mem, addressingMode, &cpu.registerA);
    }

    pub fn CPX(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        return compare(cpu, mem, addressingMode, &cpu.registerX);
    }

    pub fn CPY(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        return compare(cpu, mem, addressingMode, &cpu.registerY);
    }

    inline fn decrement(value: *u8, status: *u8) void {
        value.* -%= 1;
        status.* = status.* & ~ZERO_FLAG | if (value.* == 0) ZERO_FLAG else 0;
        status.* = status.* & ~NEGATIVE_FLAG | if (isBitSet(u8, value.*, 7)) NEGATIVE_FLAG else 0;
    }

    pub fn DEC(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.nextAddress(mem, addressingMode);
        decrement(&mem.memory[address], &cpu.status);
    }

    pub fn DEX(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        decrement(&cpu.registerX, &cpu.status);
    }

    pub fn DEY(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        decrement(&cpu.registerY, &cpu.status);
    }

    pub fn EOR(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.nextAddress(mem, addressingMode);
        cpu.registerA ^= mem.memory[address];

        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerA == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, 7)) NEGATIVE_FLAG else 0;
    }

    inline fn increment(value: *u8, status: *u8) void {
        value.* +%= 1;
        status.* = status.* & ~ZERO_FLAG | if (value.* == 0) ZERO_FLAG else 0;
        status.* = status.* & ~NEGATIVE_FLAG | if (isBitSet(u8, value.*, 7)) NEGATIVE_FLAG else 0;
    }

    pub fn INC(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.nextAddress(mem, addressingMode);
        increment(&mem.memory[address], &cpu.status);
    }

    pub fn INX(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        increment(&cpu.registerX, &cpu.status);
    }

    pub fn INY(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        increment(&cpu.registerY, &cpu.status);
    }

    pub fn TAX(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.registerX = cpu.registerA;
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerX == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerX, 7)) NEGATIVE_FLAG else 0;
    }

    pub fn TAY(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.registerY = cpu.registerA;
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerY == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerY, 7)) NEGATIVE_FLAG else 0;
    }

    inline fn load(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode, register: *u8) void {
        const address = cpu.nextAddress(mem, addressingMode);
        register.* = mem.memory[address];
        cpu.status = cpu.status & ~ZERO_FLAG | if (register.* == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, register.*, 7)) NEGATIVE_FLAG else 0;
    }

    pub fn LDA(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        load(cpu, mem, addressingMode, &cpu.registerA);
    }

    pub fn LDX(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        load(cpu, mem, addressingMode, &cpu.registerX);
    }

    pub fn LDY(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        load(cpu, mem, addressingMode, &cpu.registerY);
    }

    inline fn store(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode, register: *u8) void {
        const address = cpu.nextAddress(mem, addressingMode);
        mem.memory[address] = register.*;
    }

    pub fn STA(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        store(cpu, mem, addressingMode, &cpu.registerA);
    }

    pub fn STX(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        store(cpu, mem, addressingMode, &cpu.registerX);
    }

    pub fn STY(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        store(cpu, mem, addressingMode, &cpu.registerY);
    }

    pub fn interpret(self: *Cpu, mem: *Memory) void {
        while (!self.stop) {
            const opCode = Instruction.getOpCode(mem.memory[self.programCounter]);
            self.programCounter += 1;
            const programCounterState = self.programCounter;

            opCode.decodingFn(self, mem, opCode.addressingMode);
            if (programCounterState == self.programCounter) {
                self.programCounter += opCode.bytes - 1;
            }
        }
    }

    pub fn nextAddress(self: *Cpu, mem: *Memory, addressingMode: AddressingMode) u16 {
        var address: u16 = undefined;
        switch (addressingMode) {
            AddressingMode.Immediate => address = self.programCounter,
            AddressingMode.ZeroPage => address = mem.memory[self.programCounter],
            AddressingMode.ZeroPageX => {
                const pos = mem.memory[self.programCounter];
                address = pos +% self.registerX;
            },
            AddressingMode.ZeroPageY => {
                const pos = mem.memory[self.programCounter];
                address = pos +% self.registerY;
            },
            AddressingMode.Absolute => address = mem.readU16(self.programCounter),
            AddressingMode.AbsoluteX => {
                const pos = mem.readU16(self.programCounter);
                address = pos +% self.registerX;
            },
            AddressingMode.AbsoluteY => {
                const pos = mem.readU16(self.programCounter);
                address = pos +% self.registerY;
            },
            AddressingMode.IndirectX => {
                const pos = mem.memory[self.programCounter];
                const ptr = pos +% self.registerX;
                const lo = @as(u16, mem.memory[ptr]);
                const hi = @as(u16, mem.memory[ptr +% 1]);
                address = hi << 8 | lo;
            },
            AddressingMode.IndirectY => {
                const pos = mem.memory[self.programCounter];
                const lo = @as(u16, mem.memory[pos]);
                const hi = @as(u16, mem.memory[pos +% 1]);
                const deref = hi << 8 | lo;
                address = deref +% self.registerY;
            },
            else => std.debug.panic("Make sure your last operation has the correct addressing mode encoded!", .{}),
        }

        return address;
    }
};

pub fn isBitSet(comptime Value: type, value: Value, comptime bit: usize) bool {
    comptime std.debug.assert(bit < @typeInfo(Value).Int.bits);

    return (value & (@as(Value, 1) << @intCast(bit))) != 0;
}

pub fn main() !void {
    ray.InitWindow(400, 400, "NES");
    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        ray.EndDrawing();
    }

    ray.CloseWindow();
}

test "0x29 AND - Bitwise AND with Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x55, 0x29, 0xAA, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x00);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == true);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0x18 CLC - Clear Carry Flag" {
    var mem = Memory.init(&[_]u8{ 0x18, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.status = 0xFF;

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, 0) == false);
}

test "0xD8 CLD - Clear Decimal Mode Flag" {
    var mem = Memory.init(&[_]u8{ 0xD8, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.status = 0xFF;

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, 3) == false);
}

test "0x58 CLI - Clear Interrupt Disable" {
    var mem = Memory.init(&[_]u8{ 0x58, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.status = 0xFF;

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, 2) == false);
}

test "0xB8 CLV - Clear Overflow Flag" {
    var mem = Memory.init(&[_]u8{ 0xB8, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.status = 0xFF;

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, 6) == false);
}

test "0xC9 CMP - Compare with Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x05, 0xC9, 0x0A, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b1011_0000);

    mem = Memory.init(&[_]u8{ 0xA9, 0x0A, 0xC9, 0x05, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b0011_0001);

    mem = Memory.init(&[_]u8{ 0xA9, 0x0A, 0xC9, 0x0A, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b0011_0011);
}

test "0xE0 CPX - Compare X Register" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x05, 0xAA, 0xE0, 0x0A, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b1011_0000);

    mem = Memory.init(&[_]u8{ 0xA9, 0x0A, 0xAA, 0xE0, 0x05, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b0011_0001);

    mem = Memory.init(&[_]u8{ 0xA9, 0x0A, 0xAA, 0xE0, 0x0A, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b0011_0011);
}

test "0xC0 CPY - Compare Y Register" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x05, 0xA8, 0xC0, 0x0A, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b1011_0000);

    mem = Memory.init(&[_]u8{ 0xA9, 0x0A, 0xA8, 0xC0, 0x05, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b0011_0001);

    mem = Memory.init(&[_]u8{ 0xA9, 0x0A, 0xA8, 0xC0, 0x0A, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b0011_0011);
}

test "0xC6 DEC - Decrement Memory" {
    var mem = Memory.init(&[_]u8{ 0xCE, 0x00, 0x02, 0xCE, 0x00, 0x02, 0x00 });
    mem.memory[0x0200] = 0x01;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(mem.memory[0x0200] == 0xFF);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == true);
}

test "0xCA DEX - Decrement X Register" {
    var mem = Memory.init(&[_]u8{ 0xCA, 0xCA, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerX = 0x01;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 0xFF);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == true);
}

test "0xCA DEY - Decrement Y Register" {
    var mem = Memory.init(&[_]u8{ 0x88, 0x88, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerY = 0x01;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerY == 0xFF);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == true);
}

test "0x49 EOR - Exclusive OR" {
    var mem = Memory.init(&[_]u8{ 0x49, 0x55, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerA = 0xAA;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0xFF);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == true);
}

test "0xEE INC - Increment Memory" {
    var mem = Memory.init(&[_]u8{ 0xEE, 0x00, 0x02, 0xEE, 0x00, 0x02, 0x00 });
    mem.memory[0x0200] = 0xFF;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(mem.memory[0x0200] == 0x01);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xE8 INX - Increment X Register" {
    var mem = Memory.init(&[_]u8{ 0xE8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 1);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xE8 INX - Increment X Register with overflow" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0xFF, 0xAA, 0xE8, 0xE8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 1);
}

test "0xC8 INY - Increment Y Register" {
    var mem = Memory.init(&[_]u8{ 0xC8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerY == 1);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xA9 LDA - Load Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x05, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x05);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xA5 LDA - Load Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA5, 0x10, 0x00 });
    mem.memory[0x10] = 0x55;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x55);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xA6 LDX - Load X Register" {
    var mem = Memory.init(&[_]u8{ 0xA6, 0x10, 0x00 });
    mem.memory[0x10] = 0x55;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 0x55);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xA4 LDY - Load Y Register" {
    var mem = Memory.init(&[_]u8{ 0xA4, 0x10, 0x00 });
    mem.memory[0x10] = 0x55;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerY == 0x55);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xAA TAX - Transfer Accumulator to X" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x0A, 0xAA, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 10);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xA8 TAY - Transfer Accumulator to Y" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0xFF, 0xA8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerY == 0xFF);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == true);
}

test "loads 0xC0 into X and increments by 1" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0xC0, 0xAA, 0xE8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 0xC1);
}

test "0x85 STA - Store Accumulator" {
    var mem = Memory.init(&[_]u8{ 0x85, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerA = 0xFF;

    cpu.interpret(&mem);

    try std.testing.expect(mem.memory[0] == 0xFF);
}

test "0x86 STX - Store X Register" {
    var mem = Memory.init(&[_]u8{ 0x86, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerX = 0xFF;

    cpu.interpret(&mem);

    try std.testing.expect(mem.memory[0] == 0xFF);
}

test "0x84 STY - Store Y Register" {
    var mem = Memory.init(&[_]u8{ 0x84, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerY = 0xFF;

    cpu.interpret(&mem);

    try std.testing.expect(mem.memory[0] == 0xFF);
}
