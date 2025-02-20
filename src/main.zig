const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const AddressingMode = enum(u8) {
    Accumulator,
    Absolute,
    AbsoluteX,
    AbsoluteY,
    Indirect,
    IndirectX,
    IndirectY,
    Immediate,
    Implied,
    Relative,
    ZeroPage,
    ZeroPageX,
    ZeroPageY,
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

const Instructions = &[_]Instruction{
    // ADC
    Instruction{
        .key = 0x69,
        .value = OpCode{
            .mnemonic = "ADC",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.ADC,
        },
    },
    Instruction{
        .key = 0x65,
        .value = OpCode{
            .mnemonic = "ADC",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.ADC,
        },
    },
    Instruction{
        .key = 0x75,
        .value = OpCode{
            .mnemonic = "ADC",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.ADC,
        },
    },
    Instruction{
        .key = 0x6D,
        .value = OpCode{
            .mnemonic = "ADC",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.ADC,
        },
    },
    Instruction{
        .key = 0x7D,
        .value = OpCode{
            .mnemonic = "ADC",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.ADC,
        },
    },
    Instruction{
        .key = 0x79,
        .value = OpCode{
            .mnemonic = "ADC",
            .addressingMode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.ADC,
        },
    },
    Instruction{
        .key = 0x61,
        .value = OpCode{
            .mnemonic = "ADC",
            .addressingMode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.ADC,
        },
    },
    Instruction{
        .key = 0x71,
        .value = OpCode{
            .mnemonic = "ADC",
            .addressingMode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.ADC,
        },
    },

    // AND
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

    // ASL
    Instruction{
        .key = 0x0A,
        .value = OpCode{
            .mnemonic = "ASL",
            .addressingMode = AddressingMode.Accumulator,
            .bytes = 1,
            .decodingFn = Cpu.ASL,
        },
    },
    Instruction{
        .key = 0x06,
        .value = OpCode{
            .mnemonic = "ASL",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.ASL,
        },
    },
    Instruction{
        .key = 0x16,
        .value = OpCode{
            .mnemonic = "ASL",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.ASL,
        },
    },
    Instruction{
        .key = 0x0E,
        .value = OpCode{
            .mnemonic = "ASL",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.ASL,
        },
    },
    Instruction{
        .key = 0x1E,
        .value = OpCode{
            .mnemonic = "ASL",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.ASL,
        },
    },

    // BCC
    Instruction{
        .key = 0x90,
        .value = OpCode{
            .mnemonic = "BCC",
            .addressingMode = AddressingMode.Relative,
            .bytes = 2,
            .decodingFn = Cpu.BCC,
        },
    },

    // BCS
    Instruction{
        .key = 0xB0,
        .value = OpCode{
            .mnemonic = "BCS",
            .addressingMode = AddressingMode.Relative,
            .bytes = 2,
            .decodingFn = Cpu.BCS,
        },
    },

    // BEQ
    Instruction{
        .key = 0xF0,
        .value = OpCode{
            .mnemonic = "BEQ",
            .addressingMode = AddressingMode.Relative,
            .bytes = 2,
            .decodingFn = Cpu.BEQ,
        },
    },

    // BIT
    Instruction{
        .key = 0x24,
        .value = OpCode{
            .mnemonic = "BIT",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.BIT,
        },
    },
    Instruction{
        .key = 0x2C,
        .value = OpCode{
            .mnemonic = "BIT",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.BIT,
        },
    },

    // BMI
    Instruction{
        .key = 0x30,
        .value = OpCode{
            .mnemonic = "BMI",
            .addressingMode = AddressingMode.Relative,
            .bytes = 2,
            .decodingFn = Cpu.BMI,
        },
    },

    // BNE
    Instruction{
        .key = 0xD0,
        .value = OpCode{
            .mnemonic = "BNE",
            .addressingMode = AddressingMode.Relative,
            .bytes = 2,
            .decodingFn = Cpu.BNE,
        },
    },

    // BPL
    Instruction{
        .key = 0x10,
        .value = OpCode{
            .mnemonic = "BPL",
            .addressingMode = AddressingMode.Relative,
            .bytes = 2,
            .decodingFn = Cpu.BPL,
        },
    },

    // BRK
    Instruction{
        .key = 0x00,
        .value = OpCode{
            .mnemonic = "BRK",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.BRK,
        },
    },

    // BVC
    Instruction{
        .key = 0x50,
        .value = OpCode{
            .mnemonic = "BVC",
            .addressingMode = AddressingMode.Relative,
            .bytes = 2,
            .decodingFn = Cpu.BVC,
        },
    },

    // BVS
    Instruction{
        .key = 0x70,
        .value = OpCode{
            .mnemonic = "BVS",
            .addressingMode = AddressingMode.Relative,
            .bytes = 2,
            .decodingFn = Cpu.BVS,
        },
    },

    // CLC
    Instruction{
        .key = 0x18,
        .value = OpCode{
            .mnemonic = "CLC",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.CLC,
        },
    },

    // CLD
    Instruction{
        .key = 0xD8,
        .value = OpCode{
            .mnemonic = "CLD",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.CLD,
        },
    },

    // CLI
    Instruction{
        .key = 0x58,
        .value = OpCode{
            .mnemonic = "CLI",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.CLI,
        },
    },

    // CLV
    Instruction{
        .key = 0xB8,
        .value = OpCode{
            .mnemonic = "CLV",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.CLV,
        },
    },

    // CMP
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

    // CPX
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

    // CPY
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

    // DEC
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

    // DEX
    Instruction{
        .key = 0xCA,
        .value = OpCode{
            .mnemonic = "DEX",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.DEX,
        },
    },

    // DEY
    Instruction{
        .key = 0x88,
        .value = OpCode{
            .mnemonic = "DEY",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.DEY,
        },
    },

    // EOR
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

    // INC
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

    // INX
    Instruction{
        .key = 0xE8,
        .value = OpCode{
            .mnemonic = "INX",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.INX,
        },
    },

    // INY
    Instruction{
        .key = 0xC8,
        .value = OpCode{
            .mnemonic = "INY",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.INY,
        },
    },

    // JMP
    Instruction{
        .key = 0x4C,
        .value = OpCode{
            .mnemonic = "JMP",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.JMP,
        },
    },
    Instruction{
        .key = 0x6C,
        .value = OpCode{
            .mnemonic = "JMP",
            .addressingMode = AddressingMode.Indirect,
            .bytes = 3,
            .decodingFn = Cpu.JMP,
        },
    },

    // JSR
    Instruction{
        .key = 0x20,
        .value = OpCode{
            .mnemonic = "JSR",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.JSR,
        },
    },

    // LDA
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

    // LDX
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

    // LDY
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

    // LSR
    Instruction{
        .key = 0x4A,
        .value = OpCode{
            .mnemonic = "LSR",
            .addressingMode = AddressingMode.Accumulator,
            .bytes = 1,
            .decodingFn = Cpu.LSR,
        },
    },
    Instruction{
        .key = 0x46,
        .value = OpCode{
            .mnemonic = "LSR",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.LSR,
        },
    },
    Instruction{
        .key = 0x56,
        .value = OpCode{
            .mnemonic = "LSR",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.LSR,
        },
    },
    Instruction{
        .key = 0x4E,
        .value = OpCode{
            .mnemonic = "LSR",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.LSR,
        },
    },
    Instruction{
        .key = 0x5E,
        .value = OpCode{
            .mnemonic = "LSR",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.LSR,
        },
    },

    // NOP
    Instruction{
        .key = 0xEA,
        .value = OpCode{
            .mnemonic = "NOP",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.NOP,
        },
    },

    // ORA
    Instruction{
        .key = 0x09,
        .value = OpCode{
            .mnemonic = "ORA",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.ORA,
        },
    },
    Instruction{
        .key = 0x05,
        .value = OpCode{
            .mnemonic = "ORA",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.ORA,
        },
    },
    Instruction{
        .key = 0x15,
        .value = OpCode{
            .mnemonic = "ORA",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.ORA,
        },
    },
    Instruction{
        .key = 0x0D,
        .value = OpCode{
            .mnemonic = "ORA",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.ORA,
        },
    },
    Instruction{
        .key = 0x1D,
        .value = OpCode{
            .mnemonic = "ORA",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.ORA,
        },
    },
    Instruction{
        .key = 0x19,
        .value = OpCode{
            .mnemonic = "ORA",
            .addressingMode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.ORA,
        },
    },
    Instruction{
        .key = 0x01,
        .value = OpCode{
            .mnemonic = "ORA",
            .addressingMode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.ORA,
        },
    },
    Instruction{
        .key = 0x11,
        .value = OpCode{
            .mnemonic = "ORA",
            .addressingMode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.ORA,
        },
    },

    // PHA
    Instruction{
        .key = 0x48,
        .value = OpCode{
            .mnemonic = "PHA",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.PHA,
        },
    },

    // PHP
    Instruction{
        .key = 0x08,
        .value = OpCode{
            .mnemonic = "PHP",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.PHP,
        },
    },

    // PLA
    Instruction{
        .key = 0x68,
        .value = OpCode{
            .mnemonic = "PLA",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.PLA,
        },
    },

    // PLP
    Instruction{
        .key = 0x28,
        .value = OpCode{
            .mnemonic = "PLP",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.PLP,
        },
    },

    // ROL
    Instruction{
        .key = 0x2A,
        .value = OpCode{
            .mnemonic = "ROL",
            .addressingMode = AddressingMode.Accumulator,
            .bytes = 1,
            .decodingFn = Cpu.ROL,
        },
    },
    Instruction{
        .key = 0x26,
        .value = OpCode{
            .mnemonic = "ROL",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.ROL,
        },
    },
    Instruction{
        .key = 0x36,
        .value = OpCode{
            .mnemonic = "ROL",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.ROL,
        },
    },
    Instruction{
        .key = 0x2E,
        .value = OpCode{
            .mnemonic = "ROL",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.ROL,
        },
    },
    Instruction{
        .key = 0x3E,
        .value = OpCode{
            .mnemonic = "ROL",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.ROL,
        },
    },

    // ROR
    Instruction{
        .key = 0x6A,
        .value = OpCode{
            .mnemonic = "ROR",
            .addressingMode = AddressingMode.Accumulator,
            .bytes = 1,
            .decodingFn = Cpu.ROR,
        },
    },
    Instruction{
        .key = 0x66,
        .value = OpCode{
            .mnemonic = "ROR",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.ROR,
        },
    },
    Instruction{
        .key = 0x76,
        .value = OpCode{
            .mnemonic = "ROR",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.ROR,
        },
    },
    Instruction{
        .key = 0x6E,
        .value = OpCode{
            .mnemonic = "ROR",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.ROR,
        },
    },
    Instruction{
        .key = 0x7E,
        .value = OpCode{
            .mnemonic = "ROR",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.ROR,
        },
    },

    // RTI
    Instruction{
        .key = 0x40,
        .value = OpCode{
            .mnemonic = "RTI",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.RTI,
        },
    },

    // RTS
    Instruction{
        .key = 0x60,
        .value = OpCode{
            .mnemonic = "RTS",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.RTS,
        },
    },

    // SBC
    Instruction{
        .key = 0xE9,
        .value = OpCode{
            .mnemonic = "SBC",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.SBC,
        },
    },
    Instruction{
        .key = 0xE5,
        .value = OpCode{
            .mnemonic = "SBC",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.SBC,
        },
    },
    Instruction{
        .key = 0xF5,
        .value = OpCode{
            .mnemonic = "SBC",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.SBC,
        },
    },
    Instruction{
        .key = 0xED,
        .value = OpCode{
            .mnemonic = "SBC",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.SBC,
        },
    },
    Instruction{
        .key = 0xFD,
        .value = OpCode{
            .mnemonic = "SBC",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.SBC,
        },
    },
    Instruction{
        .key = 0xF9,
        .value = OpCode{
            .mnemonic = "SBC",
            .addressingMode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.SBC,
        },
    },
    Instruction{
        .key = 0xE1,
        .value = OpCode{
            .mnemonic = "SBC",
            .addressingMode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.SBC,
        },
    },
    Instruction{
        .key = 0xF1,
        .value = OpCode{
            .mnemonic = "SBC",
            .addressingMode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.SBC,
        },
    },

    // SEC
    Instruction{
        .key = 0x38,
        .value = OpCode{
            .mnemonic = "SEC",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.SEC,
        },
    },

    // SED
    Instruction{
        .key = 0xF8,
        .value = OpCode{
            .mnemonic = "SED",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.SED,
        },
    },

    // SEI
    Instruction{
        .key = 0x78,
        .value = OpCode{
            .mnemonic = "SEI",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.SEI,
        },
    },

    // STA
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

    // STX
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
            .addressingMode = AddressingMode.ZeroPageY,
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

    // STY
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

    // TAX
    Instruction{
        .key = 0xAA,
        .value = OpCode{
            .mnemonic = "TAX",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.TAX,
        },
    },

    // TAY
    Instruction{
        .key = 0xA8,
        .value = OpCode{
            .mnemonic = "TAY",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.TAY,
        },
    },

    // TSX
    Instruction{
        .key = 0xBA,
        .value = OpCode{
            .mnemonic = "TSX",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.TSX,
        },
    },

    // TXA
    Instruction{
        .key = 0x8A,
        .value = OpCode{
            .mnemonic = "TXA",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.TXA,
        },
    },

    // TXS
    Instruction{
        .key = 0x9A,
        .value = OpCode{
            .mnemonic = "TXS",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.TXS,
        },
    },

    // TYA
    Instruction{
        .key = 0x98,
        .value = OpCode{
            .mnemonic = "TYA",
            .addressingMode = AddressingMode.Implied,
            .bytes = 1,
            .decodingFn = Cpu.TYA,
        },
    },
};

const Memory = struct {
    memory: [0xFFFF]u8,

    const ROM_START: u16 = 0x8000;
    const ROM_END: u16 = 0xFFFF;
    const ROM_PROGRAM_START: u16 = 0xFFFC;
    const STACK_START: u16 = 0x0100;
    const STACK_END: u16 = 0x01FF;

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
    const BREAK_COMMAND: u8 = 0b0001_0000;
    const OVERFLOW_FLAG: u8 = 0b0100_0000;
    const NEGATIVE_FLAG: u8 = 0b1000_0000;

    programCounter: u16,
    status: u8,
    registerA: u8, // a.k.a acumulator
    registerX: u8,
    registerY: u8,
    registerS: u8,

    pub fn init(mem: *Memory) Cpu {
        return Cpu{
            .programCounter = mem.readU16(Memory.ROM_PROGRAM_START),
            .status = 0b0010_0000,
            .registerA = 0,
            .registerX = 0,
            .registerY = 0,
            .registerS = 0xFF,
        };
    }

    pub fn ADC(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.nextAddress(mem, addressingMode);
        const sum = @as(u16, cpu.registerA) + @as(u16, mem.memory[address]) + @as(u16, (cpu.status >> 0) & 0x01);
        // https://www.righto.com/2012/12/the-6502-overflow-flag-explained.html
        const sign = (cpu.registerA ^ @as(u8, @truncate(sum)) & (mem.memory[address]) ^ @as(u8, @truncate(sum))) & 0x80;

        cpu.registerA = @as(u8, @truncate(sum));
        cpu.status = cpu.status & ~CARRY_FLAG | if (sum > 0xFF) CARRY_FLAG else 0;
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerA == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
        cpu.status = cpu.status & ~OVERFLOW_FLAG | if (sign != 0) OVERFLOW_FLAG else 0;
    }

    pub fn AND(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.nextAddress(mem, addressingMode);

        cpu.registerA &= mem.memory[address];
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerA == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    pub fn ASL(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        // todo
        const toShift = if (addressingMode == AddressingMode.Accumulator)
            cpu.registerA
        else
            mem.memory[cpu.nextAddress(mem, addressingMode)];

        cpu.registerA = toShift << 1;
        cpu.status = cpu.status & ~CARRY_FLAG | if (isBitSet(u8, toShift, 0b1000_0000)) CARRY_FLAG else 0;
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerA == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    inline fn branch(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.nextAddress(mem, addressingMode);
        const step = @as(i8, @bitCast(@as(u8, @truncate(address))));
        cpu.programCounter +%= @as(u16, @bitCast(@as(i16, step))) +% 1;
    }

    pub fn BCC(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        if (!isBitSet(u8, cpu.status, CARRY_FLAG)) {
            Cpu.branch(cpu, mem, addressingMode);
        }
    }

    pub fn BCS(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        if (isBitSet(u8, cpu.status, CARRY_FLAG)) {
            Cpu.branch(cpu, mem, addressingMode);
        }
    }

    pub fn BEQ(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        if (isBitSet(u8, cpu.status, ZERO_FLAG)) {
            Cpu.branch(cpu, mem, addressingMode);
        }
    }

    pub fn BIT(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.nextAddress(mem, addressingMode);
        const result = cpu.registerA & mem.memory[address];

        cpu.status = cpu.status & ~ZERO_FLAG | if (result == 0) ZERO_FLAG else 0;
        cpu.status |= result & OVERFLOW_FLAG;
        cpu.status |= result & NEGATIVE_FLAG;
    }

    pub fn BMI(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        if (isBitSet(u8, cpu.status, NEGATIVE_FLAG)) {
            Cpu.branch(cpu, mem, addressingMode);
        }
    }

    pub fn BNE(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        if (!isBitSet(u8, cpu.status, ZERO_FLAG)) {
            Cpu.branch(cpu, mem, addressingMode);
        }
    }

    pub fn BPL(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        if (!isBitSet(u8, cpu.status, NEGATIVE_FLAG)) {
            Cpu.branch(cpu, mem, addressingMode);
        }
    }

    pub fn BRK(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.status |= BREAK_COMMAND;
    }

    pub fn BVC(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        if (!isBitSet(u8, cpu.status, OVERFLOW_FLAG)) {
            Cpu.branch(cpu, mem, addressingMode);
        }
    }

    pub fn BVS(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        if (isBitSet(u8, cpu.status, OVERFLOW_FLAG)) {
            Cpu.branch(cpu, mem, addressingMode);
        }
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
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, result, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    pub fn CMP(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        compare(cpu, mem, addressingMode, &cpu.registerA);
    }

    pub fn CPX(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        compare(cpu, mem, addressingMode, &cpu.registerX);
    }

    pub fn CPY(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        compare(cpu, mem, addressingMode, &cpu.registerY);
    }

    inline fn decrement(value: *u8, status: *u8) void {
        value.* -%= 1;
        status.* = status.* & ~ZERO_FLAG | if (value.* == 0) ZERO_FLAG else 0;
        status.* = status.* & ~NEGATIVE_FLAG | if (isBitSet(u8, value.*, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
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
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    inline fn increment(value: *u8, status: *u8) void {
        value.* +%= 1;
        status.* = status.* & ~ZERO_FLAG | if (value.* == 0) ZERO_FLAG else 0;
        status.* = status.* & ~NEGATIVE_FLAG | if (isBitSet(u8, value.*, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
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

    pub fn JMP(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.nextAddress(mem, addressingMode);
        cpu.programCounter = address;
    }

    pub fn JSR(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        mem.writeU16(Memory.STACK_START + cpu.registerS, cpu.programCounter + 1);

        if (cpu.registerS != 0x00) {
            cpu.registerS -= 2;
        } else {
            std.debug.panic("stack overflow detected!", .{});
        }

        cpu.programCounter = nextAddress(cpu, mem, addressingMode);
    }

    inline fn load(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode, register: *u8) void {
        const address = cpu.nextAddress(mem, addressingMode);
        register.* = mem.memory[address];
        cpu.status = cpu.status & ~ZERO_FLAG | if (register.* == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, register.*, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
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

    pub fn LSR(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        // todo
        const toShift = if (addressingMode == AddressingMode.Accumulator)
            cpu.registerA
        else
            mem.memory[cpu.nextAddress(mem, addressingMode)];

        cpu.registerA = toShift >> 1;
        cpu.status = cpu.status & ~CARRY_FLAG | if (isBitSet(u8, toShift, 0b0000_0001)) CARRY_FLAG else 0;
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerA == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    pub fn NOP(_: *Cpu, _: *Memory, _: AddressingMode) void {
        return;
    }

    pub fn ORA(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.nextAddress(mem, addressingMode);
        cpu.registerA |= mem.memory[address];

        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerA == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    pub fn PHA(cpu: *Cpu, mem: *Memory, _: AddressingMode) void {
        mem.memory[Memory.STACK_START + cpu.registerS] = cpu.registerA;
        if (cpu.registerS != 0x00) {
            cpu.registerS -= 1;
        } else {
            std.debug.panic("stack overflow detected!", .{});
        }
    }

    pub fn PHP(cpu: *Cpu, mem: *Memory, _: AddressingMode) void {
        mem.memory[Memory.STACK_START + cpu.registerS] = cpu.status;
        if (cpu.registerS != 0x00) {
            cpu.registerS -= 1;
        } else {
            std.debug.panic("stack overflow detected!", .{});
        }
    }

    pub fn PLA(cpu: *Cpu, mem: *Memory, _: AddressingMode) void {
        if (cpu.registerS != 0xFF) {
            cpu.registerS += 1;
        } else {
            std.debug.panic("stack underflow detected!", .{});
        }

        cpu.registerA = mem.memory[Memory.STACK_START + cpu.registerS];
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerA == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    pub fn PLP(cpu: *Cpu, mem: *Memory, _: AddressingMode) void {
        if (cpu.registerS != 0xFF) {
            cpu.registerS += 1;
        } else {
            std.debug.panic("stack underflow detected!", .{});
        }

        cpu.status = mem.memory[Memory.STACK_START + cpu.registerS];
    }

    pub fn ROL(_: *Cpu, _: *Memory, _: AddressingMode) void {
        return;
    }

    pub fn ROR(_: *Cpu, _: *Memory, _: AddressingMode) void {
        return;
    }

    pub fn RTI(_: *Cpu, _: *Memory, _: AddressingMode) void {
        return;
    }

    pub fn RTS(cpu: *Cpu, mem: *Memory, _: AddressingMode) void {
        if (cpu.registerS != 0xFF) {
            cpu.registerS += 2;
        } else {
            std.debug.panic("stack underflow detected!", .{});
        }

        cpu.programCounter = mem.readU16(Memory.STACK_START + cpu.registerS) + 1;
    }

    pub fn SBC(_: *Cpu, _: *Memory, _: AddressingMode) void {
        return;
    }

    pub fn SEC(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.status |= CARRY_FLAG;
    }

    pub fn SED(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.status |= DECIMAL_MODE_FLAG;
    }

    pub fn SEI(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.status |= INTERRUPT_DISABLE;
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

    pub fn TAX(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.registerX = cpu.registerA;
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerX == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerX, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    pub fn TAY(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.registerY = cpu.registerA;
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerY == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerY, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    pub fn TSX(cpu: *Cpu, mem: *Memory, _: AddressingMode) void {
        cpu.registerX = mem.memory[Memory.STACK_START + cpu.registerS];
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerX == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerX, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    pub fn TXA(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.registerA = cpu.registerX;
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerA == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    pub fn TXS(cpu: *Cpu, mem: *Memory, _: AddressingMode) void {
        mem.memory[Memory.STACK_START + cpu.registerS] = cpu.registerX;
    }

    pub fn TYA(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.registerA = cpu.registerY;
        cpu.status = cpu.status & ~ZERO_FLAG | if (cpu.registerA == 0) ZERO_FLAG else 0;
        cpu.status = cpu.status & ~NEGATIVE_FLAG | if (isBitSet(u8, cpu.registerA, NEGATIVE_FLAG)) NEGATIVE_FLAG else 0;
    }

    pub fn interpret(self: *Cpu, mem: *Memory) void {
        while (!isBitSet(u8, self.status, BREAK_COMMAND)) {
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
            AddressingMode.Accumulator => address = self.registerA,
            AddressingMode.Immediate => address = self.programCounter,
            AddressingMode.ZeroPage, AddressingMode.Relative => address = mem.memory[self.programCounter],
            AddressingMode.ZeroPageX => {
                const location = mem.memory[self.programCounter];
                address = location +% self.registerX;
            },
            AddressingMode.ZeroPageY => {
                const location = mem.memory[self.programCounter];
                address = location +% self.registerY;
            },
            AddressingMode.Absolute => address = mem.readU16(self.programCounter),
            AddressingMode.AbsoluteX => {
                const location = mem.readU16(self.programCounter);
                address = location +% self.registerX;
            },
            AddressingMode.AbsoluteY => {
                const location = mem.readU16(self.programCounter);
                address = location +% self.registerY;
            },
            AddressingMode.Indirect => {
                const lo = @as(u16, mem.memory[self.programCounter]);
                const hi = @as(u16, mem.memory[self.programCounter +% 1]);
                const ptr = hi << 8 | lo;
                address = mem.readU16(ptr);
            },
            AddressingMode.IndirectX => {
                const location = mem.memory[self.programCounter];
                const ptr = location +% self.registerX;
                const lo = @as(u16, mem.memory[ptr]);
                const hi = @as(u16, mem.memory[ptr +% 1]);
                address = hi << 8 | lo;
            },
            AddressingMode.IndirectY => {
                const location = mem.memory[self.programCounter];
                const lo = @as(u16, mem.memory[location]);
                const hi = @as(u16, mem.memory[location +% 1]);
                const deref = hi << 8 | lo;
                address = deref +% self.registerY;
            },
            else => std.debug.panic("Make sure your last operation has the correct addressing mode encoded!", .{}),
        }

        return address;
    }
};

pub inline fn isBitSet(comptime Value: type, value: Value, comptime mask: Value) bool {
    return (value & mask) == mask;
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
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == true);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == false);
}

test "0x18 CLC - Clear Carry Flag" {
    var mem = Memory.init(&[_]u8{ 0x18, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.status = Cpu.CARRY_FLAG;

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.CARRY_FLAG) == false);
}

test "0xD8 CLD - Clear Decimal Mode Flag" {
    var mem = Memory.init(&[_]u8{ 0xD8, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.status = Cpu.DECIMAL_MODE_FLAG;

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.DECIMAL_MODE_FLAG) == false);
}

test "0x58 CLI - Clear Interrupt Disable" {
    var mem = Memory.init(&[_]u8{ 0x58, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.status = Cpu.INTERRUPT_DISABLE;

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.INTERRUPT_DISABLE) == false);
}

test "0xB8 CLV - Clear Overflow Flag" {
    var mem = Memory.init(&[_]u8{ 0xB8, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.status = Cpu.OVERFLOW_FLAG;

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.OVERFLOW_FLAG) == false);
}

test "0x38 SEC - Set Carry Flag" {
    var mem = Memory.init(&[_]u8{ 0x38, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.CARRY_FLAG) == true);
}

test "0xF8 SED - Set Decimal Flag" {
    var mem = Memory.init(&[_]u8{ 0xF8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.DECIMAL_MODE_FLAG) == true);
}

test "0x78 SED - Set Decimal Flag" {
    var mem = Memory.init(&[_]u8{ 0x78, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.INTERRUPT_DISABLE) == true);
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
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == true);
}

test "0xCA DEX - Decrement X Register" {
    var mem = Memory.init(&[_]u8{ 0xCA, 0xCA, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerX = 0x01;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 0xFF);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == true);
}

test "0xCA DEY - Decrement Y Register" {
    var mem = Memory.init(&[_]u8{ 0x88, 0x88, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerY = 0x01;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerY == 0xFF);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == true);
}

test "0x49 EOR - Exclusive OR" {
    var mem = Memory.init(&[_]u8{ 0x49, 0x55, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerA = 0xAA;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0xFF);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == true);
}

test "0xEE INC - Increment Memory" {
    var mem = Memory.init(&[_]u8{ 0xEE, 0x00, 0x02, 0xEE, 0x00, 0x02, 0x00 });
    mem.memory[0x0200] = 0xFF;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(mem.memory[0x0200] == 0x01);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == false);
}

test "0xE8 INX - Increment X Register" {
    var mem = Memory.init(&[_]u8{ 0xE8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 1);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == false);
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
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == false);
}

test "0xA9 LDA - Load Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x05, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x05);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == false);
}

test "0xA5 LDA - Load Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA5, 0x10, 0x00 });
    mem.memory[0x10] = 0x55;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x55);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == false);
}

test "0xA6 LDX - Load X Register" {
    var mem = Memory.init(&[_]u8{ 0xA6, 0x10, 0x00 });
    mem.memory[0x10] = 0x55;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 0x55);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == false);
}

test "0xA4 LDY - Load Y Register" {
    var mem = Memory.init(&[_]u8{ 0xA4, 0x10, 0x00 });
    mem.memory[0x10] = 0x55;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerY == 0x55);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == false);
}

test "0xAA TAX - Transfer Accumulator to X" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x0A, 0xAA, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 10);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == false);
}

test "0xA8 TAY - Transfer Accumulator to Y" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0xFF, 0xA8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerY == 0xFF);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == true);
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

test "0x09 ORA - Logical Inclusive OR" {
    var mem = Memory.init(&[_]u8{ 0x09, 0xAA, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerA = 0x55;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0xFF);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == true);
}

test "0x8A TXA - Transfer X to Accumulator" {
    var mem = Memory.init(&[_]u8{ 0x8A, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerX = 0xAA;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0xAA);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == true);
}

test "0x98 TYA - Transfer Y to Accumulator" {
    var mem = Memory.init(&[_]u8{ 0x98, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerY = 0xAA;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0xAA);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.ZERO_FLAG) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, Cpu.NEGATIVE_FLAG) == true);
}

