module devisualization.image.png.reader;
import devisualization.image.png.defs;
import devisualization.image.png.chunks;
import devisualization.image;

void parsePng(PngImage _, ubyte[] data) {
    import std.bitmanip : bigEndianToNative;
    import std.algorithm : equal;
    import std.conv : to;
    
    with(_) {
        
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
                debug outputRawChunk(data, index, chunkLength, chunkData, chunkType, crcCode);

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

        // TODO: apply color manipulation such as gAMA
    }

    debug outputPng(_);
}

private {
    import devisualization.image.png.reader_chunks;
    import devisualization.image.png.reader_chunks_IDAT;

    enum Chunk_Handlers : void function(PngImage, ubyte[]) {
        IHDR = &handle_IHDR_chunk,
        PLTE = &handle_PLTE_chunk,
        IDAT = &handle_IDAT_chunk,
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

    chunkLength = bigEndianToNative!uint(cast(ubyte[4])data[index .. index + 4]);
    chunkType = cast(char[4])data[index + 4 .. index + 8];
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
    void outputRawChunk(ubyte[] rawData, size_t index, size_t chunkLength, ubyte[] chunkData, char[4] chunkType, uint crcCode) {
        import std.stdio;
        writeln("========" ~ chunkType ~ "========");

        writeln("raw: ", rawData[index .. index + chunkLength + 12]);
        writeln("raw_crc: ", crcCode);

        writeln("chunk_length: ", chunkLength);
        writeln("chunk_data: ", chunkData);

        writeln("========" ~ chunkType ~ "========");
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