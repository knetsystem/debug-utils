#!/bin/bash

# More solid external connectivity check

# Chosen big companies that have core operations with networking, so at least one of them should always be online
# Most are international with servers all over the world, but often with base in the U.S.
hosts=(google.com cloudflare.com facebook.com amazon.com azure.microsoft.com ibm.com alibabacloud.com akamai.com linode.com fastly.net redhat.com oracle.com ovh.com)

# Check at most 3 randomly chosen from the list above
for i in {1..3}
do
    HOST=${hosts[$(( ( RANDOM % 13 ) ))]}
    # Ping test
    ping -c 1 $HOST 2>&1 >/dev/null
    EXITCODE=$?

    # If any ping succeeded, then we exit with success
    if [[ $EXITCODE == 0 ]]
    then
        exit 0
    fi
done

# No ping worked, something must be wrong, exit with error code
exit 1
