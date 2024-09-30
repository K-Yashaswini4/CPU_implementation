library ieee;
use ieee.std_logic_1164.all;


entity LHI  is
  port (LH_IN: in std_logic_vector(8 downto 0); LH_OUT: out std_logic_vector(15 downto 0));
end entity LHI;

architecture bhv of LHI is
begin
  LH_OUT(15 downto 0) <=  LH_IN(8 downto 0)& "0000000";
end architecture;