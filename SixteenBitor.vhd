library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitor is
	port (a, b   : in std_logic_vector(15 downto 0);
		  output : out std_logic_vector(15 downto 0));
end entity;

architecture arch of SixteenBitor is
begin

	or_loop : for i in 0 to 15 generate
		output(i) <= (a(i) or b(i));
	end generate or_loop;

end architecture;
