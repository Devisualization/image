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
module devisualization.image.png.reader_chunks;
import devisualization.image.png.defs;
import devisualization.image.png.chunks;
import devisualization.image;

void handle_IHDR_chunk(PngImage _, ubyte[] chunkData) {
    import std.bitmanip : bigEndianToNative;

    with(_) {
        if (chunkData.length == 13) {
            IHDR = IHDR_Chunk(bigEndianToNative!uint(cast(ubyte[4])chunkData[0 .. 4]),
                              bigEndianToNative!uint(cast(ubyte[4])chunkData[4 .. 8]),
                              cast(PngIHDRBitDepth) chunkData[8],
            cast(PngIHDRColorType) chunkData[9],
            cast(PngIHDRCompresion) chunkData[10],
            cast(PngIHDRFilter) chunkData[11],
            cast(PngIHDRInterlaceMethod) chunkData[12]);
        } else {
            throw new NotAnImageException("Corrupted PNG image");
        }
    }
}

void handle_PLTE_chunk(PngImage _, ubyte[] chunkData) {
    with(_) {
        PLTE = new PLTE_Chunk();
        for (size_t i; i < chunkData.length; i += 3) {
            PLTE.colors ~= PLTE_Chunk.PLTE_Color(chunkData[i], chunkData[i + 1], chunkData[i + 2]);
        }
    }
}

void handle_BKGD_chunk(PngImage _, ubyte[] chunkData) {
    with(_) {
        //TODO:
        // fairly easy to do
        //  requires IDAT's color storage type however
    }
}

void handle_cHRM_chunk(PngImage _, ubyte[] chunkData) {
    import std.bitmanip : bigEndianToNative;
    
    with(_) {
        cHRM = new cHRM_Chunk(bigEndianToNative!uint(cast(ubyte[4])chunkData[0 .. 4]),
                              bigEndianToNative!uint(cast(ubyte[4])chunkData[4 .. 8]),
                              bigEndianToNative!uint(cast(ubyte[4])chunkData[8 .. 12]),
                              bigEndianToNative!uint(cast(ubyte[4])chunkData[12 .. 16]),
                              bigEndianToNative!uint(cast(ubyte[4])chunkData[16 .. 20]),
                              bigEndianToNative!uint(cast(ubyte[4])chunkData[20 .. 24]),
                              bigEndianToNative!uint(cast(ubyte[4])chunkData[24 .. 28]),
                              bigEndianToNative!uint(cast(ubyte[4])chunkData[28 .. 32]));
    }
}

void handle_gAMA_chunk(PngImage _, ubyte[] chunkData) {
    import std.bitmanip : bigEndianToNative;
    
    with(_) {
        if (chunkData.length > 4)
            throw new NotAnImageException("Corrupted PNG gAMA chunk");
        
        gAMA = new gAMA_Chunk(bigEndianToNative!uint(*cast(ubyte[4]*)chunkData.ptr));
    }
}

void handle_hIST_chunk(PngImage _, ubyte[] chunkData) {
    with(_) {
        //TODO: fairly simple
    }
}

void handle_pHYs_chunk(PngImage _, ubyte[] chunkData) {
    with(_) {
        //TODO: fairly simple
    }
}

void handle_sBIT_chunk(PngImage _, ubyte[] chunkData) {
    with(_) {
        //TODO:
        // fairly easy to do
        //  requires IDAT's color storage type however
    }
}

void handle_tEXt_chunk(PngImage _, ubyte[] chunkData) {
    with(_) {
        string buffer;
        string keyword;
        foreach(c; chunkData) {
            if (c == 0) {
                keyword = buffer;
                buffer = "";
            } else {
                buffer ~= cast(char)c;
            }
        }
        tEXt[cast(PngTextKeywords)keyword] = buffer;
    }
}

void handle_tIME_chunk(PngImage _, ubyte[] chunkData) {
    with(_) {
        //TODO: fairly simple
    }
}

void handle_tRNS_chunk(PngImage _, ubyte[] chunkData) {
    with(_) {
        //TODO:
        // fairly easy to do
        //  requires IDAT's color storage type however
    }
}

void handle_zTXt_chunk(PngImage _, ubyte[] chunkData) {
    with(_) {
        //TODO:
        // fairly easy to do
        //  requires decompressor
    }
}

void handle_IEND_chunk(PngImage _, ubyte[] chunkData) {
    // do nothing
    // there is no data here to parse
}