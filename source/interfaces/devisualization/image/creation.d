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

private {
    __gshared Image delegate(ubyte[])[string] loaders;
}

void registerImageLoader(string ext, Image delegate(ubyte[] data) loader) {
    loaders[ext] = loader;
}