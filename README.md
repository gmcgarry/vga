Original repository can be found at https://github.com/gmcgarry/vga

# VGA + MCU signalling

Driving VGA displays from microcontrollers.  See the source code for pin configurations.

## Clock Stability

If you're seeing "fuzzy" or "shimmering" pixels, then this is an indication of an
unstable clock.  This is usually visible when using internal RC oscillators.

Switching to a crystal oscillator improve the clock stability and eliminates the
visual artefacts.
