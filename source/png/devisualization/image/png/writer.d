module devisualization.image.png.write;
import devisualization.image.png.defs;
import devisualization.image.png.writer_chunks;
import devisualization.image.png.writer_chunks_IDAT;

ubyte[] writePNG(PngImage image) {
    ubyte[] ret = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

    write_IHDR(image, ret);
    write_PLTE(image, ret);
    write_BKGD(image, ret);
    write_cHRM(image, ret);
    write_gAMA(image, ret);
    write_hIST(image, ret);
    write_pHYs(image, ret);
    write_sBIT(image, ret);
    write_tEXt(image, ret);
    write_tIME(image, ret);
    write_tRNS(image, ret);
    write_IDAT(image, ret);
    write_zTXt(image, ret);
    write_IEND(image, ret);

    return ret;
}

package {
    void writeChunk(char[4] name, ubyte[] data, ref ubyte[] ret) {
        import std.algorithm : reverse;
        import std.digest.crc : crc32Of, crcHexString;
        import std.bitmanip : nativeToBigEndian;

        ubyte[] t;
        t ~= name;
        t ~= data;
        t ~= crc32Of(t);

        ret ~= nativeToBigEndian!uint(t.length);
        ret ~= t;
    }
}