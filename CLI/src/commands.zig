const std = @import("std");
const messages = @import("./messages.zig");
const FlagsI = @import("./flags.zig");
const c = @import("./creation.zig");
const get = @import("./get_commands.zig");
const mem = std.mem;
const print = std.debug.print;

pub fn handle_commands(args: *const [][:0]u8) !void {
    if (mem.eql(u8, args.*[1], "get")) {
        try get.handle_get(args);
    } else if (mem.eql(u8, args.*[1], "publish")) {
        try publish(args);
    } else if (mem.eql(u8, args.*[1], "help")) {
        print("{s}", .{messages.help_message});
    } else if (mem.eql(u8, args.*[1], "new")) {
        // Need to parse what type of Package it is
        try c.newCapsuleFile(args);
    } else if (mem.eql(u8, args.*[1], "init")) {
        try c.initCapsuleFile();
    } else {}
}

fn publish(args: *const [][:0]u8) !void {
    print("{s}", .{args});
}

fn handle_output_name(ofp: FlagsI.output_flag_param) !void {
    print("{}", .{ofp});
    // return [:0]u8
}
