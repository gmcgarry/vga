#include <stdio.h>
#include <stdlib.h>

#define MHZ		1000000.0f
#define KHZ		1000.0f

#define DOTCLOCK	25175000.0f

#define LINEWIDTH	800	/* dot clocks */
#define DATAWIDTH	640
#define HSYNC		96
#define HFP		16
#define HBP		48

#define LINEHEIGHT	525	/* lines */
#define DATAHEIGHT	480
#define VSYNC		2
#define VFP		11
#define VBP		31

int
main(int argc, char *argv[])
{
	float freq = 11059200 / 12;

	if (argc > 1)
		freq = atof(argv[1]);

	printf("---------\n");

	printf("dot clock: %f MHz\n", DOTCLOCK / MHZ);
	printf("horizontal scan: %f kHz\n", DOTCLOCK / LINEWIDTH / KHZ);
	printf("vertical scan: %f Hz\n", DOTCLOCK / LINEWIDTH / LINEHEIGHT);
	printf("dimensions: %dx%d\n", DATAWIDTH, DATAHEIGHT);
	printf("  scanline: %d (%d)\n", LINEWIDTH, DATAWIDTH+HSYNC+HFP+HBP);
	printf("  frame: %d (%d)\n", LINEHEIGHT, DATAHEIGHT+VSYNC+VFP+VBP);
	printf("H: line width (%d): %f us\n", LINEWIDTH, LINEWIDTH / DOTCLOCK * MHZ);
	printf("H: data width (%d): %f us\n", DATAWIDTH, DATAWIDTH / DOTCLOCK * MHZ);
	printf("H: front porch (%d): %f us\n", HFP, HFP / DOTCLOCK * MHZ);
	printf("H: hsync pulse(%d): %f us\n", HSYNC, HSYNC / DOTCLOCK * MHZ);
	printf("H: back porch (%d): %f us\n", HBP, HBP / DOTCLOCK * MHZ);

	printf("V: frame height (%d): %f us\n", LINEHEIGHT, LINEHEIGHT * LINEWIDTH / DOTCLOCK * MHZ);
	printf("V: data height (%d): %f us\n", DATAHEIGHT, DATAHEIGHT * LINEWIDTH / DOTCLOCK * MHZ);
	printf("V: front porch (%d): %f us\n", VFP, VFP * LINEWIDTH / DOTCLOCK * MHZ);
	printf("V; vsync pulse (%d): %f us\n", VSYNC, VSYNC * LINEWIDTH / DOTCLOCK * MHZ);
	printf("V: back porch (%d): %f us\n", VBP, VBP * LINEWIDTH / DOTCLOCK * MHZ);

	printf("---------\n");

	printf("clock: %f MHz\n", freq / MHZ);
	printf("Tcycle: %f us\n", MHZ / freq);
	printf("H: scanline: %f Tcycles\n", freq * LINEWIDTH / DOTCLOCK);
	printf("H: data: %f Tcycles\n", freq * DATAWIDTH / DOTCLOCK);
	printf("H: front porch: %f Tcycles\n", freq * HFP / DOTCLOCK);
	printf("H: hsync: %f Tcycles\n", freq * HSYNC / DOTCLOCK);
	printf("H: back porch: %f Tcycles\n", freq * HBP / DOTCLOCK);
	printf("---------\n");

	return 0;
}
