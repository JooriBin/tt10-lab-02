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
    """Test Priority Encoder (Problem 2)"""
    await setup_clock(dut)

    test_cases = [
        (0b0010101011110001, 0b00001011),  # In = 0010 1010 1111 0001 → C = 13 (0000 1011)
        (0b0000000000000001, 0b00000000),  # In = 0000 0000 0000 0001 → C = 0
        (0b0000000000000000, 0b11110000)   # In = 0000 0000 0000 0000 → C = 0xF0
    ]

    for in_value, expected in test_cases:
        dut.ui_in.value = in_value  # Assign test input
        await RisingEdge(dut.clk)   # Wait for clock cycle
        assert dut.uo_out.value == expected, f"Failed for input {bin(in_value)}"

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
