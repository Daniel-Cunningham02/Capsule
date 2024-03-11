const std = @import("std");
const messages = @import("messages.zig");
const types = @import("types.zig");
const process = std.ChildProcess;
const mem = std.mem;

const CapsuleObject = struct { name: []u8, file: []u8, dir: []u8, version: []u8, desc: []u8, dependencies: []u8 };

pub fn initCapsuleFile() !void {
    const result = try process.exec(.{
        .allocator = std.heap.page_allocator,
        .argv = &[_][]const u8{ "python3", "initialize.zip" },
    });
    try std.io.getStdOut().writer().print("{s}", .{result.stderr});
}

pub fn newCapsuleFile(args: *const [][:0]u8) !void {
    var stdout = std.io.getStdOut().writer();
    try stdout.print("{s}", .{args.*});
}
