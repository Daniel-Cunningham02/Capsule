const std = @import("std");
const FlagsI = @import("./flags.zig");
const c = @import("./creation.zig");
const get = @import("./get_commands.zig");

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
