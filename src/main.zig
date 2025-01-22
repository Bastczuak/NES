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
    decodingFn: *const fn (cpu: *Cpu, mem: *Memory, addressing_mode: AddressingMode) void,
    addressing_mode: AddressingMode,
};

const Instruction = struct { key: u8, value: OpCode };

const Instructions = [_]Instruction{
    Instruction{
        .key = 0x00,
        .value = OpCode{
            .mnemonic = "BRK",
            .addressing_mode = AddressingMode.None,
            .bytes = 1,
            .decodingFn = Cpu.brk,
        },
    },
    Instruction{
        .key = 0xE8,
        .value = OpCode{
            .mnemonic = "INX",
            .addressing_mode = AddressingMode.None,
            .bytes = 1,
            .decodingFn = Cpu.inx,
        },
    },
    Instruction{
        .key = 0xAA,
        .value = OpCode{
            .mnemonic = "TAX",
            .addressing_mode = AddressingMode.None,
            .bytes = 1,
            .decodingFn = Cpu.tax,
        },
    },
    Instruction{
        .key = 0xA9,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressing_mode = AddressingMode.Immediate,
            .bytes = 2,
            .decodingFn = Cpu.lda,
        },
    },
    Instruction{
        .key = 0xA5,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressing_mode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.lda,
        },
    },
    Instruction{
        .key = 0xB5,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressing_mode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.lda,
        },
    },
    Instruction{
        .key = 0xAD,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressing_mode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.lda,
        },
    },
    Instruction{
        .key = 0xBD,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressing_mode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.lda,
        },
    },
    Instruction{
        .key = 0xB9,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressing_mode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.lda,
        },
    },
    Instruction{
        .key = 0xA1,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressing_mode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.lda,
        },
    },
    Instruction{
        .key = 0xB1,
        .value = OpCode{
            .mnemonic = "LDA",
            .addressing_mode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.lda,
        },
    },
    Instruction{
        .key = 0x85,
        .value = OpCode{
            .mnemonic = "STA",
            .addressing_mode = AddressingMode.ZeroPage,
            .bytes = 2,
            .decodingFn = Cpu.sta,
        },
    },
    Instruction{
        .key = 0x95,
        .value = OpCode{
            .mnemonic = "STA",
            .addressing_mode = AddressingMode.ZeroPageX,
            .bytes = 2,
            .decodingFn = Cpu.sta,
        },
    },
    Instruction{
        .key = 0x8D,
        .value = OpCode{
            .mnemonic = "STA",
            .addressing_mode = AddressingMode.Absolute,
            .bytes = 3,
            .decodingFn = Cpu.sta,
        },
    },
    Instruction{
        .key = 0x9D,
        .value = OpCode{
            .mnemonic = "STA",
            .addressing_mode = AddressingMode.AbsoluteX,
            .bytes = 3,
            .decodingFn = Cpu.sta,
        },
    },
    Instruction{
        .key = 0x99,
        .value = OpCode{
            .mnemonic = "STA",
            .addressing_mode = AddressingMode.AbsoluteY,
            .bytes = 3,
            .decodingFn = Cpu.sta,
        },
    },
    Instruction{
        .key = 0x81,
        .value = OpCode{
            .mnemonic = "STA",
            .addressing_mode = AddressingMode.IndirectX,
            .bytes = 2,
            .decodingFn = Cpu.sta,
        },
    },
    Instruction{
        .key = 0x91,
        .value = OpCode{
            .mnemonic = "STA",
            .addressing_mode = AddressingMode.IndirectY,
            .bytes = 2,
            .decodingFn = Cpu.sta,
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
    const ZERO_FLAG: u8 = 0b0000_0010;
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

    pub fn brk(cpu: *Cpu, mem: *Memory, addressing_mode: AddressingMode) void {
        _ = mem;
        _ = addressing_mode;
        cpu.stop = true;
    }

    pub fn inx(cpu: *Cpu, mem: *Memory, addressing_mode: AddressingMode) void {
        _ = mem;
        _ = addressing_mode;
        cpu.register_X +%= 1;
        cpu.update_zero_and_negative_flag(&cpu.register_X);
    }

    pub fn tax(cpu: *Cpu, mem: *Memory, addressing_mode: AddressingMode) void {
        _ = mem;
        _ = addressing_mode;
        cpu.register_X = cpu.register_A;
        cpu.update_zero_and_negative_flag(&cpu.register_A);
    }

    pub fn lda(cpu: *Cpu, mem: *Memory, addressing_mode: AddressingMode) void {
        const address = cpu.next_address(mem, addressing_mode);
        cpu.register_A = mem.memory[address];
        cpu.update_zero_and_negative_flag(&cpu.register_A);
    }

    pub fn sta(cpu: *Cpu, mem: *Memory, addressing_mode: AddressingMode) void {
        const address = cpu.next_address(mem, addressing_mode);
        mem.memory[address] = cpu.register_A;
    }

    pub fn interpret(self: *Cpu, mem: *Memory) void {
        while (!self.stop) {
            const ops_code = mem.memory[self.program_counter];
            self.program_counter += 1;
            const program_counter_state = self.program_counter;

            const ins = get_instuction(ops_code);
            ins.value.decodingFn(self, mem, ins.value.addressing_mode);

            if (program_counter_state == self.program_counter) {
                self.program_counter += ins.value.bytes - 1;
            }
        }
    }

    pub fn next_address(self: *Cpu, mem: *Memory, addressing_mode: AddressingMode) u16 {
        var address: u16 = undefined;
        switch (addressing_mode) {
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

        if ((register.* & (1 << 7)) != 0) {
            self.status |= NEGATIVE_FLAG;
        } else {
            self.status &= ~NEGATIVE_FLAG;
        }
    }
};

pub fn main() !void {
    ray.InitWindow(400, 400, "NES");
    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        ray.EndDrawing();
    }

    ray.CloseWindow();
}

test "0xA9 LDA - Load Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x05, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.register_A == 0x05);
    try std.testing.expect((cpu.status & 0b0000_0010) == 0);
    try std.testing.expect((cpu.status & 0b1000_0000) == 0);
}

test "0xA5 LDA - Load Accumulator" {
    var mem = Memory.init(&[_]u8{ 0xA5, 0x10, 0x00 });
    mem.memory[0x10] = 0x55;
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.register_A == 0x55);
    try std.testing.expect((cpu.status & 0b0000_0010) == 0);
    try std.testing.expect((cpu.status & 0b1000_0000) == 0);
}

test "0xAA TAX - Transfer Accumulator to X" {
    var mem = Memory.init(&[_]u8{ 0xA9, 0x0A, 0xAA, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.register_X == 10);
    try std.testing.expect((cpu.status & 0b0000_0010) == 0);
    try std.testing.expect((cpu.status & 0b1000_0000) == 0);
}

test "0xE8 INX - Increment X Register" {
    var mem = Memory.init(&[_]u8{ 0xE8, 0x00 });
    var cpu = Cpu.init(&mem);

    cpu.interpret(&mem);

    try std.testing.expect(cpu.register_X == 1);
    try std.testing.expect((cpu.status & 0b0000_0010) == 0);
    try std.testing.expect((cpu.status & 0b1000_0000) == 0);
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
