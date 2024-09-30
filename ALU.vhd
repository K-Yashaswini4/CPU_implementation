library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port (
		a, b        : in std_logic_vector(15 downto 0);
		s          : in std_logic_vector(2 downto 0);
		c           : out std_logic_vector(15 downto 0);
		zero, carry : out std_logic
	);
end ALU;

architecture struct of ALU is

	signal cout1,cout2,carry1,carry2 : std_logic:='0';
	signal addition_result, and_result, or_result, imp_result, sub_result, Mul_result, temp : std_logic_vector(15 downto 0):=(others=>'0');

	component SixteenBitAdder is
		port (
			a    : in std_logic_vector (15 downto 0);
			b    : in std_logic_vector (15 downto 0);
			sum  : out std_logic_vector (15 downto 0);
			cout : out std_logic
		);
	end component SixteenBitAdder;
	
   component SixteenBitSub is
      port (
		   a    : in std_logic_vector (15 downto 0);
			b    : in std_logic_vector (15 downto 0);
			sub  : out std_logic_vector (15 downto 0);
			cout : out std_logic
			);
	end component SixteenBitSub;		
	component SixteenBitand is
		port (
			a, b   : in std_logic_vector(15 downto 0);
			output : out std_logic_vector(15 downto 0)
		);
	end component SixteenBitand;
	component SixteenBitor is
		port (
			a, b   : in std_logic_vector(15 downto 0);
			output : out std_logic_vector(15 downto 0)
		);
	end component SixteenBitor;
	component SixteenBitimp is
		port (
			a, b   : in std_logic_vector(15 downto 0);
			output : out std_logic_vector(15 downto 0)
		);
	end component SixteenBitimp;
   component Multiplier is
      port (A: in std_logic_vector(15 downto 0);B: in std_logic_vector(15 downto 0);M:out std_logic_vector(15 downto 0));
   end component Multiplier;

	component MUX16_6x1 is
		port (
			a, b,c,d,e,f : in std_logic_vector(15 downto 0);
			s2,s1,s0   : in std_logic;
			y    : out std_logic_vector(15 downto 0)
		);
	end component MUX16_6x1;

begin

	op_add : SixteenBitAdder
	port map(
		a    => a,
		b    => b,
		sum  => addition_result,
		cout => cout1
	);

	carry1 <= cout1 and (not(s(2) or s(1) or s(0)));
   op_sub : SixteenBitSub
	port map(
		a    => a,
		b    => b,
		sub  => sub_result,
		cout => cout2
	);
	carry2 <= cout2 and (not s(2)) and (not s(1)) and  s(0);
	op_and : SixteenBitand
	port map(
		-- in
		a => a, b => b,
		-- out
		output => and_result
	);
   op_or : SixteenBitor
	port map(
		-- in
		a => a, b => b,
		-- out
		output => or_result
	);
	op_Mul : Multiplier
	port map(
		-- in
		A => a, B => b,
		-- out
		M => Mul_result
	);
	op_imp : SixteenBitimp
	port map(
		-- in
		a => a, b => b,
		-- out
		output => imp_result
	);
	-- If op = 1, then return nand result, else return addition result
	selector : MUX16_6x1
	port map(
		-- in
		a => addition_result, b => sub_result, c=>Mul_result, d=>and_result, e=>or_result, f=>imp_result,
		-- select
		s2=>s(2),s1 => s(1),s0=>s(0),
		-- out
		y => temp
	);

	-- zero is 1 iff all bits of the c are 0
	zero <= not(
		temp(0) or temp(1) or temp(2) or temp(3) or
		temp(4) or temp(5) or temp(6) or temp(7) or
		temp(8) or temp(9) or temp(10) or temp(11) or
		temp(12) or temp(13) or temp(14) or temp(15)
		);

	c <= temp;
   carry<= carry1 or carry2;
end architecture;
