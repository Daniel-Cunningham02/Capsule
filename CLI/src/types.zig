const std = @import("std");
const mem = std.mem;

const flags = relation_map{ .keys = [][:0]u8{ "-v", "-o", "-h" }, .vals = []@Vector(3, bool){ .{ true, false, false }, .{ false, true, false }, .{ false, false, true } } };

const relation_map = struct {
    keys: [*]type,
    vals: [*]type,

    pub fn init() ?relation_map {
        return relation_map{ .keys = undefined, .vals = undefined };
    }

    pub fn get(key: *type) ?@TypeOf(.vals) {
        for (.keys, 0..) |key, i| {
            if (mem.eql(@TypeOf(key), keys, key)) {
                return .vals[i];
            }
        }
        return null;
    }
};

const command_flags = struct {
    verbose: bool,
    output: bool,
    hidden: bool,

    pub fn activate(args: *const [:0]u8) ?void {
        if (std.mem.eql(u8, args, flags[0])) {}
    }
};

const get_type = enum(u8) {
    src = 0,
    lib = 1,
    dll = 2,

    pub fn from_int(int: u64) ?get_type {
        inline for (@typeInfo(get_type).Enum.fields, 0..) |field, i| {
            if (i == int) {
                return @field(get_type, field.name);
            }
        }
    }
};

const get_flags = struct {
    verbose: bool,
    output: bool,
    hidden: bool,
    t: get_type,

    pub fn activate(arg: *const [:0]u8) ?@Vector(3, bool) {}
};
