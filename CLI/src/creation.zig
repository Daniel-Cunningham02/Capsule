const std = @import("std");
const capsule = @import("capsule");
const e = capsule.Error;
const mem = std.mem;

const CapsuleObj = struct { name: []u8, file: []u8, dir: []u8, version: []u8, desc: []u8, dependencies: []u8 };

pub fn initCapsuleFile() e.SetupError!void {}

pub fn setup(args: *const [][:0]u8) !void {
    var mallocator = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        var status = mallocator.deinit();

        if (status == .leak) {
            @panic("Memory Leak");
        }
    }
    const allocator = mallocator.allocator();

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
