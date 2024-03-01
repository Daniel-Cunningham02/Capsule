const std = @import("std");
const capsule = @import("capsule");
const messages = @import("messages.zig");
const util = @import("utility.zig");
const types = @import("types.zig");
const process = std.ChildProcess;
const e = capsule.Error;
const mem = std.mem;

const CapsuleObject = struct { name: []u8, file: []u8, dir: []u8, version: []u8, desc: []u8, dependencies: []u8 };

pub fn initCapsuleFile() !void {
    const result = try process.exec(.{
        .allocator = std.heap.page_allocator,
        .argv = &[_][]const u8{ "python3", "initialize.zip" },
    });
    try std.io.getStdOut().writer().print("{s}", .{result.stderr});
}

fn cloneString(stringToClone: []const u8) ![]const u8 {
    //Create Signature for now. Working on it later
    std.debug.print("{s}\n", .{stringToClone});
    return stringToClone;
}

pub fn newCapsuleFile(args: *const [][:0]u8) !void {
    var stdout = std.io.getStdOut().writer();
    try stdout.print("{s}", .{args.*});
}

fn createFolder(folder_name: *[]u8, charArray: *std.ArrayList(u8)) !void {
    try std.fs.cwd().makeDir(folder_name.*);
    charArray.clearAndFree();
    //const stdin = std.io.getStdIn();
    // Read in input and store in array list as a u8 array.
}
