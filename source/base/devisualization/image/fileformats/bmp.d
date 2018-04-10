/**
 * PNG file format image loader/exporter
 *
 * License:
 *              Copyright Devisualization (Richard Andrew Cattermole) 2014 - 2017.
 *     Distributed under the Boost Software License, Version 1.0.
 *        (See accompanying file LICENSE_1_0.txt or copy at
 *              http://www.boost.org/LICENSE_1_0.txt)
 */
module devisualization.image.fileformats.bmp;
import devisualization.image.fileformats.defs : HeadersOnly, ImageNotLoadableException, ImageNotExportableException;
import devisualization.image.interfaces;
import devisualization.image.primitives : isImage, ImageColor;
import devisualization.image.storage.base : ImageStorageHorizontal;
import devisualization.util.core.memory.managed;
import std.range : isInputRange, ElementType;
import stdx.allocator : IAllocator, theAllocator, makeArray, make, expandArray, dispose;
import std.experimental.color : isColor, RGB8, RGBA8, convertColor;
import std.typecons : tuple;

///
alias HeadersOnlyBMPFileFormat = BMPFileFormat!HeadersOnly;

///
struct BMPFileFormat(Color) if (isColor!Color || is(Color == HeadersOnly)) {
    import std.bitmanip : littleEndianToNative;

    ///
    BMP_InfoHeader infoHeader;

    static if (!is(Color == HeadersOnly)) {
        /// Only available when Color is specified as not HeadersOnly
        ImageStorage!Color value;
        alias value this;

        ///
        managed!(ubyte[]) toBytes() {
            assert(0);
            //return performExport();
        }
    }

    // we can't copy because of ImageStorage type probably won't be able to be
    @disable
    this(this);

    @property {
        ///
        IAllocator allocator() {
            return alloc;
        }
    }

    this(IAllocator allocator) {
        this.alloc = allocator;

    }

    ~this() {
        if (allocator is null) return;

        static if (!is(Color == HeadersOnly)) {
            if (value !is null) {
                allocator.dispose(value);
            }
        }
    }