test "0x4C JMP - Jump" {
    var mem = Memory.init(&[_]u8{ 0x4C, 0x05, 0x80, 0xA2, 0xAA, 0xA9, 0x55, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerX == 0x00);
    try std.testing.expect(cpu.registerA == 0x55);
}

test "0x6C JMP - Jump" {
    var mem = Memory.init(&[_]u8{ 0x6C, 0x04, 0x80, 0xEA, 0x06, 0x80, 0xA9, 0xAA, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0xAA);
}

test "0x0A ASL - Arithmetic Shift Left" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x01, 0x0A, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x02, cpu.registerA);
    try std.testing.expectEqual(0b0011_0000, cpu.status);

    mem = Memory.init(&[_]u8{ 0xA9, 0x40, 0x0A, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x80, cpu.registerA);
    try std.testing.expectEqual(0b1011_0000, cpu.status);

    mem = Memory.init(&[_]u8{ 0xA9, 0x80, 0x0A, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x00, cpu.registerA);
    try std.testing.expectEqual(0b0011_0011, cpu.status);

    mem = Memory.init(&[_]u8{ 0xA9, 0xFF, 0x0A, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0xFE, cpu.registerA);
    try std.testing.expectEqual(0b1011_0001, cpu.status);
}

test "0x69 ADC - Add with Carry" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x10, 0x18, 0x69, 0x20, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x30);
    try std.testing.expect(cpu.status == 0b0011_0000);

    mem = Memory.init(&[_]u8{ 0xA9, 0x50, 0x18, 0x69, 0xB0, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x00);
    try std.testing.expect(cpu.status == 0b0011_0011);

    mem = Memory.init(&[_]u8{ 0xA9, 0x50, 0x18, 0x69, 0x50, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0xA0);
    try std.testing.expect(cpu.status == 0b1111_0000);

    mem = Memory.init(&[_]u8{ 0xA9, 0xD0, 0x18, 0x69, 0x90, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x60);
    try std.testing.expect(cpu.status == 0b0111_0001);

    mem = Memory.init(&[_]u8{ 0xA9, 0x10, 0x38, 0x69, 0x10, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x21);
    try std.testing.expect(cpu.status == 0b0011_0000);
}

test "0x2C BIT - Bit Test" {
    var mem = Memory.init(&[_]u8{ 0x2C, 0x00, 0x02, 0x00 });
    mem.memory[0x0200] = 0xC0;
    var cpu = Cpu.init(&mem);
    cpu.registerA = 0xC0;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b1111_0000);

    mem = Memory.init(&[_]u8{ 0x2C, 0x00, 0x02, 0x00 });
    mem.memory[0x0200] = 0xFF;
    cpu = Cpu.init(&mem);
    cpu.registerA = 0x00;

    cpu.interpret(&mem);

    try std.testing.expect(cpu.status == 0b0011_0010);
}

test "0x90 BCC - Branch if Carry Clear" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x00, 0x18, 0x69, 0x01, 0xC9, 0x0F, 0x90, 0xFA, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 15);
}

test "0xB0 BCS - Branch if Carry Set" {
    var mem = Memory.init(&[_]u8{
        0xA9, 0x00, 0x18, 0x69, 0x01, 0xC9, 0x0F, 0xB0, 0x03, 0x4C, 0x03, 0x80, 0x00,
    });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 15);
}

test "0xF0 BEQ - Branch if Equal" {
    var mem = Memory.init(&[_]u8{
        0xA9, 0x00, 0x18, 0x69, 0x01, 0xC9, 0x0A, 0xF0, 0x03, 0x4C, 0x03, 0x80, 0x00,
    });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 10);
}

