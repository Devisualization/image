module devisualization.image.mutable;
public import devisualization.image.mutable.image;

shared static this() {
    import devisualization.image;

    Image converter(Image data) {
        return new MutableImage(data);
    }

    registerImageConvertTo("mutable", &converter);
}