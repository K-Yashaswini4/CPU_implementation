library ieee;
use ieee.std_logic_1164.all;

entity Testbench_mul is
end entity Testbench_mul;

architecture beh of Testbench_mul is
component Multiplier is
port (A: in std_logic_vector(15 downto 0);B: in std_logic_vector(15 downto 0);M:out std_logic_vector(15 downto 0));
end component Multiplier;

signal AT,BT,MT:std_logic_vector(15 downto 0);

begin

AT<="0000000000001011";
BT<="0000000000000110";
dut_instance:Multiplier port map (AT,BT,MT);
end beh;
