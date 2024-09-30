library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity mux is
port (I:in std_logic_vector(1 downto 0);S:in std_logic;Y:out std_logic);
end entity mux;

architecture Struct of mux is
signal S_BAR,a1,a2:std_logic;
begin
IN1:INVERTER port map (A=>S,Y=>S_BAR);
AND1:AND_2 port map (A=> I(0),B=> S_BAR,Y=> a1);
AND2:AND_2 port map (A=> I(1),B=> S,Y=> a2);
OR1:OR_2 port map (A=>a1,B=>a2,Y=>Y);
end Struct;