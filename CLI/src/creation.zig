const std = @import("std");
const messages = @import("messages.zig");
const types = @import("types.zig");
const mem = std.mem;

const CapsuleObject = struct { name: []u8, file: []u8, dir: []u8, version: []u8, desc: []u8, dependencies: []u8 };

pub fn initCapsuleFile() !void {
    const result = std.process.execv(
        std.heap.page_allocator,
        &[_][]const u8{ "python3", "initialize.zip" },
    );
    try std.io.getStdOut().writer().print("{}", .{result});
}

pub fn newCapsuleFile(args: *const [][:0]u8) !void {
    var stdout = std.io.getStdOut().writer();
    try stdout.print("{s}", .{args.*});
}
