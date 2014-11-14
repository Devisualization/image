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
module devisualization.image.color;

class Color_RGBA {
    ushort r;
    ushort g;
    ushort b;
    ushort a;

    this(float r, float g, float b, float a)
    in {
        assert(r >= -1 && r <= 1);
        assert(g >= -1 && g <= 1);
        assert(b >= -1 && b <= 1);
        assert(a >= -1 && a <= 1);
    } body {
        // 0 .. 2
        r += 1;
        g += 1;
        b += 1;
        a += 1;

        // max size of ushort / 2 (because range max is 2)
        float mul = ushort.max / 2;

        // e.g. mul == 50 (100 max) * .5 == 25 (.5 is 1/4'th of 2)
        r *= mul;
        g *= mul;
        b *= mul;
        a *= mul;
    }

    this(ushort r, ushort g, ushort b, ushort a) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }

    override string toString() {
        import std.format : formattedWrite;
        import std.array : appender;
        
        auto writer = appender!string();
        formattedWrite(writer, "[r: %d g: %d b: %d a: %d]", r, g, b, a);
        
        return writer.data();
    }

    @property {
        ubyte r_ubyte() {
            return cast(ubyte)(r / 256);
        }

        ubyte g_ubyte() {
            return cast(ubyte)(g / 256);
        }

        ubyte b_ubyte() {
            return cast(ubyte)(b / 256);
        }

        ubyte a_ubyte() {
            return cast(ubyte)(a / 256);
        }

        ubyte[4] ubytes() {
            return [r_ubyte, g_ubyte, b_ubyte, a_ubyte];
        }
    }
}

ubyte[4][] ubyteRawColor(Color_RGBA[] pixels) {
    ubyte[4][] ret;
    ret.length = pixels.length;

    foreach(i, pixel; pixels) {
        ret[i] = pixel.ubytes;
    }

    return ret;
}