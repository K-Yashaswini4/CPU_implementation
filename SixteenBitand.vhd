library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitand is
	port (a, b   : in std_logic_vector(15 downto 0);
		  output : out std_logic_vector(15 downto 0));
end entity;

architecture arch of SixteenBitand is
begin

	and_loop : for i in 0 to 15 generate
		output(i) <= (a(i) and b(i));
	end generate and_loop;

end architecture;
