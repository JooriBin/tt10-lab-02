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

    dut._log.info("Testing priority encoder behavior")

    # Test case 1: Only LSB is 1
    dut._log.info("Test case 1: Only bit 0 is 1")
    dut.ui_in.value = 0b00000000  # Bits [15:8]
    dut.uio_in.value = 0b00000001  # Bits [7:0]
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0, f"Expected 0, got {dut.uo_out.value}"

    # Test case 2: Only MSB is 1
    dut._log.info("Test case 2: Only bit 15 is 1")
    dut.ui_in.value = 0b10000000  # Bits [15:8]
    dut.uio_in.value = 0b00000000  # Bits [7:0]
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 15, f"Expected 15, got {dut.uo_out.value}"

    # Test case 3: First '1' at bit 10
    dut._log.info("Test case 3: First '1' at bit 10")
    dut.ui_in.value = 0b00000100  # Bits [15:8]
    dut.uio_in.value = 0b00000000  # Bits [7:0]
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 10, f"Expected 10, got {dut.uo_out.value}"

    # Test case 4: First '1' at bit 5
    dut._log.info("Test case 4: First '1' at bit 5")
    dut.ui_in.value = 0b00000000  # Bits [15:8]
    dut.uio_in.value = 0b00100000  # Bits [7:0]
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 5, f"Expected 5, got {dut.uo_out.value}"

    # Test case 5: Multiple bits set, highest at 13
    dut._log.info("Test case 5: Multiple bits set, first at 13")
    dut.ui_in.value = 0b00101010  # Bits [15:8]
    dut.uio_in.value = 0b11110001  # Bits [7:0]
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 13, f"Expected 13, got {dut.uo_out.value}"

    # Test case 6: Only middle bit is 1 (bit 8)
    dut._log.info("Test case 6: Only bit 8 is 1")
    dut.ui_in.value = 0b00000000  # Bits [15:8]
    dut.uio_in.value = 0b10000000  # Bits [7:0]
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 7, f"Expected 8, got {dut.uo_out.value}"

    # Test case 7: No bits are set (special case)
    dut._log.info("Test case 7: No bits are set")
    dut.ui_in.value = 0b00000000  # Bits [15:8]
    dut.uio_in.value = 0b00000000  # Bits [7:0]
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0xF0, f"Expected 0xF0, got {dut.uo_out.value}"
