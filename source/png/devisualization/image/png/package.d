module devisualization.image.png;
public import devisualization.image.png.chunks;
public import devisualization.image.png.defs;

shared static this() {
    import devisualization.image;

    Image loader(ubyte[] data) {
        return new PngImage(data);
    }

    registerImageLoader("png", &loader);
}