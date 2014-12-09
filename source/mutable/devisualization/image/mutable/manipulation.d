module devisualization.image.mutable.manipulation;
import devisualization.image.mutable.image;
public import devisualization.image.manipulation;
import devisualization.image;

MutableImage resizeCrop(Image old, size_t newWidth, size_t newHeight, size_t startX = 0, size_t startY = 0) {
	MutableImage ret = new MutableImage(newWidth, newHeight);
	auto _ = ret.rgba;
	auto __ = old.rgba;

	size_t xx;
	size_t yy;

	size_t endY = startY + newHeight;
	if (endY > old.height)
		endY = old.height;

	foreach(y; startY .. endY) {
		xx = 0;

		size_t endX = startX + newWidth;
		if (endX > old.width)
			endX = old.width;

		foreach(x; startX .. endX) {
			_[_.indexFromXY(xx, yy)] = __[__.indexFromXY(x, y)];

			xx++;
		}

		yy++;
	}

	return ret;
}