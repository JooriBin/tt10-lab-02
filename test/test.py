# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

async def setup_clock(dut):
    """Set up a clock signal for synchronization."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())  # 100MHz clock
    await RisingEdge(dut.clk)

@cocotb.test()
async def test_priority_encoder(dut):
    """Test Priority Encoder functionality."""
    await setup_clock(dut)

    test_cases = [
        ((0b00101010, 0b11110001), 0b00001101),  # First '1' at index 13
        ((0b00000000, 0b00000001), 0b00000000),  # First '1' at index 0
        ((0b00000000, 0b00000000), 0b11110000)   # No '1's -> return 0xF0
    ]

    for (a, b), expected in test_cases:
        dut.ui_in.value = a
        dut.uio_in.value = b
        await RisingEdge(dut.clk)
        assert dut.uo_out.value == expected, f"Test failed for A={bin(a)}, B={bin(b)}. Expected {bin(expected)}, got {bin(dut.uo_out.value)}"
