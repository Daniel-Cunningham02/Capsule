const std = @import("std");
const messages = @import("./messages.zig");
const settings = @import("./settings.zig");
const FlagsI = @import("./flags.zig");
const types = @import("./types.zig");
const http = std.http;
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const Dir = std.fs.Dir;

const bufferHolder = struct {
    buffer: std.ArrayList(u8),
    size: usize,

    fn deinit(self: *bufferHolder) void {
        self.buffer.deinit();
    }

    fn getContents(self: *bufferHolder) ![]u8 {
        return self.buffer.items[0..self.size];
    }
};

pub fn handle_get(args: *const [][:0]u8) !void {
    const dash: u8 = '-';
    var flagbundle: FlagsI.flags_bundle = undefined;
    if (args.len > 2) {
        const slice: u8 = args.*[2][0];
        if (slice == dash) {
            flagbundle = try FlagsI.handle_flags(args);
            try execCommands(args, flagbundle.counter, flagbundle.flags, flagbundle.ofp);
            return;
        }
        try download_src(&args.*[2], false, undefined, false);
    } else {
        print("{s}", .{messages.get_usage_help});
    }
}

pub fn execCommands(args: *const [][:0]u8, counter: u32, flags: FlagsI.general_flags, ofp: FlagsI.output_flag_param) !void {
    if (flags.dll == true and flags.lib == false) {
        try download_dll(&args.*[counter], flags.verbose, ofp, flags.hidden);
    } else if (flags.dll == false and flags.lib == true) {
        try download_lib(&args.*[counter], flags.verbose, ofp, flags.hidden);
    } else if (flags.dll == false and flags.lib == false) {
        try download_src(&args.*[counter], flags.verbose, ofp, flags.hidden);
    } else {
        try download_dll(&args.*[counter], flags.verbose, ofp, flags.hidden);
        try download_lib(&args.*[counter], flags.verbose, ofp, flags.hidden);
    }
}

// Struct {buffer, size}
fn sendRequest(requestPath: []u8, allocator: *Allocator) !bufferHolder {
    const deref_alloc = allocator.*;
    var client: http.Client = .{ .allocator = deref_alloc };
    const uri = try std.Uri.parse(requestPath);
    var req = try client.request(.GET, uri, .{ .allocator = deref_alloc }, .{});
    defer req.deinit();
    try req.start();
    try req.wait();

    var buffer = std.ArrayList(u8).init(deref_alloc);
    try buffer.resize(1000000);
    var readSize = try req.read(buffer.items);
    return bufferHolder{ .buffer = buffer, .size = readSize };
}

fn download_src(package: *[:0]u8, verbose: bool, ofp: FlagsI.output_flag_param, hidden: bool) !void {
    var allocator = std.heap.page_allocator;
    print("{} {} {}\n", .{ verbose, ofp, hidden });

    const path = try std.fmt.allocPrint(allocator, "{s}/src/{s}", .{ settings.address, package.* });
    defer allocator.free(path);

    var bufStruct = try sendRequest(path, &allocator);
    defer bufStruct.deinit();
    const contents = try bufStruct.getContents();
    var parsed_dir = try std.json.parseFromSlice(types.dir, allocator, contents, .{});

    const decoder = std.base64.Base64Decoder.init(std.fs.base64_alphabet, '=');
    var decoded_buffer = std.ArrayList(u8).init(allocator);
    defer decoded_buffer.deinit();

    try std.fs.cwd().makeDir(package.*);
    var dir = try std.fs.cwd().openDir(package.*, std.fs.Dir.OpenDirOptions{});
    for (parsed_dir.value.files, 0..) |string, i| {
        try decoded_buffer.resize(try decoder.calcSizeForSlice(string));
        try decoder.decode(decoded_buffer.items, string);
        var name = parsed_dir.value.filenames[i];
        try writeToFile(dir, &decoded_buffer.items, try std.fmt.allocPrint(allocator, "./{s}", .{name}));
        // var file = try dir.createFile(try std.fmt.allocPrint(allocator, "./{s}", .{name}), std.fs.File.CreateFlags{});
        // _ = try file.write(decoded_buffer.items);
        // file.close();
        decoded_buffer.clearAndFree();
    }
    dir.close();
    return;
}

fn download_lib(package: *[:0]u8, verbose: bool, ofp: FlagsI.output_flag_param, hidden: bool) !void {
    // Making Allocator
    var allocator = std.heap.page_allocator;
    print("{} {} {}\n", .{ verbose, ofp, hidden });

    //creating path
    const path = try std.fmt.allocPrint(allocator, "{s}/lib/{s}", .{ settings.address, package.* });
    // Creating and sending request
    var bufStruct = try sendRequest(path, &allocator);
    defer bufStruct.deinit();

    const contents = try bufStruct.getContents();
    try writeToFile(std.fs.cwd(), &contents, try std.fmt.allocPrint(allocator, "./{s}.lib", .{package.ptr}));
    return;
}

fn download_dll(package: *[:0]u8, verbose: bool, ofp: FlagsI.output_flag_param, hidden: bool) !void {
    // Making Allocator
    var allocator = std.heap.page_allocator;
    print("{} {} {}\n", .{ verbose, ofp, hidden });

    //creating path and Uri
    const path = try std.fmt.allocPrint(allocator, "{s}/dll/{s}", .{ settings.address, package.* });
    var bufStruct = try sendRequest(path, &allocator);
    const contents = try bufStruct.getContents();

    try writeToFile(std.fs.cwd(), &contents, try std.fmt.allocPrint(allocator, "./{s}.dll", .{package.ptr}));
    return;
}

fn writeToFile(dir: Dir, str: *const []u8, file_name: []u8) !void {
    var file = try dir.createFile(file_name, std.fs.File.CreateFlags{});
    _ = try file.write(str.*);
    file.close();
}
