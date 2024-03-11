const std = @import("std");
const messages = @import("./messages.zig");
const FlagsI = @import("./flags.zig");
const creation = @import("./creation.zig");
const get = @import("./get_commands.zig");
const util = @import("./utility.zig");
const mem = std.mem;

pub fn handle_commands(args: *const [][:0]u8) !void {
    if (mem.eql(u8, args.*[1], "get")) {
        try get.handle_get(args);
    } else if (mem.eql(u8, args.*[1], "publish")) {
        try publish(args);
    } else if (mem.eql(u8, args.*[1], "help")) {
        util.print("{s}", .{messages.help_message});
    } else if (mem.eql(u8, args.*[1], "new")) {
        // Need to parse what type of Package it is
        try creation.newCapsuleFile(args);
    } else if (mem.eql(u8, args.*[1], "init")) {
        try creation.initCapsuleFile();
    } else {}
}

fn publish(args: *const [][:0]u8) !void {
    util.print("{s}\n", .{args.*});
}

fn handle_output_name(ofp: FlagsI.output_flag_param) !void {
    util.print("{}\n", .{ofp});
    // return [:0]u8
}
