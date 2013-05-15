-------------------------------------------------------------------------------
-- Word / Bit Logic
--
-- Author:      Perry Alexander
--              Wesley Peck
-- Version:     2.0
-- Date:        Wed Mar  7 23:57:14 EST 2001
-- Uses:
--
-- Objective: Define a collection of components that perform a logical
--   operation on a word and a single bit.
--
-- Usage:
-- For all entities, the first port is an arbitrary length bit vector
--   and the second is a single bit.  The third port is the result of
--   applying the logical operation between each bit in the first argument with
--   the single bit in the second.
-- All entities accept arbitrary length words.
-- All entities have a generic parameter to control delay time.
--
-- Change Log:
-- v1.0:    Initial Design
-- V2.0:    Changed design to be synthesizable
--          - Added library use clauses for std_logic support
--          - Removed delays
--          - Redesigned to use std_logic instead of bit
--          - Removed wait statements and added sensitivity lists
-------------------------------------------------------------------------------
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

-------------------------------------------------------------------------------
-- System Entity
-------------------------------------------------------------------------------
entity clock is 
    port
    (
        sys_clk :  in std_logic;
        sys_rst :  in std_logic;
        clk     : out std_logic;
        clk2x   : out std_logic;
        rst     : out std_logic
    );
end entity clock;

-------------------------------------------------------------------------------
-- System Architecture
-------------------------------------------------------------------------------
architecture mixed of clock is
    signal clk0       : std_logic;
    signal clkfx      : std_logic;
    signal clkrst     : std_logic;
    signal sysclk_buf : std_logic;
begin
    rst    <= clkrst;
    clkrst <= not sys_rst;

    bufg_i : BUFG
    port map
    (
        I => clk0,
        O => clk
    );
    
    bufg_2i : BUFG
    port map
    (
        I => clkfx,
        O => clk2x
    );

    bufg_in : BUFG
    port map
    (
        I => sys_clk,
        O => sysclk_buf
    );
    
    dcm_i : DCM
    generic map
    (
        CLKDV_DIVIDE            => 2.0,
        CLKFX_DIVIDE            => 1,
        CLKFX_MULTIPLY          => 2,
        CLKIN_DIVIDE_BY_2       => FALSE,
        CLKIN_PERIOD            => 10.0,
        CLKOUT_PHASE_SHIFT      => "NONE",
        CLK_FEEDBACK            => "1X",
        DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS",
        DFS_FREQUENCY_MODE      => "HIGH",
        DLL_FREQUENCY_MODE      => "LOW",
        DUTY_CYCLE_CORRECTION   => TRUE,
        FACTORY_JF              => X"F0F0",
        PHASE_SHIFT             => 0,
        STARTUP_WAIT            => FALSE
    )
    port map
    (
        CLK0        => clk0,        -- 0 degree DCM CLK ouptput
        CLK180      => open,        -- 180 degree DCM CLK output
        CLK270      => open,        -- 270 degree DCM CLK output
        CLK2X       => open,        -- 2X DCM CLK output
        CLK2X180    => open,        -- 2X, 180 degree DCM CLK out
        CLK90       => open,        -- 90 degree DCM CLK output
        CLKDV       => open,        -- Divided DCM CLK out (CLKDV_DIVIDE)
        CLKFX       => clkfx,       -- DCM CLK synthesis out (M/D)
        CLKFX180    => open,        -- 180 degree CLK synthesis out
        LOCKED      => open,        -- DCM LOCK status output
        PSDONE      => open,        -- Dynamic phase adjust done output
        STATUS      => open,        -- 8-bit DCM status bits output
        CLKFB       => clk0,        -- DCM clock feedback
        CLKIN       => sysclk_buf,  -- Clock input (from IBUFG, BUFG or DCM)
        PSCLK       => '0',         -- Dynamic phase adjust clock input
        PSEN        => '0',         -- Dynamic phase adjust enable input
        PSINCDEC    => '0',         -- Dynamic phase adjust increment/decrement
        RST         => '0'          -- DCM asynchronous reset input
    );
end architecture mixed;