test "0x30 BMI - Branch if Minus" {
    var mem = Memory.init(&[_]u8{
        0xA9, 0x00, 0x18, 0x69, 0x10, 0x30, 0x03, 0x4C, 0x03, 0x80, 0x00,
    });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x80);
}

test "0xD0 BNE - Branch if Not Equal" {
    var mem = Memory.init(&[_]u8{
        0xA9, 0x00, 0x18, 0x69, 0x01, 0xC9, 0x0A, 0xD0, 0xF9, 0x00,
    });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 10);
}

test "0x10 BPL - Branch if Positive" {
    var mem = Memory.init(&[_]u8{
        0xA9, 0x00, 0x18, 0x69, 0x10, 0x10, 0xFB, 0x00,
    });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x80);
}

test "0x50 BVC - Branch if Overflow Clear" {
    var mem = Memory.init(&[_]u8{
        0xA9, 0x40, 0x69, 0x40, 0x50, 0xFB, 0x00,
    });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0x80);
}

test "0x70 BVS - Branch if Overflow Set" {
    var mem = Memory.init(&[_]u8{
        0x18, 0xA9, 0x50, 0x69, 0x50, 0x70, 0x05, 0xA9, 0x00, 0x4C, 0x0E, 0x80, 0xA9, 0xFF, 0x00,
    });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.registerA == 0xFF);
}

