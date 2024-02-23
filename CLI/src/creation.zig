const std = @import("std");
const capsule = @import("capsule");
const messages = @import("messages.zig");
const util = @import("utility.zig");
const types = @import("types.zig");
const e = capsule.Error;
const mem = std.mem;

const CapsuleObject = struct { name: []u8, file: []u8, dir: []u8, version: []u8, desc: []u8, dependencies: []u8 };

pub fn initCapsuleFile() !void {
    var allocator = std.heap.page_allocator;
    var buffer = std.ArrayList(u8).init(allocator);
    try buffer.resize(100);
    defer buffer.deinit();

    var capsuleObj = CapsuleObject{ .name = "", .file = "", .dir = "", .version = "", .desc = "", .dependencies = "" };

    var stdout = std.io.getStdOut().writer();

    try stdout.print("{s} ", .{messages.name_prompt});
    try util.readInputInto(buffer.items, &capsuleObj.name, '\n');

    try stdout.print("{s} \n", .{messages.file_prompt});
    try selectFiles();
    buffer.clearAndFree();
}

fn selectFiles() !void { // Return types.dir
    var cwd = try std.fs.cwd().openIterableDir(".", .{});

    var allocator = std.heap.page_allocator;
    var arr = std.ArrayList(types.selectionStruct).init(allocator);

    var iterator = cwd.iterate();
    while (try iterator.next()) |ientry| {
        try arr.append(types.selectionStruct{ .entry = ientry.name, .selected = false });
    }
    // TODO: setup selection menu.
}

fn cloneString(stringToClone: []const u8) ![]const u8 {
    //Create Signature for now. Working on it later
    std.debug.print("{s}\n", .{stringToClone});
    return stringToClone;
}

pub fn newCapsuleFile(args: *const [][:0]u8) !void {}

fn createFolder(folder_name: *[]u8, charArray: *std.ArrayList(u8)) !void {
    try std.fs.cwd().makeDir(folder_name.*);
    charArray.clearAndFree();
    //const stdin = std.io.getStdIn();
    // Read in input and store in array list as a u8 array.
}
