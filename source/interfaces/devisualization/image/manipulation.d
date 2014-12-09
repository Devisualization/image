module devisualization.image.manipulation;
import devisualization.image.color;
import devisualization.image.image;

void applyByX(Image image, void delegate(size_t x, size_t y) del) {
	foreach(x; 0 .. image.width) {
		foreach(y; 0 .. image.height) {
			del(x, y);
		}
	}
}

void applyByY(Image image, void delegate(size_t x, size_t y) del) {
	foreach(y; 0 .. image.height) {
		foreach(x; 0 .. image.width) {
			del(x, y);
		}
	}
}