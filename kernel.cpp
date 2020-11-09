#include "types.h"

extern "C" void printf(char* str)
{
    uint16_t* videoMemory = (uint16_t*)0xb8000;
    for(int32_t i = 0; str[i] != '\0'; ++i)
        videoMemory[i] = (videoMemory[i] & 0xFF00) | str[i];
}

// Handles running constructors
typedef void (*constructor)();
extern "C" constructor start_ctors;
extern "C" constructor end_ctors;
extern "C" void init_ctors()
{
    for(constructor* i = &start_ctors; i != &end_ctors; i++)
        (*i)(); // Dereference and call constructor
}

extern "C" void torii_main(void* multiboot_structure, uint32_t* magic_number)
{
    printf("Welcome to Torii OS!");

    while(true);
}