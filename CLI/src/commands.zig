const std = @import("std");
const messages = @import("./messages.zig");
const settings = @import("./settings.zig");
const capsule = @import("capsule");
const types = @import("./types.zig");
const c = @import("./creation.zig");
const get = @import("./get_commands.zig");
const http = std.http;
const mem = std.mem;
const print = std.debug.print;
const e = capsule.Error;

pub fn handle_commands(args: *const [][:0]u8) !void {
    if (mem.eql(u8, args.*[1], "get")) {
        try get.handle_get(args);
    } else if (mem.eql(u8, args.*[1], "publish")) {
        try publish(args);
    } else if (mem.eql(u8, args.*[1], "help")) {
        print("{s}", .{messages.help_message});
    } else if (mem.eql(u8, args.*[1], "new")) {
        try c.setup(args);
    } else if (mem.eql(u8, args.*[1], "init")) {} else {
        try c.initCapsuleFile();
    }
}

fn publish(args: *const [][:0]u8) !void {
    print("{s}", .{args});
}

fn handle_output_name(ofp: types.output_flag_param) !void {
    print("{}", .{ofp});
    // return [:0]u8
}

fn writeToFile(str: *[:0]u8, file_name: *[:0]u8) !void {
    print("{s} \n {s}", .{ str, file_name });
}
