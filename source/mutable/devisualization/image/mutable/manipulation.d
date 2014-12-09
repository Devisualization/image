module devisualization.image.mutable.manipulation;
import devisualization.image.mutable.image;
public import devisualization.image.manipulation;
import devisualization.image;

MutableImage resizeCrop(Image old, size_t newWidth, size_t newHeight, size_t startX = 0, size_t startY = 0) {
	MutableImage ret = new MutableImage(newWidth, newHeight);
	auto _ = ret.rgba;
	auto __ = old.rgba;

	size_t i;
	foreach(x; startX .. old.width) {
		foreach(y; startY .. old.height) {
			_[i] = __[__.indexFromXY(x, y)];
			i++;
		}
	}

	return ret;
}