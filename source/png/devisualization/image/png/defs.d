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

    Color_RGBA[] allMyPixels;

    this(Image from) {
        assert(0, "TODO: not implemented");
    }

    this(ubyte[] data) {
        import devisualization.image.png.reader;
        parsePng(this, data);
    }

    @property {
        ImagePixels!Color_RGBA rgba() {
            class RGBAClasz : ImagePixels!Color_RGBA {
                private size_t index;
                
                @property Color_RGBA[] allPixels() {
                    return allMyPixels;
                }
                
                Color_RGBA opIndex(size_t idx)
                in {
                    assert(idx < allMyPixels.length);
                } body {
                    return allMyPixels[idx];
                }

                void opIndexAssign(Color_RGBA newValue, size_t idx)
                in {
                    assert(idx < allMyPixels.length);
                } body {
                    allMyPixels[idx] = newValue;
                }
                
                @property size_t length() {
                    return allMyPixels.length;
                }

                size_t xFromIndex(size_t idx) {
                    return idx / IHDR.width;
                }

                size_t yFromIndex(size_t idx) {
                    return idx % IHDR.height;
                }
                
                size_t indexFromXY(size_t x, size_t y) {
                    return (y * IHDR.width) + x;
                }

                // InputRange

                @property Color_RGBA front() {
                    return allMyPixels[index];
                }

                Color_RGBA moveFront() {
                    Color_RGBA ret = allMyPixels[index];
                    index++;
                    return ret;
                }

                void popFront() {
                    index++;
                }

                @property bool empty() {
                    return allMyPixels.length >= index;
                }

                int opApply(int delegate(Color_RGBA) del) {
                    foreach(ref pixel; allMyPixels) {
                        if (auto ret = del(pixel))
                            return ret;
                    }

                    return 0;
                }

                int opApply(int delegate(size_t, Color_RGBA) del) {
                    foreach(i, ref pixel; allMyPixels) {
                        if (auto ret = del(i, pixel))
                            return ret;
                    }

                    return 0;
                }
            }
            
            return new RGBAClasz;
        }

        size_t width() {
            return IHDR.width;
        }

        size_t height() {
            return IHDR.height;
        }
    }

    @disable
    ubyte[] exportFrom() { return null; }
    
    @disable
    void exportTo(string file) {}
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