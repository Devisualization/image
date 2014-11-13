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
module devisualization.image.png.chunks;
import devisualization.image.png.defs;

struct IHDR_Chunk {
    uint width;
    uint height;
    PngIHDRBitDepth bitDepth;
    PngIHDRColorType colorType;
    PngIHDRCompresion compressionMethod;
    PngIHDRFilter filterMethod;
    PngIHDRInterlaceMethod interlaceMethod;
}

class PLTE_Chunk {
    PLTE_Color[] colors;
    
    struct PLTE_Color {
        ubyte r, g, b;
    }
}

class cHRM_Chunk {
    this(uint[] data ...) pure {
        size_t last = 0;
        
        foreach(f; __traits(allMembers, cHRM_Chunk)) {
            if (last > data.length)
                break;
            
            static if (__traits(compiles, {mixin(f ~ " = uint.max;");})) {
                mixin(f ~ " = data[last];");
                
                last++;
            }
        }
    }
    
    uint white_x;
    uint white_y;
    
    uint red_x;
    uint red_y;
    
    uint green_x;
    uint green_y;
    
    uint blue_x;
    uint blue_y;
    
    override string toString() {
        import std.conv : to;
        string ret = "[";
        
        foreach(f; __traits(allMembers, cHRM_Chunk)) {
            static if (__traits(compiles, {mixin(f ~ " = uint.max;");})) {
                mixin("ret ~= \"" ~ f ~ ": \" ~ to!string(" ~ f ~ ") ~ \", \";");
            }
        }
        
        ret.length--;
        return ret ~ "]";
    }
}

class gAMA_Chunk {
    this(uint value) pure {
        this.value = value;
    }
    
    uint value;
    
    @property void gamma(float value) {
        this.value = cast(uint)(value * 100000);
    }
    
    @property float gamma() {
        return value / 100000f;
    }
    
    override string toString() {
        import std.conv : to;
        return to!string(gamma);
    }
}

struct IDAT_Chunk {
    IDAT_Chunk_Pixel[] unfiltered_uncompressed_pixels;

    ubyte[][] preIDAT_Chunks;
    ubyte[][] postIDAT_Chunks;
    
    string toString() {
        import std.conv : to;
        string ret = "[\n";

        ret ~= preIDAT_Chunks.length > 0 ? "Has pre IDAT (unknown) chunks\n" : "Does not have pre IDAT (unknown) chunks\n";
        ret ~= postIDAT_Chunks.length > 0 ? "Has post IDAT (unknown) chunks\n" : "Does not have post IDAT (unknown) chunks\n";

        ret ~= "Pixels: \n";
        
        foreach(pixel; unfiltered_uncompressed_pixels) {
            ret ~= "\t" ~ pixel.toString() ~ "\n";
        }
        
        return ret ~ "]";
    }
}

class IDAT_Chunk_Pixel {
    const bool used_color;
    
    union {
        ushort value;
        
        struct {
            ushort r;
            ushort g;
            ushort b;
        }
    }
    
    ushort a;
    
    this(ubyte[] data, bool multibyte) {
        import std.bitmanip : bigEndianToNative;
        
        if (multibyte) {
            if (data.length == 2) {
                value = bigEndianToNative!ushort(cast(ubyte[2])data[0 .. 2]);
            } else if (data.length == 4) {
                value = bigEndianToNative!ushort(cast(ubyte[2])data[0 .. 2]);
                a = bigEndianToNative!ushort(cast(ubyte[2])data[2 .. 4]);
            } else if (data.length == 6) {
                used_color = true;
                r = bigEndianToNative!ushort(cast(ubyte[2])data[0 .. 2]);
                g = bigEndianToNative!ushort(cast(ubyte[2])data[2 .. 4]);
                b = bigEndianToNative!ushort(cast(ubyte[2])data[4 .. 6]);
            } else if (data.length == 8) {
                used_color = true;
                r = bigEndianToNative!ushort(cast(ubyte[2])data[0 .. 2]);
                g = bigEndianToNative!ushort(cast(ubyte[2])data[2 .. 4]);
                b = bigEndianToNative!ushort(cast(ubyte[2])data[4 .. 6]);
                a = bigEndianToNative!ushort(cast(ubyte[2])data[6 .. 8]);
            }
        } else {
            if (data.length == 1) {
                value = data[0];
            } else if (data.length == 2) {
                value = data[0];
                a = data[1];
            } else if (data.length == 3) {
                used_color = true;
                r = data[0];
                g = data[1];
                b = data[2];
            } else if (data.length == 4) {
                used_color = true;
                r = data[0];
                g = data[1];
                b = data[2];
                a = data[3];
            }
        }
    }
    
    override string toString() {
        import std.format : formattedWrite;
        import std.array : appender;
        
        auto writer = appender!string();
        
        if (used_color) {
            formattedWrite(writer, "[r: %d g: %d b: %d a: %d]", r, g, b, a);
        } else {
            formattedWrite(writer, "[value: %d a: %d]", value, a);
        }
        
        return writer.data();
    }
}