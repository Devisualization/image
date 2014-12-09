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
module devisualization.image.creation;
import devisualization.image.image;

Image imageFromFile(string file) {
    import std.file : read;
    import std.path : extension;

    return imageFromData(extension(file)[1 ..$], cast(ubyte[])read(file));
}

Image imageFromData(string type, ubyte[] data) {
    if (type in loaders) {
        return loaders[type](data);
    } else {
        throw new NotAnImageException("Unknown file type");
    }
}

Image convertTo(Image from, string type) {
	if (type in convertTos) {
		return convertTos[type](from);
	} else {
		throw new NotAnImageException("Unknown file type");
	}
}

private {
    __gshared Image delegate(ubyte[])[string] loaders;
    __gshared Image delegate(Image)[string] convertTos;
}

void registerImageLoader(string ext, Image delegate(ubyte[] data) loader) {
    loaders[ext] = loader;
}

void registerImageConvertTo(string ext, Image delegate(Image) converter) {
	convertTos[ext] = converter;
}