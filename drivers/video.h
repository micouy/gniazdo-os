#define VGA_MEMORY 0xb8000
#define SCREEN_CTRL_PORT 0x3d4
#define SCREEN_DATA_PORT 0x3d5
#define SCREEN_HEIGHT 25
#define SCREEN_WIDTH 80
#define WHITE_ON_BLACK 0x0f
#define RED_ON_WHITE 0xf4

void clear_screen();
void kprint_at(char* message, int col, int row, char style);
void kprint(char* message, char style);
