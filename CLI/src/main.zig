const std = @import("std");
const messages = @import("./messages.zig");
const commands = @import("./commands.zig");
const print = std.debug.print;

pub fn main() !void {
    // Get the Command line arguments
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len < 2) {
        print("{s}\n{s}", .{ messages.usage_message, messages.usage_help });
        return;
    }

    try commands.handle_commands(&args);
}

test "simple test" {}
