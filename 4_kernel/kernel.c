void main() {
    char* video_memory = (char*) 0xb8000;
    char msg[6] = "Kernel";
    char white_on_red = 0x4f;
    
    for (int i = 0; i < 6; i++) {
        *(video_memory + (2*i)) = msg[i];
        *(video_memory + (1 + 2*i)) = white_on_red;
    }
}

