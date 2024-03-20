const util = @import("./utility.zig");

// Public functions
pub fn publish(args: *const [][:0]u8) !void {
    util.print("{s}", .{args});
}

// private
