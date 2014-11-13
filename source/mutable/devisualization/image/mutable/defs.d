module devisualization.image.mutable.defs;
import devisualization.image;
import devisualization.image.mutable.image;

MutableImage makeMutable(Image image) {
    return new MutableImage(image.width, image.height, image.rgba.allPixels);
}