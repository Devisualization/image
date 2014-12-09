module devisualization.image.manipulation;
import devisualization.image.color;
import devisualization.image.image;

void applyByX(Image image, void delegate(Color_RGBA pixel, size_t x, size_t y) del) {
	auto _ = image.rgba;

	size_t i;
	foreach(x; 0 .. image.width) {
		foreach(y; 0 .. image.height) {
			del(_[i], x, y);
			i++;
		}
	}
}

void applyByY(Image image, void delegate(Color_RGBA pixel, size_t x, size_t y) del) {
	auto _ = image.rgba;

	size_t i;
	foreach(y; 0 .. image.height) {
		foreach(x; 0 .. image.width) {
			del(_[i], x, y);
			i++;
		}
	}
}