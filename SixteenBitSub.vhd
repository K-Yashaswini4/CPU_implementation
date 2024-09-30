library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitSub is
  port (
    a    : in std_logic_vector (15 downto 0);
    b    : in std_logic_vector (15 downto 0);
    sub  : out std_logic_vector (15 downto 0);
    cout : out std_logic
  );
end SixteenBitSub;

architecture struct of SixteenBitSub is

  signal carry : std_logic_vector(16 downto 0);
  signal d : std_logic_vector(15 downto 0);

  component OneBitAdder is
    port (
      a, b, cin : in std_logic;
      sum, cout : out std_logic
    );
  end component OneBitAdder;

begin
  d<= not(b);
  carry(0) <= '1'; -- cin is 1

  sub_loop : for i in 0 to 15 generate
    bit_i : OneBitAdder
    port map(
      a    => a(i),
      b    => d(i),
      cin  => carry(i),
      sum  => sub(i),
      cout => carry(i + 1)
    );
  end generate sub_loop;
  cout <= carry(16);

end struct;