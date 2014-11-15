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
module test;

void main() {
    import devisualization.image;
    import devisualization.image.mutable;

    import std.stdio;

    Image img = imageFromFile("test/myfile.png");
    writeln("===============\nREAD\n===============");

    img.rgba[3] = new Color_RGBA(1, 1, 1, 1);
    writeln(img.rgba.allPixels);
    writeln("width: ", img.width);
    writeln("height: ", img.height);
    foreach(i, pixel; img.rgba) {
        writefln("%d: %s", i, pixel);
    }

    img.exportTo("test_output.png");

    img = new MutableImage(img);

    img.rgba[3] = new Color_RGBA(2, 2, 2, 2);

    writeln(img.rgba.allPixels);
    writeln("width: ", img.width);
    writeln("height: ", img.height);
    foreach(i, pixel; img.rgba) {
        writefln("%d: %s", i, pixel);
    }
}