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
module devisualization.image.png.writer_chunks_IDAT;
import devisualization.image.png.defs;
import devisualization.image.png.write;
import devisualization.image;

void write_IDAT(PngImage _, ref ubyte[] ret) {
	with(_) {
		ubyte[] pixelData;

		IDAT.unfiltered_uncompressed_pixels.length = allMyPixels.length;

		foreach(i, color; allMyPixels) {
			IDAT.unfiltered_uncompressed_pixels[i] = new IDAT_Chunk_Pixel(color);
		}

		//

		if (IHDR.interlaceMethod == PngIHDRInterlaceMethod.Adam7) {
			// TODO: un Adam7 algo IDAT.unfiltered_uncompressed_pixels
		} else if (IHDR.interlaceMethod == PngIHDRInterlaceMethod.NoInterlace) {
		} else {
			throw new NotAnImageException("Invalid image filter method");
		}

		//

		pixelData = pushPixelsRawData(_);

		//
		
		if (IHDR.compressionMethod == PngIHDRCompresion.DeflateInflate) {
			if (IHDR.compressionMethod == PngIHDRCompresion.DeflateInflate) {
				pixelData = compressInflateDeflate(_, pixelData);
			} else {
				throw new NotAnImageException("Unknown compression method");
			}
		} else {
			throw new NotAnImageException("Invalid image compression method");
		}

		//

		writeChunk("IDAT", pixelData, ret);
	}
}

ubyte[] pushPixelsRawData(PngImage _) {
	ubyte[] ret;
	
	with(_) {
		size_t i;
		foreach(y; 0 .. height) {
			if (IHDR.filterMethod == PngIHDRFilter.Adaptive) {
				ret ~= 0;
			} else {
				throw new NotAnImageException("Invalid image filter method");
			}

			foreach(x; 0 .. width) {
				ret ~= IDAT.unfiltered_uncompressed_pixels[i].exportValues(IHDR.colorType, IHDR.bitDepth == PngIHDRBitDepth.BitDepth16);
				i++;
			}
		}
	}
	
	return ret;
}

ubyte[] compressInflateDeflate(PngImage _, ubyte[] pixelData) {
	import std.zlib : compress;

	return cast(ubyte[])compress(pixelData);
}