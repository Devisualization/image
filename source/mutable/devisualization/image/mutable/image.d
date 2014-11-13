module devisualization.image.mutable.image;
import devisualization.image;

class MutableImage : Image {
    Color_RGBA[][] allMyPixels;
    private {
        size_t width_;
        size_t height_;
        size_t totalSize;
    }

    this(size_t width, size_t height, Color_RGBA[] pixels) {
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
            if (row >= allMyPixels.length) {}
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
                allMyPixels[row] ~= Color_RGBA(0, 0, 0, 0);

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
                    return allMyPixels[idx / width][idx % height];
                }
                
                @property size_t length() {
                    return totalSize;
                }
                
                // InputRange

                @property Color_RGBA front() {
                    return allMyPixels[index/width][index % height];
                }
                
                Color_RGBA moveFront() {
                    Color_RGBA ret = allMyPixels[width / index][height % index];
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
}