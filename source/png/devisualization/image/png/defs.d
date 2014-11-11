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
module devisualization.image.png.defs;
import devisualization.image;

class PngImage : Image {
    import devisualization.image.png.chunks;

    IHDR_Chunk IHDR;
    PLTE_Chunk PLTE;

    // should not be interacted with in ANY WAY except as part of loading
    package IDAT_Chunk IDAT;
    
    cHRM_Chunk cHRM;
    string[PngTextKeywords] tEXt;
    gAMA_Chunk gAMA;
    
    this(ubyte[] data) {
        import devisualization.image.png.reader;
        parsePng(this, data);
    }
}

enum PngTextKeywords : string {
    Title = "Title",
    Author = "Author",
    Description = "Description",
    Copyright = "Copyright",
    CreationTime = "Creation Time",
    Software = "Software",
    Disclaimer = "Disclaimer",
    Warning = "Warning",
    Source = "Source",
    Comment = "Comment"
}

enum PngIHDRColorType : ubyte {
    None = 0,                                               // valid (0)
    
    Palette = 1 << 0,                                       // not valid
    ColorUsed = 1 << 1,                                     // valid (2) rgb
    AlphaChannelUsed = 1 << 2,                              // valid (4) a
    
    PalletteWithColorUsed = Palette | ColorUsed,            // valid (1, 2) index + alpha
    ColorUsedWithAlpha = ColorUsed | AlphaChannelUsed       // valid (2, 4) rgba
}

enum PngIHDRBitDepth : ubyte {
    // valid with color type:
    BitDepth1 = 1,                                          // 0, 3
    BitDepth2 = 2,                                          // 0, 3
    BitDepth4 = 4,                                          // 0, 3
    BitDepth8 = 8,                                          // 0, 2, 3, 4, 8
    BitDepth16 = 16                                         // 0, 2, 4, 8
}

enum PngIHDRCompresion : ubyte {
    DeflateInflate = 0
}

enum PngIHDRFilter : ubyte {
    Adaptive = 0
}

enum PngIHDRInterlaceMethod : ubyte {
    NoInterlace =  0,
    Adam7 = 1
}