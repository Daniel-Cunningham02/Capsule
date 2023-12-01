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

pub fn handle_flags(args: *const [][:0]u8) !void {
    var counter: u32 = 3;
    const flags = try types.get_command_flags(&args.*[2]);
    var ofp: types.output_flag_param = undefined;

    //checking output flag and setting a struct correctly
    if (flags.output) {
        ofp = types.output_flag_param{ .output = true, .output_file = args.*[3] };
        counter += 1;
    } else {
        ofp = types.output_flag_param{ .output = false, .output_file = undefined };
    }

    //checking for type of request.
    try get.execCommands(args, counter, flags, ofp);
}

pub fn writeToFile(str: *[:0]u8, file_name: *[:0]u8) !void {
    var file = try std.fs.cwd().createFile(file_name.*, std.fs.File.CreateFlags{});
    _ = try file.write(str.*);
}

pub fn readInputInto(src: []u8, dest: *[]u8, delimiter: u8) !void {
    var stdin = std.io.getStdIn().reader();
    if (try stdin.readUntilDelimiterOrEof(src, delimiter)) |value| {
        dest.* = value[0 .. value.len - 1];
    }
}
