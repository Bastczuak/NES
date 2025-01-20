const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

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
    program_counter: u16,
    status: u8,
    register_A: u8, // a.k.a acumulator
    register_X: u8,

    pub fn init() Cpu {
        return Cpu{
            .program_counter = 0,
            .status = 0,
            .register_A = 0,
            .register_X = 0,
        };
    }

    pub fn reset(self: *Cpu, mem: *Memory) void {
        self.program_counter = mem.read_u16(Memory.ROM_PROGRAM_START);
        self.status = 0;
        self.register_A = 0;
        self.register_X = 0;
    }

    const ZERO_FLAG: u8 = 0b0000_0010;
    const NEGATIVE_FLAG: u8 = 0b1000_0000;

    const BRK = 0x00;
    const INX = 0xE8;
    const LDA = 0xA9;
    const TAX = 0xAA;

    pub fn interpret(self: *Cpu, memory: Memory) void {
        while (true) {
            const ops_code = memory.memory[self.program_counter];
            self.program_counter += 1;

            switch (ops_code) {
                BRK => {
                    return;
                },
                INX => {
                    self.register_X +%= 1;
                    self.update_zero_and_negative_flag(&self.register_X);
                },
                LDA => {
                    self.register_A = memory.memory[self.program_counter];
                    self.program_counter += 1;
                    self.update_zero_and_negative_flag(&self.register_A);
                },
                TAX => {
                    self.register_X = self.register_A;
                    self.update_zero_and_negative_flag(&self.register_A);
                },
                else => std.debug.print("todo", .{}),
            }
        }
    }

    fn update_zero_and_negative_flag(self: *Cpu, register: *const u8) void {
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

pub fn load_and_run_program(cpu: *Cpu, program: []const u8) Memory {
    var mem = Memory.init(program);
    cpu.reset(&mem);
    cpu.interpret(mem);

    return mem;
}

pub fn main() !void {
    var mem = Memory.init(&[_]u8{ 0x01, 0x02 });
    mem.write_u16(0, 0x8000);
    std.debug.print("foo 0x{X}", .{mem.read_u16(0)});

    ray.InitWindow(400, 400, "NES");
    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        ray.EndDrawing();
    }

    ray.CloseWindow();
}

test "0xA9 LDA - Load Accumulator" {
    var cpu = Cpu.init();

    _ = load_and_run_program(&cpu, &[_]u8{ 0xA9, 0x05, 0x00 });

    try std.testing.expect(cpu.register_A == 0x05);
    try std.testing.expect((cpu.status & 0b0000_0010) == 0);
    try std.testing.expect((cpu.status & 0b1000_0000) == 0);
}

test "0xAA TAX - Transfer Accumulator to X" {
    var cpu = Cpu.init();

    _ = load_and_run_program(&cpu, &[_]u8{ 0xA9, 0x0A, 0xAA, 0x00 });

    try std.testing.expect(cpu.register_X == 10);
    try std.testing.expect((cpu.status & 0b0000_0010) == 0);
    try std.testing.expect((cpu.status & 0b1000_0000) == 0);
}

test "0xE8 INX - Increment X Register" {
    var cpu = Cpu.init();

    _ = load_and_run_program(&cpu, &[_]u8{ 0xE8, 0x00 });

    try std.testing.expect(cpu.register_X == 1);
    try std.testing.expect((cpu.status & 0b0000_0010) == 0);
    try std.testing.expect((cpu.status & 0b1000_0000) == 0);
}

test "0xE8 INX overflow" {
    var cpu = Cpu.init();

    _ = load_and_run_program(&cpu, &[_]u8{ 0xA9, 0xFF, 0xAA, 0xE8, 0xE8, 0x00 });

    try std.testing.expect(cpu.register_X == 1);
}

test "loads 0xC0 into X and increments by 1" {
    var cpu = Cpu.init();

    _ = load_and_run_program(&cpu, &[_]u8{ 0xA9, 0xC0, 0xAA, 0xE8, 0x00 });

    try std.testing.expect(cpu.register_X == 0xC1);
}
