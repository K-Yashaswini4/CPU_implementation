library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitimp is
	port (a, b   : in std_logic_vector(15 downto 0);
		  output : out std_logic_vector(15 downto 0));
end entity;

architecture arch of SixteenBitimp is
begin

	imp_loop : for i in 0 to 15 generate
		output(i) <= not(a(i)) or b(i);
	end generate imp_loop;

end architecture;
