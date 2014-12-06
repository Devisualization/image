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
module devisualization.image.mutable.image;
import devisualization.image;

class MutableImage : Image {
    Color_RGBA[][] allMyPixels;
    private {
        size_t width_;
        size_t height_;
        size_t totalSize;
    }

    this(Image from) {
        this(from.width, from.height, from.rgba.allPixels);
    }

    this(size_t width, size_t height, Color_RGBA[] pixels = []) {
        width_ = width;
        height_ = height;
        totalSize = width * height;

        if (pixels.length <= totalSize) {
            // good same size
        } else {
            throw new NotAnImageException("Too many pixels for size specified");
        }

        size_t row;
        foreach(i, pixel; pixels) {
            if (row >= allMyPixels.length)
                allMyPixels.length++;
            allMyPixels[row] ~= pixel;

            if (i % width - 1) {
                row++;
            }
        }

        if (pixels.length < totalSize) {
            // append
            row = allMyPixels.length / width;
            for(size_t i = allMyPixels.length; i < totalSize; i++) {
                if (row >= allMyPixels.length)
                    allMyPixels.length++;
                allMyPixels[row] ~= new Color_RGBA(0, 0, 0, 0);

                if (i % width == width - 1)
                    row++;
            }
        }
    }

    @property {
        ImagePixels!Color_RGBA rgba() {
            class RGBAClasz : ImagePixels!Color_RGBA {
                private size_t index;
                
                @property Color_RGBA[] allPixels() {
                    Color_RGBA[] ret;
                    ret.length = totalSize;

                    size_t i;
                    foreach(ref pixels; allMyPixels) {
                        foreach(ref pixel; pixels) {
                            ret[i] = pixel;
                            i++;
                        }
                    }

                    return ret;
                }
                
                Color_RGBA opIndex(size_t idx)
                in {
                    assert(idx < allMyPixels.length);
                } body {
                    return allMyPixels[yFromIndex(idx)][xFromIndex(idx)];
                }

                void opIndexAssign(Color_RGBA newValue, size_t idx)
                in {
                    assert(idx < allMyPixels.length);
                } body {
                    allMyPixels[yFromIndex(idx)][xFromIndex(idx)] = newValue;
                }
                
                @property size_t length() {
                    return totalSize;
                }

                size_t xFromIndex(size_t idx) {
                    return idx % width;
                }
                
                size_t yFromIndex(size_t idx) {
                    return idx / width;
                }
                
                size_t indexFromXY(size_t x, size_t y) {
                    return (y * width) + x;
                }

                // InputRange

                @property Color_RGBA front() {
                    return allMyPixels[yFromIndex(index)][xFromIndex(index)];
                }
                
                Color_RGBA moveFront() {
                    Color_RGBA ret = allMyPixels[yFromIndex(index)][xFromIndex(index)];
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
                    foreach(ref pixels; allMyPixels) {
                        foreach(ref pixel; pixels) {
                            if (auto ret = del(pixel))
                                return ret;
                        }
                    }
                    
                    return 0;
                }
                
                int opApply(int delegate(size_t, Color_RGBA) del) {
                    size_t i;
                    foreach(ref pixels; allMyPixels) {
                        foreach(ref pixel; pixels) {
                            if (auto ret = del(i, pixel))
                                return ret;
                            i++;
                        }
                    }
                    
                    return 0;
                }
            }
            
            return new RGBAClasz;
        }

        size_t width() {
            return width_;
        }

        size_t height() {
            return height_;
        }
    }

    @disable
    ubyte[] exportFrom() { return null; }

    @disable
    void exportTo(string file) {}
}

unittest {
    Image image = new MutableImage(1, 2);
    image.rgba[0] = new Color_RGBA(0, 0, 0, 0);
    image.rgba[1] = new Color_RGBA(255, 255, 255, 255);

    assert(image.rgba[0] == new Color_RGBA(0, 0, 0, 0));
    assert(image.rgba[1] == new Color_RGBA(255, 255, 255, 255));
}