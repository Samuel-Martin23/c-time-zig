const std: type = @import("std");

const cdef: type = @import("c_time_header");

pub const clocks_per_sec: i32 = @intCast(cdef.CLOCKS_PER_SEC);

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

pub fn ascTime(date_time: DateTime) ?[]u8 {
    const tm: cdef.struct_tm = tmFromDateTime(&date_time);
    const s: [*c]u8 = cdef.asctime(&tm);

    if (s == null) {
        return null;
    }

    return std.mem.span(s);
}

pub fn ascTimeTS(buf: []u8, date_time: DateTime) ?[]u8 {
    return strFmtTime(buf, "%a %b %e %H:%M:%S %Y\n", date_time);
}

pub fn clock() i32 {
    return @intCast(cdef.clock());
}

pub fn cTime(t: i64) ?[]u8 {
    const casted_t: cdef.time_t = @intCast(t);
    const s: [*c]u8 = cdef.ctime(&casted_t);

    if (s == null) {
        return null;
    }

    return std.mem.span(s);
}

pub fn cTimeTS(buf: []u8, t: i64) ?[]u8 {
    const date_time: DateTime = localTimeTS(t) orelse return null;
    return strFmtTime(buf, "%a %b %e %H:%M:%S %Y\n", date_time);
}

pub fn diffTime(t1: i64, t2: i64) f64 {
    return cdef.difftime(@intCast(t1), @intCast(t2));
}

pub fn gmTime(t: i64) ?DateTime {
    const casted_t: cdef.time_t = @intCast(t);
    const tm: [*c]cdef.struct_tm = cdef.gmtime(&casted_t);

    if (tm == null) {
        return null;
    }

    return dateTimeFromTm(@ptrCast(tm));
}

pub fn gmTimeTS(t: i64) ?DateTime {
    var tm: cdef.struct_tm = cdef.struct_tm{};

    if (@hasDecl(cdef, "_gmtime64_s")) {
        const casted_t: cdef.__time64_t = @intCast(t);

        if (cdef._gmtime64_s(&tm, &casted_t) != 0) {
            return null;
        }

        return dateTimeFromTm(&tm);
    }

    const casted_t: cdef.time_t = @intCast(t);

    if (cdef.gmtime_r(&casted_t, &tm) == null) {
        return null;
    }

    return dateTimeFromTm(&tm);
}

pub fn localTime(t: i64) ?DateTime {
    const casted_t: cdef.time_t = @intCast(t);
    const tm: [*c]cdef.struct_tm = cdef.localtime(&casted_t);

    if (tm == null) {
        return null;
    }

    return dateTimeFromTm(@ptrCast(tm));
}

pub fn localTimeTS(t: i64) ?DateTime {
    var tm: cdef.struct_tm = cdef.struct_tm{};

    if (@hasDecl(cdef, "_localtime64_s")) {
        const casted_t: cdef.__time64_t = @intCast(t);

        if (cdef._localtime64_s(&tm, &casted_t) != 0) {
            return null;
        }

        return dateTimeFromTm(&tm);
    }

    const casted_t: cdef.time_t = @intCast(t);

    if (cdef.localtime_r(&casted_t, &tm) == null) {
        return null;
    }

    return dateTimeFromTm(&tm);
}

pub fn mkTime(date_time: *DateTime) i64 {
    var tm: cdef.struct_tm = tmFromDateTime(date_time);
    const return_value: i64 = @intCast(cdef.mktime(&tm));

    date_time.* = dateTimeFromTm(&tm);

    return return_value;
}

pub fn strFmtTime(buf: []u8, format: []const u8, date_time: DateTime) ?[]u8 {
    const tm: cdef.struct_tm = tmFromDateTime(&date_time);
    const bytes_written: usize = cdef.strftime(buf.ptr, buf.len, format.ptr, &tm);

    if (bytes_written == 0) {
        return null;
    }

    return buf[0..bytes_written];
}

pub fn time() i64 {
    return @intCast(cdef.time(null));
}

fn dateTimeFromTm(tm: *const cdef.struct_tm) DateTime {
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

fn tmFromDateTime(date_time: *const DateTime) cdef.struct_tm {
    return cdef.struct_tm{
        .tm_sec = @intCast(date_time.sec),
        .tm_min = @intCast(date_time.min),
        .tm_hour = @intCast(date_time.hour),
        .tm_mday = @intCast(date_time.mday),
        .tm_mon = @intCast(date_time.mon),
        .tm_year = @intCast(date_time.year),
        .tm_wday = @intCast(date_time.wday),
        .tm_yday = @intCast(date_time.yday),
        .tm_isdst = @intCast(date_time.isdst),
    };
}
