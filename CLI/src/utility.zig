const std = @import("std");

pub inline fn print(format: []const u8, args: anytype) void {
    std.io.getStdOut().writer().print(format, args) catch unreachable;
}

pub fn readInputInto(src: []u8, dest: *[]u8, delimiter: u8) !void {
    var stdin = std.io.getStdIn().reader();
    if (try stdin.readUntilDelimiterOrEof(src, delimiter)) |value| {
        dest.* = value[0 .. value.len - 1];
    }
}
