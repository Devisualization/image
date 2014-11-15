module devisualization.image.png.writer_chunks;
import devisualization.image.png.defs;
import devisualization.image.png.write;
import std.bitmanip : nativeToBigEndian;

void write_IHDR(PngImage image, ref ubyte[] ret) {
    ubyte[] data;

    data ~= nativeToBigEndian!uint(image.IHDR.width);
    data ~= nativeToBigEndian!uint(image.IHDR.height);
    data ~= cast(ubyte)image.IHDR.bitDepth;
    data ~= cast(ubyte)image.IHDR.colorType;
    data ~= cast(ubyte)image.IHDR.compressionMethod;
    data ~= cast(ubyte)image.IHDR.filterMethod;
    data ~= cast(ubyte)image.IHDR.interlaceMethod;

    writeChunk("IHDR", data, ret);
}

void write_PLTE(PngImage image, ref ubyte[] ret) {
    if (image.PLTE is null) return;
    ubyte[] data;

    foreach(color; image.PLTE.colors) {
        data ~= color.r;
        data ~= color.g;
        data ~= color.b;
    }

    writeChunk("PLTE", data, ret);
}

void write_BKGD(PngImage image, ref ubyte[] ret) {
    // TODO: waiting on loader
}

void write_cHRM(PngImage image, ref ubyte[] ret) {
    if (image.cHRM is null) return;
    ubyte[] data;
    
    data ~= nativeToBigEndian!uint(image.cHRM.white_x);
    data ~= nativeToBigEndian!uint(image.cHRM.white_y);
    data ~= nativeToBigEndian!uint(image.cHRM.red_x);
    data ~= nativeToBigEndian!uint(image.cHRM.red_y);
    data ~= nativeToBigEndian!uint(image.cHRM.green_x);
    data ~= nativeToBigEndian!uint(image.cHRM.green_y);
    data ~= nativeToBigEndian!uint(image.cHRM.blue_x);
    data ~= nativeToBigEndian!uint(image.cHRM.blue_y);
    
    writeChunk("cHRM", data, ret);
}


void write_gAMA(PngImage image, ref ubyte[] ret) {
    if (image.gAMA is null) return;
    ubyte[] data;
    
    data ~= nativeToBigEndian!uint(image.gAMA.value);
    
    writeChunk("gAMA", data, ret);
}


void write_hIST(PngImage image, ref ubyte[] ret) {
    // TODO: waiting on loader
}

void write_pHYs(PngImage image, ref ubyte[] ret) {
    // TODO: waiting on loader
}

void write_sBIT(PngImage image, ref ubyte[] ret) {
    // TODO: waiting on loader
}

void write_tEXt(PngImage image, ref ubyte[] ret) {
    foreach(k, v; image.tEXt) {
        writeChunk("tEXt", cast(ubyte[])(k ~ "\0" ~ v), ret);
    }
}

void write_tIME(PngImage image, ref ubyte[] ret) {
    // TODO: waiting on loader
}

void write_tRNS(PngImage image, ref ubyte[] ret) {
    // TODO: waiting on loader
}

void write_zTXt(PngImage image, ref ubyte[] ret) {
    // TODO: waiting on loader
}

void write_IEND(PngImage image, ref ubyte[] ret) {
    writeChunk("IEND", [], ret);
}