test "0x4A LSR - Logical Shift Right" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x02, 0x4A, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x01, cpu.registerA);
    try std.testing.expectEqual(0b0011_0000, cpu.status);

    mem = Memory.init(&[_]u8{ 0xA9, 0x01, 0x4A, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x00, cpu.registerA);
    try std.testing.expectEqual(0b0011_0011, cpu.status);

    mem = Memory.init(&[_]u8{ 0xA9, 0x00, 0x4A, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x00, cpu.registerA);
    try std.testing.expectEqual(0b0011_0010, cpu.status);

    mem = Memory.init(&[_]u8{ 0xA9, 0x80, 0x4A, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x40, cpu.registerA);
    try std.testing.expectEqual(0b0011_0000, cpu.status);

    mem = Memory.init(&[_]u8{ 0xA9, 0xFF, 0x4A, 0x00 });
    cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x7F, cpu.registerA);
    try std.testing.expectEqual(0b0011_0001, cpu.status);
}

test "0x48 PHA - Push Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0xFF, 0x48, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x0FF, mem.memory[0x01FF]);
    try std.testing.expectEqual(0xFE, cpu.registerS);
}

test "0x08 PHP - Push Processor Status" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0xFF, 0x48, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x0FF, mem.memory[0x01FF]);
    try std.testing.expectEqual(0xFE, cpu.registerS);
}

