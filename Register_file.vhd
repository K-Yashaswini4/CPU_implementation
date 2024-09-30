
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 


entity Register_file is
port (
 clk: in std_logic;
 write_flag1,write_flag2,reset: in std_logic;
 a1: in std_logic_vector(2 downto 0);
 a2: in std_logic_vector(2 downto 0);
 a3: in std_logic_vector(2 downto 0);
 d3,PC_in: in std_logic_vector(15 downto 0);
 d1: out std_logic_vector(15 downto 0);
 d2,PC_OUT: out std_logic_vector(15 downto 0);
 R0,R1,R2,R3,R4,R5,R6: out std_logic_vector(15 downto 0)
);
 
end Register_file;

architecture Behavioral of Register_file is
type reg_type is array (7 downto 0) of std_logic_vector (15 downto 0);
signal reg_array: reg_type := (0=>x"0011" ,1=>x"0001", 2=>x"0101" ,3=>x"0002" ,4=>x"0020" ,5=>x"0003",6=>x"0011",others => "0000000000000000");

begin
process(a1,a2,clk,pc_in,write_flag1,write_flag2,reset)
   begin
	
d1 <= reg_array(to_integer(unsigned(a1)));
d2 <= reg_array(to_integer(unsigned(a2)));

end process;

Mem_write: process (write_flag1,write_flag2, d3, a1, a2 ,clk)
	begin
	
	if(rising_edge(clk)) then
	
		if(write_flag1='1') then
		
			   reg_array(to_integer(unsigned(a3))) <= d3;
			
	   end if;
	 
	   if(write_flag2 ='1') then
	
            reg_array(7)<=PC_in;--storing PC in R7
		
		end if;
	end if;
	if(reset='1') then
	reg_array<= (0=>x"0011" ,1=>x"0001", 2=>x"0101" ,
	3=>x"0002" ,4=>x"0020" ,5=>x"0003",6=>x"0011",others => "0000000000000000");
   end if;
	
	end process;
PC_OUT<=reg_array(7);--storing PC in R7
R0<=reg_array(0);
R1<=reg_array(1);
R2<=reg_array(2);
R3<=reg_array(3);
R4<=reg_array(4);
R5<=reg_array(5);
R6<=reg_array(6);

end Behavioral;
