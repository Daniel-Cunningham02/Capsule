const std = @import("std");
const messages = @import("./messages.zig");
const settings = @import("./settings.zig");
const FlagsI = @import("./flags.zig");
const http = std.http;
const print = std.debug.print;

pub fn handle_get(args: *const [][:0]u8) !void {
    const dash: u8 = '-';
    if (args.len > 2) {
        const slice: u8 = args.*[2][0];
        if (slice == dash) {
            try FlagsI.handle_flags(args);
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

fn download_src(package: *[:0]u8, verbose: bool, ofp: FlagsI.output_flag_param, hidden: bool) !void {
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
    try buffer.resize(1000000);
    var readSize = try req.read(buffer.items);
    var parsed_dir = try std.json.parseFromSlice(FlagsI.dir, mallocator, buffer.items[0..readSize], .{});

    var decoder = std.base64.Base64Decoder.init(std.fs.base64_alphabet, '=');
    var decoded_buffer = std.ArrayList(u8).init(mallocator);
    defer decoded_buffer.deinit();

    try std.fs.cwd().makeDir(package.*);
    var dir = try std.fs.cwd().openDir(package.*, std.fs.Dir.OpenDirOptions{});
    for (parsed_dir.value.files, 0..) |string, i| {
        try decoded_buffer.resize(try decoder.calcSizeForSlice(string));
        try decoder.decode(decoded_buffer.items, string);
        var name = parsed_dir.value.filenames[i];
        var file = try dir.createFile(try std.fmt.allocPrint(mallocator, "./{s}", .{name}), std.fs.File.CreateFlags{});
        _ = try file.write(decoded_buffer.items);
        file.close();
        decoded_buffer.clearAndFree();
    }
    dir.close();
    return;
}

fn download_lib(package: *[:0]u8, verbose: bool, ofp: FlagsI.output_flag_param, hidden: bool) !void {
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

fn download_dll(package: *[:0]u8, verbose: bool, ofp: FlagsI.output_flag_param, hidden: bool) !void {
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
