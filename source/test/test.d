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
	import devisualization.util.core.linegraph;

    import std.stdio;

	writeln("===============\nREAD\n===============");
	Image img = imageFromFile("test/sketchpad.png");

    /*writeln(img.rgba.allPixels);
    writeln("width: ", img.width);
    writeln("height: ", img.height);
    foreach(i, pixel; img.rgba) {
        writefln("%d: %s", i, pixel);
    }
	img = new MutableImage(100, 50);
	for(size_t i; i < 100 * 50; i++) {
		img.rgba[i] = Color_RGBA.fromUbyte(255, 0, 0, 255);
	}*/

	//img = skewHorizontal(img, 25, Color_RGBA.fromUbyte(255, 255, 0, 255));
	//img = skewVertical(img, -25, Color_RGBA.fromUbyte(255, 255, 0, 255));

	MutableImage img2 = new MutableImage(img);
	//img2 = img2.rotate(45);
	img2 = img2.gaussianBlur;

	writeln("===============\nWRITE\n===============");
	img2.convertTo("png").exportTo("test_output.png");

	/*writeln("===============\nREAD - 2\n===============");
	img = imageFromFile("test_output.png");

	writeln(img.rgba.allPixels);
	writeln("width: ", img.width);
	writeln("height: ", img.height);
	foreach(i, pixel; img.rgba) {
		writefln("%d: %s", i, pixel);
	}

	writeln("===============\nMODIFY\n===============");

    img = new MutableImage(img);

    img.rgba[2] = Color_RGBA.fromUbyte(2, 2, 2, 2);

    writeln(img.rgba.allPixels);
    writeln("width: ", img.width);
    writeln("height: ", img.height);
    foreach(i, pixel; img.rgba) {
        writefln("%d: %s", i, pixel);
    }*/
}