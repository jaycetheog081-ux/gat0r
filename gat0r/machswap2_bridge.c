// language: C, file: machswap2_bridge.c, target: iOS 11

#include "machswap2_bridge.h"
#include "machswap2/exploit.h"   // machswap2 internal header
#include <mach/mach.h>
#include <stdio.h>

// machswap2 exposes: kern_return_t do_exploit(mach_port_t *tfp0_out);
// If your copy exposes a different symbol, adjust here.

ExploitResult machswap2_run(void) {
    ExploitResult result = { .tfp0 = MACH_PORT_NULL, .success = false, .error_msg = "" };

    mach_port_t tfp0 = MACH_PORT_NULL;
    kern_return_t kr = do_exploit(&tfp0);

    if (kr != KERN_SUCCESS || !MACH_PORT_VALID(tfp0)) {
        result.error_msg = "machswap2: exploit failed";
        return result;
    }

    result.tfp0    = tfp0;
    result.success = true;
    return result;
}

bool machswap2_validate_tfp0(mach_port_t tfp0) {
    if (!MACH_PORT_VALID(tfp0)) return false;

    // Read kernel_task address from fixed offset — sanity ping only
    // Offset is device/version specific; 0 here is a placeholder
    // Replace with actual kernel_task symbol offset after kASLR slide resolution
    uint64_t val = 0;
    mach_vm_size_t out_size = 0;
    kern_return_t kr = mach_vm_read_overwrite(
        tfp0,
        (mach_vm_address_t)0xfffffff007004000ULL, // placeholder — slide this
        sizeof(val),
        (mach_vm_address_t)&val,
        &out_size
    );
    return (kr == KERN_SUCCESS && out_size == sizeof(val));
}
