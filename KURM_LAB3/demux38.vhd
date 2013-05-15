library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library kurm;
use kurm.common.all;

entity demux38 is
    port
    (
        selector    :  in std_logic_vector(2 downto 0);
        input       :  in std_logic;
        output0     : out std_logic;
        output1     : out std_logic;
        output2     : out std_logic;
        output3     : out std_logic;
        output4     : out std_logic;
        output5     : out std_logic;
        output6     : out std_logic;
        output7     : out std_logic
    );
end entity;

architecture structural of demux38 is
    signal output : std_logic_vector(7 downto 0);
begin
    output0 <= output(0);
    output1 <= output(1);
    output2 <= output(2);
    output3 <= output(3);
    output4 <= output(4);
    output5 <= output(5);
    output6 <= output(6);
    output7 <= output(7);

    demux38 : entity kurm.demux
    generic map
    (
        WIDTH       => 1,
        CONTROL     => 3
    )
    port map
    (
        selector    => selector,
        input(0)    => input,
        output      => output
    );
end architecture;