test "0x68 PLA - Pull Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0xFF, 0x48, 0xA9, 0x00, 0x68, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x0FF, cpu.registerA);
    try std.testing.expectEqual(0xFF, cpu.registerS);
    try std.testing.expectEqual(0b1011_0000, cpu.status);
}

test "0x28 PLP - Pull Processor Status" {
    var mem = Memory.init(&[_]u8{ 0x38, 0x08, 0x18, 0x28, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0b0011_0001, cpu.status);
}

test "0xBA TSX - Tansfer Stack Pointer to X" {
    var mem = Memory.init(&[_]u8{ 0xBA, 0x00 });
    mem.memory[0x01FF] = 0xFF;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0xFF, cpu.registerX);
    try std.testing.expectEqual(0xFF, cpu.registerS);
}

test "0x9A TSX - Tansfer X to Stack Pointer" {
    var mem = Memory.init(&[_]u8{ 0x9A, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.registerX = 0xFF;

    cpu.interpret(&mem);

    try std.testing.expectEqual(0xFF, mem.memory[0x01FF]);
    try std.testing.expectEqual(0xFF, cpu.registerS);
}

test "0x20 JSR - Jump to Subroutine" {
    var mem = Memory.init(&[_]u8{
        0x20, 0x09, 0x80, 0x20, 0x0c, 0x80, 0x20, 0x12, 0x80, 0xa2, 0x00, 0x60, 0xe8, 0xe0, 0x05, 0xd0,
        0xfb, 0x60, 0x00,
    });
    var cpu  = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expectEqual(0x05, cpu.registerX);
}
