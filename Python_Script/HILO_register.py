HILO_result = 0
LO_value = 0
HI_value = 0

"""
    Set HILO register to zero during reset.
"""
def reset_hilo(reset):
    if reset:
        HILO_result = 0
        HI_value = 0
        LO_value = 0


"""
    Turn unsigned values to signed values. 
"""
def to_signed32(value):
    value &= 0xFFFFFFFF

    if value & 0x80000000:
        return value - 0x100000000

    return value


def display_hilo_value(value):
    value &= 0xFFFFFFFF

    if value & 0x80000000:
        return (f"0x{value:08X} (signed: {to_signed32(value)}, unsigned: {value})")

    return f"0x{value:08X} ({value})"


"""
    The HILO register takes the lower and higher 32-bit result of divider or multiplier and stores it.
"""
def hilo_register(result_main, control_signals):
    global HILO_result, LO_value, HI_value

    HILO_write = control_signals["HILO_write"]                                          # Read signal from control unit.

    if HILO_write:
        HILO_result = result_main & 0xFFFFFFFFFFFFFFFF                                  # Store the values.

        LO_value = HILO_result & 0xFFFFFFFF
        HI_value = (HILO_result >> 32) & 0xFFFFFFFF

        print("---------------HI/LO WRITE------------")
        print(f"HI = {display_hilo_value(HI_value)}")
        print(f"LO = {display_hilo_value(LO_value)}")
        print()

    return HI_value, LO_value