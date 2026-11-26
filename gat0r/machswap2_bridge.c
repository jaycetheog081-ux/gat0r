// machswap2 bridge scaffold.
// The actual machswap2 source is not currently present in this repository.

#include "machswap2_bridge.h"
#include <mach/mach.h>

ExploitResult machswap2_run(void) {
    ExploitResult result = {
        .tfp0 = MACH_PORT_NULL,
        .success = false,
        .error_msg = "machswap2 backend is not included in this build"
    };

    return result;
}

bool machswap2_validate_tfp0(mach_port_t tfp0) {
    (void)tfp0;
    return false;
}
