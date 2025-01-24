const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const AddressingMode = enum(u8) {
    Immediate,
    ZeroPage,
    ZeroPageX,
    Absolute,
    AbsoluteX,
    AbsoluteY,
    IndirectX,
    IndirectY,
    None,
};

const OpCode = struct {
    mnemonic: []const u8,
    bytes: u8,
    decodingFn: *const fn (cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void,
    addressingMode: AddressingMode,
};

const Instruction = struct { key: u8, value: OpCode };

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
            .addressingMode = AddressingMode.None,
            .bytes = 1,
            .decodingFn = Cpu.BRK,
        },
    },
    //
    Instruction{
        .key = 0x18,
        .value = OpCode{
            .mnemonic = "CLC",
            .addressingMode = AddressingMode.None,
            .bytes = 1,
            .decodingFn = Cpu.CLC,
        },
    },
    //
    Instruction{
        .key = 0xD8,
        .value = OpCode{
            .mnemonic = "CLD",
            .addressingMode = AddressingMode.None,
            .bytes = 1,
            .decodingFn = Cpu.CLD,
        },
    },
    //
    Instruction{
        .key = 0x58,
        .value = OpCode{
            .mnemonic = "CLI",
            .addressingMode = AddressingMode.None,
            .bytes = 1,
            .decodingFn = Cpu.CLI,
        },
    },
    //
    Instruction{
        .key = 0xB8,
        .value = OpCode{
            .mnemonic = "CLV",
            .addressingMode = AddressingMode.None,
            .bytes = 1,
            .decodingFn = Cpu.CLV,
        },
    },
    //
    //
    Instruction{
        .key = 0xE8,
        .value = OpCode{
            .mnemonic = "INX",
            .addressingMode = AddressingMode.None,
            .bytes = 1,
            .decodingFn = Cpu.INX,
        },
    },
    //
    Instruction{
        .key = 0xAA,
        .value = OpCode{
            .mnemonic = "TAX",
            .addressingMode = AddressingMode.None,
            .bytes = 1,
            .decodingFn = Cpu.TAX,
        },
    },
    //
    Instruction{
        .key = 0xA9,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.LAD,
        },
    },
    Instruction{
        .key = 0xA5,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.LAD,
        },
    },
    Instruction{
        .key = 0xB5,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.LAD,
        },
    },
    Instruction{
        .key = 0xAD,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.LAD,
        },
    },
    Instruction{
        .key = 0xBD,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.LAD,
        },
    },
    Instruction{
        .key = 0xB9,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.LAD,
        },
    },
    Instruction{
        .key = 0xA1,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.LAD,
        },
    },
    Instruction{
        .key = 0xB1,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressingMode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.LAD,
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
};

