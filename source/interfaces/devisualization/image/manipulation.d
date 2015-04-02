module devisualization.image.manipulation;
import devisualization.image.color;
import devisualization.image.image;

/**
 * Acts as a foreach over the pixels based upon left to right.
 * 
 * Params:
 * 		image	=	The image
 * 		del		=	The delegate to call upon each pixel
 */
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

/**
 * Acts as a foreach over the pixels based upon top to bottom.
 * 
 * Params:
 * 		image	=	The image
 * 		del		=	The delegate to call upon each pixel
 */
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

/**
 * Flips an image vertically.
 *
 * Params:
 * 		_	=	The image to flip
 */
@property void flipVertical(Image _) {
	auto __ = _.rgba;
	size_t width = _.width;
	size_t height = _.height;
	
	size_t div2Height = height / 2;
	
	size_t offset;
	foreach(x; 0 .. width) {
		size_t i = offset;
		size_t i2 = i + (height - 1);
		
		foreach(y; 0 .. div2Height) {
			Color_RGBA to = __[i2];
			__[i2] = __[i];
			__[i] = to;
			
			i++;
			i2--;
		}
		
		offset += width;
	}
}

/**
 * Flips an image horizontally.
 *
 * Params:
 * 		_	=	The image to flip
 */
@property void flipHorizontal(Image _) {
	auto __ = _.rgba;
	size_t width = _.width;
	size_t height = _.height;

	size_t div2Width = width / 2;

	size_t offset;
	foreach(y; 0 .. height) {
		size_t i = offset;
		size_t i2 = i + (width - 1);

		foreach(x; 0 .. div2Width) {
			Color_RGBA to = __[i2];
			__[i2] = __[i];
			__[i] = to;

			i++;
			i2--;
		}

		offset += width;
	}
}

/**
 * Copies one image into another.
 * 
 * Params:
 * 		from		=	The image to copy from
 * 		into		=	The destination image
 * 		startx		=	Starting x coordinate to copy into. Default 0
 * 		starty		=	Starting y coordinate to copy into. Default 0
 */
void copyInto(Image from, Image into, size_t startx=0, size_t starty=0) {
	from.copyInto(into, startx, starty, from.width, from.height);
}

/**
 * Copies one image into another.
 * 
 * Params:
 * 		from		=	The image to copy from
 * 		into		=	The destination image
 * 		startx		=	Starting x coordinate to copy into
 * 		starty		=	Starting y coordinate to copy into
 * 		width		=	The amount of image to copy from
 * 		height		=	The amount of image to copy from
 */
void copyInto(Image from, Image into, size_t startx, size_t starty, size_t width, size_t height)
in {
	assert(startx + width < into.width);
	assert(starty + height < into.height);
} body {
	auto _ = from.rgba;
	auto __ = into.rgba;

	size_t x;
	foreach(x2; startx .. width) {
		size_t y;

		foreach(y2; starty .. height) {
			__[__.indexFromXY(x2, y2)] = _[_.indexFromXY(x, y)];

			y++;
		}

		x++;
	}
}