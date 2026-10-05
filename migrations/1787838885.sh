echo "Set up keyd for the Logitech MX Keys / MX Keys S action keys"

OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"

# Machine-wide and idempotent: skip once the config is in place AND the service
# is enabled and running. The installer enables keyd only after its restart
# succeeds, and keyd may already have been enabled for another keyboard, so a
# run that failed partway (config written, restart failed) fails at least one
# of these checks and gets repaired on the next update.
[[ -f /etc/keyd/logitech-mx-keys.conf ]] && systemctl is-enabled --quiet keyd.service \
  && systemctl is-active --quiet keyd.service && exit 0

# Unprivileged pre-filter so machines with no MX Keys -- no Bolt receiver, no
# Unifying MX Keys, no Bluetooth MX Keys / MX Keys S / MX Keys Mini -- never
# reach the (password-prompting) hidraw probe. The anchored HID_NAME match
# keeps "MX Mechanical" out; the detector rejects it too.
grep -qEi 'HID_ID=0003:0000046D:0000C548|:0000408A|MX Keys S|HID_NAME=(Logitech )?MX Keys( Mini)?$' \
  /sys/class/hidraw/*/device/uevent 2>/dev/null || exit 0

source "$OMARCHY_PATH/install/hardware/logitech-mx-keys.sh"
