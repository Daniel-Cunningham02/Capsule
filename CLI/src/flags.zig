const general_flag_str = [_]u8{ 'v', 'o', 'h', 'd', 'l' };

// Pub structs
pub const output_flag_param = struct {
    output: bool,
    output_file: [:0]u8,
};

pub const general_flags = struct {
    verbose: bool,
    output: bool,
    hidden: bool,
    dll: bool,
    lib: bool,
};

pub const flags_bundle = struct {
    ofp: output_flag_param,
    flags: general_flags,
};

pub fn get_command_flags(flag_str: *[:0]u8) !general_flags {
    var slice = flag_str.*[1..flag_str.len :0];
    var flags: [general_flag_str.len]bool = undefined;
    for (flags, 0..) |_, i| {
        flags[i] = false;
    }
    for (general_flag_str, 0..) |x, i| {
        for (slice) |c| {
            if (x == lower(c)) {
                flags[i] = true;
            }
        }
    }

    return general_flags{ .verbose = flags[0], .output = flags[1], .hidden = flags[2], .dll = flags[3], .lib = flags[4] };
}

pub fn handle_flags(args: *const [][:0]u8) !flags_bundle {
    var counter: u32 = 3;
    const flags = try get_command_flags(&args.*[2]);
    var ofp: output_flag_param = undefined;

    //checking output flag and setting a struct correctly
    if (flags.output) {
        ofp = output_flag_param{ .output = true, .output_file = args.*[3] };
        counter += 1;
    } else {
        ofp = output_flag_param{ .output = false, .output_file = undefined };
    }

    return flags_bundle{ .ofp = ofp, .flags = flags };
}

fn lower(char: u8) u8 {
    if (char >= 65 and char <= 90) {
        return (char + 32);
    }
    return char;
}