pub fn get_instuction(key: u8) Instruction {
    for (Instructions) |instruction| {
        if (key == instruction.key) {
            return instruction;
        }
    }

    std.debug.panic("No Instruction found for ops code: 0x{X}", .{key});
}

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
        memory.write_u16(Memory.ROM_PROGRAM_START, Memory.ROM_START);

        return memory;
    }

    pub fn read_u16(self: *Memory, pos: u16) u16 {
        var buf = [_]u8{ self.memory[pos], self.memory[pos + 1] };
        return std.mem.readInt(u16, &buf, .little);
    }

    pub fn write_u16(self: *Memory, pos: u16, data: u16) void {
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
    program_counter: u16,
    status: u8,
    register_A: u8, // a.k.a acumulator
    register_X: u8,
    register_Y: u8,

    pub fn init(mem: *Memory) Cpu {
        return Cpu{
            .stop = false,
            .program_counter = mem.read_u16(Memory.ROM_PROGRAM_START),
            .status = 0,
            .register_A = 0,
            .register_X = 0,
            .register_Y = 0,
        };
    }

    pub fn AND(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.next_address(mem, addressingMode);
        cpu.register_A &= mem.memory[address];
        cpu.update_zero_and_negative_flag(&cpu.register_A);
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

    pub fn BRK(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.stop = true;
    }

    pub fn INX(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.register_X +%= 1;
        cpu.update_zero_and_negative_flag(&cpu.register_X);
    }

    pub fn TAX(cpu: *Cpu, _: *Memory, _: AddressingMode) void {
        cpu.register_X = cpu.register_A;
        cpu.update_zero_and_negative_flag(&cpu.register_A);
    }

    pub fn LAD(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.next_address(mem, addressingMode);
        cpu.register_A = mem.memory[address];
        cpu.update_zero_and_negative_flag(&cpu.register_A);
    }

    pub fn STA(cpu: *Cpu, mem: *Memory, addressingMode: AddressingMode) void {
        const address = cpu.next_address(mem, addressingMode);
        mem.memory[address] = cpu.register_A;
    }

    pub fn interpret(self: *Cpu, mem: *Memory) void {
        while (!self.stop) {
            const ops_code = mem.memory[self.program_counter];
            self.program_counter += 1;
            const program_counter_state = self.program_counter;

            const ins = get_instuction(ops_code);
            ins.value.decodingFn(self, mem, ins.value.addressingMode);

            if (program_counter_state == self.program_counter) {
                self.program_counter += ins.value.bytes - 1;
            }
        }
    }

    pub fn next_address(self: *Cpu, mem: *Memory, addressingMode: AddressingMode) u16 {
        var address: u16 = undefined;
        switch (addressingMode) {
            AddressingMode.Immediate => address = self.program_counter,
            AddressingMode.ZeroPage => address = mem.memory[self.program_counter],
            AddressingMode.ZeroPageX => {
                const pos = mem.memory[self.program_counter];
                address = pos +% self.register_X;
            },
            AddressingMode.Absolute => address = mem.read_u16(self.program_counter),
            AddressingMode.AbsoluteX => {
                const pos = mem.read_u16(self.program_counter);
                address = pos +% self.register_X;
            },
            AddressingMode.AbsoluteY => {
                const pos = mem.read_u16(self.program_counter);
                address = pos +% self.register_Y;
            },
            AddressingMode.IndirectX => {
                const pos = mem.memory[self.program_counter];
                const ptr = pos +% self.register_X;
                const lo = @as(u16, mem.memory[ptr]);
                const hi = @as(u16, mem.memory[ptr +% 1]);
                address = hi << 8 | lo;
            },
            AddressingMode.IndirectY => {
                const pos = mem.memory[self.program_counter];
                const lo = @as(u16, mem.memory[pos]);
                const hi = @as(u16, mem.memory[pos +% 1]);
                const deref = hi << 8 | lo;
                address = deref +% self.register_Y;
            },
            else => std.debug.panic("Make sure your last operation has the correct addressing mode encoded!", .{}),
        }

        return address;
    }

    pub fn update_zero_and_negative_flag(self: *Cpu, register: *const u8) void {
        if (register.* == 0) {
            self.status |= ZERO_FLAG;
        } else {
            self.status &= ~ZERO_FLAG;
        }

        if (isBitSet(u8, register.*, 7)) {
            self.status |= NEGATIVE_FLAG;
        } else {
            self.status &= ~NEGATIVE_FLAG;
        }
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

    try std.testing.expect(cpu.register_A == 0x00);
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

test "0xA9 LDA - Load Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x05, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.register_A == 0x05);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xA5 LDA - Load Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA5, 0x10, 0x00 });
    mem.memory[0x10] = 0x55;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.register_A == 0x55);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xAA TAX - Transfer Accumulator to X" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x0A, 0xAA, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.register_X == 10);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xE8 INX - Increment X Register" {
    var mem = Memory.init(&[_]u8{ 0xE8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.register_X == 1);
    try std.testing.expect(isBitSet(u8, cpu.status, 1) == false);
    try std.testing.expect(isBitSet(u8, cpu.status, 7) == false);
}

test "0xE8 INX - Increment X Register with overflow" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0xFF, 0xAA, 0xE8, 0xE8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.register_X == 1);
}

test "loads 0xC0 into X and increments by 1" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0xC0, 0xAA, 0xE8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.register_X == 0xC1);
}

test "0x85 STA - Store Accumulator" {
    var mem = Memory.init(&[_]u8{ 0x85, 0x00 });
    var cpu = Cpu.init(&mem);
    cpu.register_A = 0xFF;

    cpu.interpret(&mem);

    try std.testing.expect(mem.memory[0] == 0xFF);
}
