#include "../drivers/video.h"

void main() {
    int col = 30;
    int row = 10;
    char* message = "XD";

    clear_screen();
    kprint_at(message, col, row, WHITE_ON_BLACK);
    kprint(message, WHITE_ON_BLACK);
}
