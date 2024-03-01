const std = @import("std");
const mem = std.mem;

// verbose = explains steps, output = outputs to a specific folder, hidden = hides the dependencies in a temp

pub const dir = struct {
    files: [][:0]u8,
    filenames: [][:0]u8,
};
// Pub functions below here
