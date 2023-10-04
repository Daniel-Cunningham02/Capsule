const std = @import("std");
const http = std.http;
const messages = @import("./messages.zig");
const mem = std.mem;
const settings = @import("./settings.zig");
const print = std.debug.print;
const capsule = @import("capsule");
const e = capsule.Error;

pub fn handle_commands(args: *const [][:0]u8) !void {
    if (mem.eql(u8, args.*[1], "get")) {
        try handle_get(args);
    } else if (mem.eql(u8, args.*[1], "publish")) {
        try publish(args);
    } else if (mem.eql(u8, args.*[1], "help")) {
        print("{s}", .{messages.help_message});
    } else if (mem.eql(u8, args.*[1], "new")) {
        try setup(args);
    } else if (mem.eql(u8, args.*[1], "init")) {} else {
        try initCapsuleFile();
    }
}

fn initCapsuleFile() e.SetupError!void {}

fn setup(args: *const [][:0]u8) !void {
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

fn handle_get(args: *const [][:0]u8) !void {
    if (args.len > 2 and mem.eql(u8, args.*[2], "-")) {
        try handle_flags(args);
    } else if (args.len > 2) {
        try download_src(&args.*[2]);
    } else {
        print("{s}", .{messages.get_usage_help});
    }
}

fn download_src(package: *[:0]u8) !void {
    var mallocator = std.heap.GeneralPurposeAllocator(.{}){};

    defer {
        var status = mallocator.deinit();

        if (status == .leak) {
            @panic("Memory Leak");
        }
    }
    const allocator = mallocator.allocator();
    var client: http.Client = .{ .allocator = allocator };

    var buffer = [_]u8{undefined} ** 100;
    const path = try std.fmt.bufPrint(&buffer, "/src?={s}", .{package.*});
    const uri = try std.Uri.parse(path);
    var req = try client.request(.GET, uri, .{ .allocator = allocator }, .{});
    defer req.deinit();
}

fn publish(args: *const [][:0]u8) !void {
    print("{s}", .{args.*[3]});
}

fn handle_flags(args: *const [][:0]u8) !void {
    print("{s}", .{args.*[3]});
}
