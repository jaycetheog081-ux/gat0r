// language: C, file: machswap2_bridge.h, target: iOS 11, Clang/MSVC

#ifndef MACHSWAP2_BRIDGE_H
#define MACHSWAP2_BRIDGE_H

#include <mach/mach.h>
#include <stdbool.h>
#include <stdint.h>

// Result structure returned to Swift
typedef struct {
    mach_port_t tfp0;        // kernel task port — valid if success == true
    bool        success;
    const char* error_msg;   // static string, do not free
} ExploitResult;

// Entry point — call from Swift via bridge
// Runs machswap2 exploit, populates ExploitResult
ExploitResult machswap2_run(void);

// Optional: validate tfp0 is live by reading a known kernel address
bool machswap2_validate_tfp0(mach_port_t tfp0);

#endif // MACHSWAP2_BRIDGE_H
