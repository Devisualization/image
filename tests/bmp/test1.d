module tests.bmp.test1;
import tests.defs;
import devisualization.image;
import std.file : read, write, remove;
import std.path : baseName;

void bmp_test1(string checkStatements)(string file, bool mustBeExact) {
    void check(Image)(ref Image image) {
        mixin(checkStatements);
    }

    entryTest(file);
    testOutput(baseName(file).tempLocation);

    testOutput("header check");
    auto headerImage = loadBMPHeaders(cast(ubyte[])read(file));
    check(headerImage);

    // import 1
    testOutput("import 1");
    auto image1 = loadBMP!RGBA16(cast(ubyte[])read(file));
    check(image1);
}

unittest {
    /+bmp_test1!q{
    }("tests/bmp/assets/x/ba-bm.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal1huff.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8os2v2-40sz.bmp", true);+/

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/q/rgba32h56.bmp", true);+/

    bmp_test1!q{
    }("tests/bmp/assets/q/rgb24largepal.bmp", true);

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8os2v2.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/rgb16faketrns.bmp", true);+/

    /+We don't support PNG embedding
    bmp_test1!q{
    }("tests/bmp/assets/q/rgb24png.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal4rletrns.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8rletrns.bmp", true);+/

    bmp_test1!q{
    }("tests/bmp/assets/q/rgb24prof.bmp", true);

    bmp_test1!q{
    }("tests/bmp/assets/q/rgb32fakealpha.bmp", true);

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/q/rgba32-61754.bmp", true);+/

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/q/rgba32-81284.bmp", true);+/

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/q/rgb32-7187.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/rgb16-231.bmp", true);+/

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/q/rgba32-1010102.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/rgba16-5551.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8os2v2-sz.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8os2-hs.bmp", true);+/

    bmp_test1!q{
    }("tests/bmp/assets/q/rgb24prof2.bmp", true);

    /+We don't support JPEG embedding
    bmp_test1!q{
    }("tests/bmp/assets/q/rgb24jpeg.bmp", true);+/

    /+compress 6
    bmp_test1!q{
    }("tests/bmp/assets/q/rgba32abf.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8rlecut.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal2color.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8os2v2-16.bmp", true);+/

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/q/rgb32h52.bmp", true);+/

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/q/rgb32-111110.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal4rlecut.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/rgba16-4444.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8os2sp.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/rgba16-1924.bmp", true);+/

    bmp_test1!q{
    }("tests/bmp/assets/q/rgb24lprof.bmp", true);

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8offs.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal1p1.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/rgb16-3103.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8oversizepal.bmp", true);+/

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/q/rgba32.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal2.bmp", true);+/

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/q/rgb32-xbgr.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/q/pal8os2-sz.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badrlebis.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badbitssize.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badpalettesize.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badrle4bis.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badbitcount.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badfilesize.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badplanes.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/baddens1.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badrle4ter.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badwidth.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/baddens2.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/pal8badindex.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badrle4.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/shortfile.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/rletopdown.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badrleter.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badheadersize.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/rgb16-880.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/reallybig.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/b/badrle.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal1.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8w124.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal4.bmp", true);+/

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/g/rgb32bf.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8-0.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8.bmp", true);+/

    bmp_test1!q{
    }("tests/bmp/assets/g/rgb32.bmp", true);

    /+bmp_test1!q{
    }("tests/bmp/assets/g/rgb16-565pal.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8w126.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal1bg.bmp", true);+/

    bmp_test1!q{
    }("tests/bmp/assets/g/rgb24pal.bmp", true);

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8os2.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/rgb16bfdef.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal1wb.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8topdown.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8w125.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8v4.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8gs.bmp", true);+/

    bmp_test1!q{
    }("tests/bmp/assets/g/rgb24.bmp", true);

    /+compress 3
    bmp_test1!q{
    }("tests/bmp/assets/g/rgb32bfdef.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal4rle.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/rgb16.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal4gs.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8rle.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/rgb16-565.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8v5.bmp", true);+/

    /+bmp_test1!q{
    }("tests/bmp/assets/g/pal8nonsquare.bmp", true);+/
}
