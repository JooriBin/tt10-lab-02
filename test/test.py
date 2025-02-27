# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Testing Priority Encoder")

    # Test cases (input A, input B, expected output)
    test_cases = [
        (0b00101010, 0b11110001, 0b00001011),  # First '1' at index 13
        (0b00000000, 0b00000001, 0b00000000),  # First '1' at index 0
        (0b00000000, 0b00000000, 0b11110000)   # No '1's -> return 0xF0
    ]

    for a, b, expected in test_cases:
        dut.ui_in.value = a
        dut.uio_in.value = b

        # Wait for one clock cycle
        await ClockCycles(dut.clk, 1)

        # Assert the expected output
        assert dut.uo_out.value == expected, (
            f"Test failed for A={bin(a)}, B={bin(b)}. "
            f"Expected {bin(expected)}, got {bin(dut.uo_out.value)}"
        )
