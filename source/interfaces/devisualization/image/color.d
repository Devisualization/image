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

enum float ubyteToUshort = ushort.max / ubyte.max;

class Color_RGBA {
    ushort r;
    ushort g;
    ushort b;
    ushort a;

    this(float r, float g, float b, float a)
    in {
        assert(r >= 0 && r <= 1);
        assert(g >= 0 && g <= 1);
        assert(b >= 0 && b <= 1);
        assert(a >= 0 && a <= 1);
    } body {
        this.r = cast(ushort)(r * ushort.max);
        this.g = cast(ushort)(g * ushort.max);
        this.b = cast(ushort)(b * ushort.max);
        this.a = cast(ushort)(a * ushort.max);
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
            return cast(ubyte)(r / ubyteToUshort);
        }

        ubyte g_ubyte() {
            return cast(ubyte)(g / ubyteToUshort);
        }

        ubyte b_ubyte() {
            return cast(ubyte)(b / ubyteToUshort);
        }

        ubyte a_ubyte() {
            return cast(ubyte)(a / ubyteToUshort);
        }

        ubyte[4] ubytes() {
            return [r_ubyte, g_ubyte, b_ubyte, a_ubyte];
        }
    }

	static Color_RGBA fromUbytes(ubyte r, ubyte g, ubyte b, ubyte a) {
		return new Color_RGBA(r * ubyteToUshort, g * ubyteToUshort, b * ubyteToUshort, a * ubyteToUshort);
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

Color_RGBA[] colorsFromArray(ubyte[][] data) {
    Color_RGBA[] ret;

    foreach(datem; data) {
        ushort r = datem.length > 0 ? datem[0] : 0;
        ushort g = datem.length > 1 ? datem[1] : 0;
        ushort b = datem.length > 2 ? datem[2] : 0;
        ushort a = datem.length > 3 ? datem[3] : 255;

        r *= ubyteToUshort;
        g *= ubyteToUshort;
        b *= ubyteToUshort;
        a *= ubyteToUshort;

        ret ~= new Color_RGBA(r, g, b, a);
    }

    return ret;
}