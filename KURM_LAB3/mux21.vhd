library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity mux21 is
    generic
    (
        WIDTH       : natural := 16
    );
    port
    (
        selector    :  in std_logic;
        input0      :  in std_logic_vector(WIDTH-1 downto 0);
        input1      :  in std_logic_vector(WIDTH-1 downto 0);
        output      : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity;

architecture structural of mux21 is
    signal input : std_logic_vector(2*WIDTH-1 downto 0);
begin
    input <= input1 & input0;

    mux21 : entity kurm.mux
    generic map
    (
        WIDTH       => WIDTH,
        CONTROL     => 1
    )
    port map
    (
        selector(0) => selector,
        input       => input,
        output      => output
    );
end architecture;
