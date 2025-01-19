const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

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

    const ZERO_FLAG: u8 = 0b0000_0010;
    const NEGATIVE_FLAG: u8 = 0b1000_0000;

    const BRK = 0x00;
    const INX = 0xE8;
    const LDA = 0xA9;
    const TAX = 0xAA;

    pub fn interpret(self: *Cpu, program: []const u8) void {
        self.program_counter = 0;
        while (true) {
            const ops_code = program[self.program_counter];
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
                    self.register_A = program[self.program_counter];
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
    const test_allocator = std.testing.allocator;
    var program = std.ArrayList(u8).init(test_allocator);
    defer program.deinit();
    var cpu = Cpu.init();

    try program.appendSlice(&[_]u8{ 0xA9, 0x05, 0x00 });
    cpu.interpret(program.items);

    try std.testing.expect(cpu.register_A == 0x05);
    try std.testing.expect((cpu.status & 0b0000_0010) == 0);
    try std.testing.expect((cpu.status & 0b1000_0000) == 0);
}

test "0xAA TAX - Transfer Accumulator to X" {
    const test_allocator = std.testing.allocator;
    var program = std.ArrayList(u8).init(test_allocator);
    defer program.deinit();
    var cpu = Cpu.init();

    try program.appendSlice(&[_]u8{ 0xAA, 0x00 });
    cpu.register_A = 10;
    cpu.interpret(program.items);

    try std.testing.expect(cpu.register_X == 10);
    try std.testing.expect((cpu.status & 0b0000_0010) == 0);
    try std.testing.expect((cpu.status & 0b1000_0000) == 0);
}

test "INX - Increment X Register" {
    const test_allocator = std.testing.allocator;
    var program = std.ArrayList(u8).init(test_allocator);
    defer program.deinit();
    var cpu = Cpu.init();

    try program.appendSlice(&[_]u8{ 0xE8, 0x00 });
    cpu.interpret(program.items);

    try std.testing.expect(cpu.register_X == 1);
    try std.testing.expect((cpu.status & 0b0000_0010) == 0);
    try std.testing.expect((cpu.status & 0b1000_0000) == 0);
}

test "INX overflow" {
    const test_allocator = std.testing.allocator;
    var program = std.ArrayList(u8).init(test_allocator);
    defer program.deinit();
    var cpu = Cpu.init();

    cpu.register_X = 0xFF;
    try program.appendSlice(&[_]u8{ 0xE8, 0xE8, 0x00 });
    cpu.interpret(program.items);

    try std.testing.expect(cpu.register_X == 1);
}

test "loads 0xC0 into X and increments by 1" {
    const test_allocator = std.testing.allocator;
    var program = std.ArrayList(u8).init(test_allocator);
    defer program.deinit();
    var cpu = Cpu.init();

    try program.appendSlice(&[_]u8{ 0xA9, 0xC0, 0xAA, 0xE8, 0x00 });
    cpu.interpret(program.items);

    try std.testing.expect(cpu.register_X == 0xC1);
}
