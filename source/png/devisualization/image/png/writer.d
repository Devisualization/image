/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Devisualization (Richard Andrew Cattermole)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
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
        import std.digest.crc : crc32Of;
        import std.bitmanip : nativeToBigEndian;

        ubyte[] t;
		t ~= name;
        t ~= data;
        
		ubyte[4] crcBytes = crc32Of(t);
		t ~= [crcBytes[3], crcBytes[2], crcBytes[1], crcBytes[0]];

		ret ~= nativeToBigEndian!uint(cast(uint)data.length);
		ret ~= t;
    }
}