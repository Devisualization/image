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
module devisualization.image.png.reader;
import devisualization.image.png.defs;
import devisualization.image.png.chunks;
import devisualization.image;

void parsePng(PngImage _, ubyte[] data) {
    import std.bitmanip : bigEndianToNative;
    import std.algorithm : equal;
    import std.conv : to;
    
    with(_) {
        
		ubyte[] handleAllIDAT;

        // check if it is a PNG image
        if (data.length < 9) {
            throw new NotAnImageException("Image data is not of type png");
        } else {
            if (data[0 .. 8].equal([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])) {
            } else {
                throw new NotAnImageException("Image data is not of type png");
            }
        }
        
        // do we actually have any data
        if (data.length > 8 + 4 + 4 + 4) {
            size_t index = 8;
            bool hitIDATChunk;

            while(index < data.length) {
                ubyte[] rawWholeChunk;

                uint chunkLength;
                char[4] chunkType;
                ubyte[] chunkData;
                ubyte[] crcCodeBytes;
                ubyte[] crcCodeData;

                calculateDataForChunk(index, data,
                                      rawWholeChunk, chunkLength, chunkType, chunkData, crcCodeBytes, crcCodeData);
                uint crcCode = verifyCRC(chunkType, crcCodeBytes, crcCodeData);
				version(DebugPngChunks) {
					debug outputRawChunk(data, index, chunkLength, chunkData, chunkType, crcCode);
				}

                // decide which function to call
                // it should be unrolled as it is is iterating over a tuple.

                bool handled;
                foreach(item; __traits(allMembers, Chunk_Handlers)) {
                    if (chunkType == cast(char[4])item) {
                        __traits(getMember, Chunk_Handlers, item)(_, chunkData);
                        handled = true;
                        break;
					}
                }

				if (chunkType == "IDAT") {
					handleAllIDAT ~= chunkData;
				}

                if (!handled) {
                    // store this chunk
                    // according to PNG specification, only the chunks that can be handled should be
                    // or else in theory can be ignored safely

                    if (hitIDATChunk) {
                        IDAT.postIDAT_Chunks ~= rawWholeChunk;
                    } else {
                        IDAT.preIDAT_Chunks ~= rawWholeChunk;
                    }

                } else if (chunkType == "IDAT") {
                    hitIDATChunk = true;
                }
                
                index += chunkLength + 4 + 4 + 4;
            }
        }

		handle_IDAT_chunk(_, handleAllIDAT);

        // TODO: apply color manipulation such as gAMA
    }

	version(DebugPngChunks) {
		debug outputPng(_);
	}
}

private {
    import devisualization.image.png.reader_chunks;
    import devisualization.image.png.reader_chunks_IDAT;

    enum Chunk_Handlers : void function(PngImage, ubyte[]) {
        IHDR = &handle_IHDR_chunk,
        PLTE = &handle_PLTE_chunk,
        BKGD = &handle_BKGD_chunk,
        cHRM = &handle_cHRM_chunk,
        gAMA = &handle_gAMA_chunk,
        hIST = &handle_hIST_chunk,
        pHYs = &handle_pHYs_chunk,
        sBIT = &handle_sBIT_chunk,
        tEXt = &handle_tEXt_chunk,
        tIME = &handle_tIME_chunk,
        tRNS = &handle_tRNS_chunk,
        zTXt = &handle_zTXt_chunk,
        IEND = &handle_IEND_chunk
    }
}

void calculateDataForChunk(size_t index, ubyte[] data,
out ubyte[] rawWholeChunk, out uint chunkLength, out char[4] chunkType, out ubyte[] chunkData, out ubyte[] crcCodeBytes, out ubyte[] crcCodeData)  {
    import std.bitmanip : bigEndianToNative;

    ubyte[4] d1 = data[index .. index + 4];
    chunkLength = bigEndianToNative!uint(d1);
    chunkType = cast(char[4])d1;
    chunkData = data[index + 4 + 4 .. index + 4 + 4 + chunkLength];
    
    crcCodeBytes = data[index + chunkLength + 8 .. index + chunkLength + 12];
    crcCodeData = data[index + 4 .. index + chunkLength + 4 + 4];

    rawWholeChunk = data[index .. index + chunkLength + 12];
}

uint verifyCRC(char[4] chunkType, ubyte[] crcCodeBytes, ubyte[] crcCodeData) {
    import std.algorithm : reverse;
    import std.digest.crc : crc32Of, crcHexString;

    crcCodeBytes.reverse();
    uint crcCode = *cast(uint*)crcCodeBytes.ptr;

    if (crcHexString(crc32Of(crcCodeData)) != crcHexString(crcCodeBytes))
        throw new NotAnImageException("CRC code invalid for chunk " ~ cast(string)chunkType);

    return crcCode;
}

debug {
	version(DebugPngChunks) {
		void outputRawChunk(ubyte[] rawData, size_t index, size_t chunkLength, ubyte[] chunkData, char[4] chunkType, uint crcCode) {
	        import std.stdio;
	        writeln("========" ~ chunkType ~ "========");

	        writeln("raw: ", rawData[index .. index + chunkLength + 12]);
	        writeln("raw_crc: ", crcCode);

	        writeln("chunk_length: ", chunkLength);
	        writeln("chunk_data: ", chunkData);

	        writeln("========" ~ chunkType ~ "========");
	    }
	}

    void outputPng(PngImage _) {
        import std.stdio;

        with(_) {
            writeln("IHDR == ", IHDR);
            writeln("PLTE == ", PLTE);
            
            writeln("IDAT == ", IDAT);
            
            writeln("cHRM == ", cHRM);
            writeln("gAMA == ", gAMA);
            writeln("tEXt == ", tEXt);
        }
    }
}