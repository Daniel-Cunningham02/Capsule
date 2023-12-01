const std = @import("std");
const messages = @import("./messages.zig");
const settings = @import("./settings.zig");
const types = @import("./types.zig");
const util = @import("./utility.zig");
const http = std.http;
const print = std.debug.print;

pub fn handle_get(args: *const [][:0]u8) !void {
    const dash: u8 = '-';
    if (args.len > 2) {
        const slice: u8 = args.*[2][0];
        if (slice == dash) {
            try util.handle_flags(args);
            return;
        }
        try download_src(&args.*[2], false, undefined, false);
    } else {
        print("{s}", .{messages.get_usage_help});
    }
}

pub fn execCommands(args: *const [][:0]u8, counter: u32, flags: types.general_flags, ofp: types.output_flag_param) !void {
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

fn download_src(package: *[:0]u8, verbose: bool, ofp: types.output_flag_param, hidden: bool) !void {
    var mallocator = std.heap.page_allocator;
    print("{} {} {}\n", .{ verbose, ofp, hidden });

    var client: http.Client = .{ .allocator = mallocator };
    const path = try std.fmt.allocPrint(mallocator, "{s}/src/{s}", .{ settings.address, package.* });
    defer mallocator.free(path);
    const uri = try std.Uri.parse(path);
    var req = try client.request(.GET, uri, .{ .allocator = mallocator }, .{});
    defer req.deinit();
    try req.start();
    try req.wait();

    // Reading response to buffer and writing to file
    var buffer = std.ArrayList(u8).init(mallocator);
    defer buffer.deinit();
    try buffer.resize(100000);
    var readSize = try req.read(buffer.items);
    var file = try std.fs.cwd().createFile(try std.fmt.allocPrint(mallocator, "./{s}.zig", .{package.*}), std.fs.File.CreateFlags{});
    _ = try file.write(buffer.items[0..readSize]);
    var parsed_dir = try std.json.parseFromSlice(types.dir, mallocator, buffer.items[0..readSize], .{});

    var decoder = std.base64.Base64Decoder.init(std.fs.base64_alphabet, '=');
    var decoded_buffer = std.ArrayList(u8).init(mallocator);
    defer decoded_buffer.deinit();
    try decoded_buffer.resize(try decoder.calcSizeForSlice(parsed_dir.value.files[0]));
    try decoder.decode(decoded_buffer.items, parsed_dir.value.files[0][0 .. parsed_dir.value.files[0].len - 1]);
    // print("{s}", .{decoded_buffer.items[0..]});

    // print("{any}", .{parsed_dir.value.files});

    return;
}

fn download_lib(package: *[:0]u8, verbose: bool, ofp: types.output_flag_param, hidden: bool) !void {
    // Making Allocator
    var mallocator = std.heap.page_allocator;
    print("{} {} {}\n", .{ verbose, ofp, hidden });

    // Making client
    var client: http.Client = .{ .allocator = mallocator };

    //creating path and Uri
    const path = try std.fmt.allocPrint(mallocator, "{s}/lib/{s}", .{ settings.address, package.* });
    const uri = try std.Uri.parse(path);
    defer mallocator.free(path);

    // Creating and sending request
    var req = try client.request(.GET, uri, .{ .allocator = mallocator }, .{});
    defer req.deinit();
    try req.start();
    try req.wait();

    // Reading response to buffer and writing to file
    var buffer = std.ArrayList(u8).init(mallocator);
    try buffer.resize(100000);
    var readSize = try req.read(buffer.items);
    var file = try std.fs.cwd().createFile(try std.fmt.allocPrint(mallocator, "./{s}.lib", .{package.*}), std.fs.File.CreateFlags{});
    _ = try file.write(buffer.items[0..readSize]);
    return;
}

fn download_dll(package: *[:0]u8, verbose: bool, ofp: types.output_flag_param, hidden: bool) !void {
    // Making Allocator
    var mallocator = std.heap.page_allocator;
    print("{} {} {}\n", .{ verbose, ofp, hidden });

    // Making client
    var client: http.Client = .{ .allocator = mallocator };

    //creating path and Uri
    const path = try std.fmt.allocPrint(mallocator, "{s}/dll/{s}", .{ settings.address, package.* });
    const uri = try std.Uri.parse(path);
    defer mallocator.free(path);

    // Creating and sending request
    var req = try client.request(.GET, uri, .{ .allocator = mallocator }, .{});
    defer req.deinit();
    try req.start();
    try req.wait();

    var buffer = std.ArrayList(u8).init(mallocator);
    try buffer.resize(100000);
    var readSize = try req.read(buffer.items);
    var file = try std.fs.cwd().createFile(try std.fmt.allocPrint(mallocator, "./{s}.dll", .{package.*}), std.fs.File.CreateFlags{});
    _ = try file.write(buffer.items[0..readSize]);
    return;
}
