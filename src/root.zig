const std: type = @import("std");
const c: type = @import("c_time_header");

pub const clocks_per_sec: i32 = @intCast(c.CLOCKS_PER_SEC);

pub const DateTime: type = struct {
    sec: u6 = 0,
    min: u6 = 0,
    hour: u5 = 0,
    mday: u5 = 0,
    mon: u4 = 0,
    year: i32 = 0,
    wday: u3 = 0,
    yday: u9 = 0,
    isdst: i32 = 0,
};

pub fn ascTime(datetime: DateTime) []const u8 {
    const tm: c.struct_tm = dateTimeToTm(datetime);

    return std.mem.span(c.asctime(&tm));
}

pub fn ascTimeTS(datetime: DateTime, buf: []u8) ![]u8 {
    const fmt = "%a %b %e %H:%M:%S %Y\n";

    return strFormatTime(fmt, datetime, buf);
}

pub fn clock() i32 {
    return @intCast(c.clock());
}

pub fn cTime(t: i64) []const u8 {
    const casted_t: c.time_t = @intCast(t);

    return std.mem.span(c.ctime(&casted_t));
}

pub fn cTimeTS(t: i64, buf: []u8) ![]u8 {
    const fmt = "%a %b %e %H:%M:%S %Y\n";
    const datetime: DateTime = try localTimeTS(t);

    return strFormatTime(fmt, datetime, buf);
}

pub fn diffTime(t1: i64, t2: i64) f64 {
    return c.difftime(@intCast(t1), @intCast(t2));
}

pub fn gmTime(t: i64) DateTime {
    const casted_t: c.time_t = @intCast(t);
    const tm: [*c]c.struct_tm = c.gmtime(&casted_t);

    return tmToDateTime(tm.*);
}

pub fn gmTimeTS(t: i64) !DateTime {
    var tm: c.struct_tm = c.struct_tm{};

    if (@hasDecl(c, "_gmtime64_s")) {
        const casted_t: c.__time64_t = @intCast(t);

        if (c._gmtime64_s(&tm, &casted_t) != 0) {
            return error.TimeConversionFailed;
        }

        return tmToDateTime(tm);
    }

    const casted_t: c.time_t = @intCast(t);

    if (c.gmtime_r(&casted_t, &tm) == null) {
        return error.TimeConversionFailed;
    }

    return tmToDateTime(tm);
}

pub fn localTime(t: i64) DateTime {
    const casted_t: c.time_t = @intCast(t);
    const tm: [*c]c.struct_tm = c.localtime(&casted_t);

    return tmToDateTime(tm.*);
}

pub fn localTimeTS(t: i64) !DateTime {
    var tm: c.struct_tm = c.struct_tm{};

    if (@hasDecl(c, "_localtime64_s")) {
        const casted_t: c.__time64_t = @intCast(t);

        if (c._localtime64_s(&tm, &casted_t) != 0) {
            return error.InvalidTime;
        }

        return tmToDateTime(tm);
    }

    const casted_t: c.time_t = @intCast(t);

    if (c.localtime_r(&casted_t, &tm) == null) {
        return error.InvalidTime;
    }

    return tmToDateTime(tm);
}

pub fn mkTime(datetime: *DateTime) i64 {
    var tm: c.struct_tm = dateTimeToTm(datetime.*);
    const return_value: i64 = @intCast(c.mktime(&tm));

    datetime.* = tmToDateTime(tm);

    return return_value;
}

pub fn strFormatTime(format: []const u8, datetime: DateTime, buf: []u8) ![]u8 {
    const tm: c.struct_tm = dateTimeToTm(datetime);
    const bytes_written: usize = c.strftime(buf.ptr, buf.len, format.ptr, &tm);

    if (bytes_written == 0) {
        return error.BufferTooSmall;
    }

    return buf[0..bytes_written];
}

pub fn time() i64 {
    return @intCast(c.time(null));
}

fn tmToDateTime(tm: c.struct_tm) DateTime {
    return DateTime{
        .sec = @intCast(tm.tm_sec),
        .min = @intCast(tm.tm_min),
        .hour = @intCast(tm.tm_hour),
        .mday = @intCast(tm.tm_mday),
        .mon = @intCast(tm.tm_mon),
        .year = @intCast(tm.tm_year),
        .wday = @intCast(tm.tm_wday),
        .yday = @intCast(tm.tm_yday),
        .isdst = @intCast(tm.tm_isdst),
    };
}

fn dateTimeToTm(datetime: DateTime) c.struct_tm {
    return c.struct_tm{
        .tm_sec = @intCast(datetime.sec),
        .tm_min = @intCast(datetime.min),
        .tm_hour = @intCast(datetime.hour),
        .tm_mday = @intCast(datetime.mday),
        .tm_mon = @intCast(datetime.mon),
        .tm_year = @intCast(datetime.year),
        .tm_wday = @intCast(datetime.wday),
        .tm_yday = @intCast(datetime.yday),
        .tm_isdst = @intCast(datetime.isdst),
    };
}
