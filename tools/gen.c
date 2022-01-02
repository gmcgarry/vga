/* generate VGA scanlines */

#include <stdio.h>

#include "font.h"
#include "font-4x6.h"
#include "font-4x7.h"
#include "font-5x8.h"

#define FONT_4x6	0
#define FONT_4x7	1
#define FONT_5x8	2

font_t fonts[] = {
    [FONT_4x6] = {
        .char_width = 4,
        .char_height = 6,
        .font_name = "4x6",
        .font_bitmap = &console_font_4x6[0]
    },
    [FONT_4x7] = {
        .char_width = 4,
        .char_height = 7,
        .font_name = "4x7",
        .font_bitmap = &console_font_4x7[0]
    },
    [FONT_5x8] = {
        .char_width = 5,
        .char_height = 8,
        .font_name = "5x8",
        .font_bitmap = &console_font_5x8[1]
    },
};


void
emit(int font, int width, int height, int duplines, void (*sync)(int row, int duplines))
{
	int ch_width = fonts[font].char_width;
	int ch_height = fonts[font].char_height;
	unsigned char *pixels = fonts[font].font_bitmap;

	int ch_size = (ch_width + 7) / 8;

	for (int row = 0; row < height; row += duplines) {
		int r = (row / duplines) % ch_height;
		int col = 0;
		printf("\t; row %d\n", row+1);
		printf("row%d:\n", row);
		for (; col < width; col++) {
			int c = col % ch_width;
			int ch = (col / ch_width) % 10 + '0';
			int shift = (ch_size*8) - 1 - c;
			unsigned char *p = pixels + ch_height * ch_size * ch + (r * ch_size);
//			printf("; p = %p (ch_height=%d,ch_size=%d,ch_width=%d,ch=%d,r=%d,shift=%d\n", p, ch_height, ch_size,ch_width,ch,r,shift);
			unsigned int line = *p;
			int bit = (line >> shift) & 1;
			printf("\t%s ; %d ('%c',0x%x,%d)\n", bit ? "point" : "blank", col+1, ch, line, c);
		}
		for (; col < width; col++)
			printf("\tblank ; %d\n", col+1);
		sync(row, duplines);
	}

}

void
sync4mhz(int row, int duplines)
{
	printf("\tnop           ; 26 ; front porch\n");
	printf("\tHSync         ; 27-29\n");
	printf("\tnop           ; 28 ; back porch\n");
	printf("\tnop           ; 29\n");
	printf("\tnop           ; 30\n");
	printf("\tnop           ; 31\n");
	printf("\tnop           ; 32\n");
}

void
sync20mhz(int row, int duplines)
{
	printf("\tblank         ; 128 ; front porch\n");
	printf("\tnop           ; 129\n");
	printf("\tnop           ; 130\n");
	printf("\tHSync         ; 131-149\n");
//	printf("\tcall BackPorch; 150-159 ; back porch\n");
	printf("\tcall Delay1uS ; 150-154 ; back porch\n");
	printf("\tnop           ; 155\n");
	printf("\tmovlw %d      ; 156\n", duplines);
	printf("\tdecfsz LCount0; 157\n");
	printf("\tgoto row%d	; 158,159\n", row);
	printf("\tmovwf LCount0 ; 159\n");
}

int
main(int argc, char *argv[])
{

//	emit(FONT_5x8, 127, 6, 5, sync20mhz);
	emit(FONT_4x6, 127, 6*5, 5, sync20mhz);
//	emit(FONT_4x7, 25, 7, 5, sync4mhz);

	return 0;
}
