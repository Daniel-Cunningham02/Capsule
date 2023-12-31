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
    // var stdout = std.io.getStdOut().writer();
    var cwd = try std.fs.cwd().openIterableDir(".", std.fs.Dir.OpenDirOptions{});

    var allocator = std.heap.page_allocator;
    var arr = std.ArrayList([]types.selectionStruct).init(allocator);
    var walker = try cwd.walk(allocator);
    defer walker.deinit();
    // TODO: Get the contents from the files into the array and setup selection menu.
}

fn cloneString(stringToClone: []const u8) ![]const u8 {
    //Create Signature for now. Working on it later
    std.debug.print("{s}\n", .{stringToClone});
    return stringToClone;
}

pub fn setup(args: *const [][:0]u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        var status = gpa.deinit();

        if (status == .leak) {
            @panic("Memory Leak");
        }
    }
    const allocator = gpa.allocator();

    var charArray = std.ArrayList(u8).init(allocator);
    defer charArray.deinit();

    if (args.len > 2) {
        if (!mem.eql(u8, args.*[2], "-")) {
            for (args.*[2]) |c| {
                try charArray.append(c);
            }
        }
    }
    try createFolder(&charArray.items, &charArray);
}

fn createFolder(folder_name: *[]u8, charArray: *std.ArrayList(u8)) !void {
    try std.fs.cwd().makeDir(folder_name.*);
    charArray.clearAndFree();
    //const stdin = std.io.getStdIn();
    // Read in input and store in array list as a u8 array.
}