    private {
        IAllocator alloc;

        void delegate(size_t width, size_t height) @trusted theImageAllocator;

        static if (!is(Color == HeadersOnly)) {
            void allocateTheImage(ImageImpl)(size_t width, size_t height) @trusted {
                static if (is(ImageImpl : ImageStorage!Color)) {
                    value = alloc.make!(ImageImpl)(width, height, alloc);
                } else {
                    value = imageObject!(ImageImpl)(width, height, alloc);
                }
            }
        } else {
        }

        void performInput(IR)(IR input) @trusted {
            import std.range;

            ubyte popReadValue() {
                if (input.empty)
                    throw new ImageNotLoadableException("Input was not long enough");

                ubyte ret = input.front;
                input.popFront;

                return ret;
            }

            ushort popReadUshort() {
                ubyte[2] temp;
                temp[0] = popReadValue();
                temp[1] = popReadValue();
                return littleEndianToNative!ushort(temp);
            }

            uint popReadUint() {
                ubyte[4] temp;
                temp[0] = popReadValue();
                temp[1] = popReadValue();
                temp[2] = popReadValue();
                temp[3] = popReadValue();
                return littleEndianToNative!uint(temp);
            }

            // file header

            BMP_FileHeader fileHeader;
            fileHeader.fileType = popReadUshort;
            fileHeader.fileSize = popReadUint;
            fileHeader.reserved1 = cast(short)popReadUshort;
            fileHeader.reserved2 = cast(short)popReadUshort;
            fileHeader.bitmapOffset = popReadUint;

            switch(fileHeader.fileType) {
                case 0x4D42:
                    break;
                default:
                    import std.stdio;
                    writefln("%x", fileHeader.fileType);
                    throw new ImageNotLoadableException("Unknown file type");
            }

            // Info Header

            infoHeader.size = popReadUint;
            infoHeader.width = popReadUint;
            infoHeader.height = popReadUint;
            infoHeader.planes = popReadUshort;
            infoHeader.bitsPerPixel = popReadUshort;
            infoHeader.compression = popReadUint;
            infoHeader.sizeOfBitmap = popReadUint;
            infoHeader.horizontalResolution = cast(int)popReadUint;
            infoHeader.verticalResolution = cast(int)popReadUint;
            infoHeader.colorsUsed = popReadUint;
            infoHeader.colorsUsed = popReadUint;

            import std.stdio;
            writeln(infoHeader);

            if (infoHeader.planes != 1) {
                throw new ImageNotLoadableException("Number of planes for a BMP image should be 1");
            } else if (!(infoHeader.bitsPerPixel == 24 || infoHeader.bitsPerPixel == 32)) {
                throw new ImageNotLoadableException("Bits per pixel for a BMP image must be 24/32");
            } else if (infoHeader.compression == 4 || infoHeader.compression == 5) {
                throw new ImageNotLoadableException("PNG/JPEG embedding not supported within a BMP file");
            } else if (!(infoHeader.compression == 0 || infoHeader.compression == 3 || infoHeader.compression == 6)) {
                throw new ImageNotLoadableException("BMP compression is not supported");
            }

            // get us to the start of the image data.

            size_t offset = BMP_FileHeader.sizeof + BMP_InfoHeader.sizeof;
            while(offset < fileHeader.bitmapOffset) {
                popReadValue;
                offset++;
            }

            static if (!is(Color == HeadersOnly)) {
                import std.math : abs;
                theImageAllocator(infoHeader.width, infoHeader.height);

                // length per row must be % 4 == 0
                // when height < 0 then start at bottom and work up

                // now read the data
                // don't forget to keep updating offset!

                RGB8 rgb8;
                RGBA8 rgba8;

                size_t absHeight = abs(infoHeader.height);
                foreach(y2; 0 .. absHeight) {
                    // make go upwards instead of downwards if required
                    size_t y = infoHeader.height < 0 ? (absHeight-(y2+1)) : y2;

                    foreach(x; 0 .. infoHeader.width) {
                        if (infoHeader.bitsPerPixel == 32) {
                            rgba8.r.value = popReadValue;
                            rgba8.g.value = popReadValue;
                            rgba8.b.value = popReadValue;
                            rgba8.a.value = popReadValue;

                            static if (is(Color == RGBA8)) {
                                value[x, y] = rgba8;
                            } else {
                                value[x, y] = convertColor!Color(rgba8);
                            }

                            offset += 4;
                        } else if (infoHeader.bitsPerPixel == 24) {
                            rgb8.r.value = popReadValue;
                            rgb8.g.value = popReadValue;
                            rgb8.b.value = popReadValue;

                            static if (is(Color == RGB8)) {
                                value[x, y] = rgb8;
                            } else {
                                value[x, y] = convertColor!Color(rgb8);
                            }

                            offset += 3;
                        }
                    }

                    while(offset % 4 != 0) {
                        popReadValue;
                        offset++;
                    }
                }
            }
        }
    }
}

/**
 * Loads a BMP file headers
 *
 * Can be used to determine which color type to use at runtime.
 *
 * Returns:
 *      A BMP files headers without the image data
 */
managed!(BMPFileFormat!HeadersOnly) loadBMPHeaders(IR)(IR input, IAllocator allocator = theAllocator()) @trusted if (isInputRange!IR && is(ElementType!IR == ubyte)) {
    managed!(BMPFileFormat!HeadersOnly) ret = managed!(BMPFileFormat!HeadersOnly)(managers(ReferenceCountedManager()), tuple(allocator), allocator);
    ret.performInput(input);

    return ret;
}

/**
 * Loads a BMP file using specific color type
 *
 * Params:
 *      input       =   Input range that returns the files bytes
 *      allocator   =   The allocator to use the allocate the image
 *
 * Returns:
 *      A BMP file, loaded as an image along with its headers. Using specified image storage type.
 */
managed!(BMPFileFormat!Color) loadBMP(Color, ImageImpl=ImageStorageHorizontal!Color, IR)(IR input, IAllocator allocator = theAllocator()) @trusted if (isInputRange!IR && is(ElementType!IR == ubyte) && isImage!ImageImpl) {
    managed!(BMPFileFormat!Color) ret = managed!(BMPFileFormat!Color)(managers(), tuple(allocator), allocator);

    ret.theImageAllocator = &ret.allocateTheImage!ImageImpl;
    ret.performInput(input);

    return ret;
}

struct BMP_FileHeader {
    ushort fileType;
    uint fileSize;
    short reserved1, reserved2;
    uint bitmapOffset;
}

struct BMP_InfoHeader {
    uint size;
    uint width, height;
    ushort planes;
    ushort bitsPerPixel;
    uint compression;
    uint sizeOfBitmap;
    int horizontalResolution;
    int verticalResolution;
    uint colorsUsed;
    uint colorsImp;
}




