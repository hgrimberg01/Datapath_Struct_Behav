library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity demux416 is
    port
    (
        selector    :  in std_logic_vector(3 downto 0);
        input       :  in std_logic;
        output0     : out std_logic;
        output1     : out std_logic;
        output2     : out std_logic;
        output3     : out std_logic;
        output4     : out std_logic;
        output5     : out std_logic;
        output6     : out std_logic;
        output7     : out std_logic;
        output8     : out std_logic;
        output9     : out std_logic;
        output10    : out std_logic;
        output11    : out std_logic;
        output12    : out std_logic;
        output13    : out std_logic;
        output14    : out std_logic;
        output15    : out std_logic
    );
end entity;

architecture structural of demux416 is
    signal output : std_logic_vector(15 downto 0);
begin
    output0  <= output(0);
    output1  <= output(1);
    output2  <= output(2);
    output3  <= output(3);
    output4  <= output(4);
    output5  <= output(5);
    output6  <= output(6);
    output7  <= output(7);
    output8  <= output(8);
    output9  <= output(9);
    output10 <= output(10);
    output11 <= output(11);
    output12 <= output(12);
    output13 <= output(13);
    output14 <= output(14);
    output15 <= output(15);

    demux416 : entity kurm.demux
    generic map
    (
        WIDTH       => 1,
        CONTROL     => 4
    )
    port map
    (
        selector    => selector,
        input(0)    => input,
        output      => output
    );
end architecture;
