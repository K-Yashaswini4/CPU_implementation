

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 

entity Memory is 
	port (addr,data_write: in std_logic_vector(15 downto 0); switch : in std_logic_vector(7 downto 0);
	clk,write_flag,read_flag,reset: in std_logic;
				data_read: out std_logic_vector(15 downto 0);
				mem_loc: out std_logic_vector(15 downto 0));
end entity;

architecture Form of Memory is 
type RAMarray is array(255 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
signal RAM: RAMarray:=( 0=>"0000111000110000", 
                        1=>"0010000111010000", 
								2=>"0001000100000100",
								3=>"0011000001010000",
								4=>"0100000100110000",
								5=>"0101010100011000",
								6=>"0110000001010000",
								
								7=>"1000001000000000",
								8=>"1001110000101010",
							   9=>"1010110110000000",
								10=>"1011000000000000",
								
								11=>"1100000001000001",
								12=>"1111000000000000",
								13=>"1101000000000001",
								14=>"0000000001111000",
								others=>"1111000001000000" );
signal d_read:std_logic_vector(15 downto 0):=(others=>'0');
begin

	   	

Mem_write:
process (write_flag,read_flag,data_write,clk,RAM,addr,reset)
	begin
							
	
	if (read_flag = '1' ) then
	d_read<= RAM(to_integer(unsigned(addr)));
	
	end if;
	
	
	if(write_flag = '1') then
		if(rising_edge(clk)) then
			RAM(to_integer(unsigned(addr))) <= data_write(15 downto 0);
		end if;
	end if;
	
	if(reset = '1' ) then
	
	 RAM<=( 0=>"0000111000110000", 
                        1=>"0010000111010000", 
								2=>"0001000100000100",
								3=>"0011000001010000",
								4=>"0100000100110000",
								5=>"0101010100011000",
								6=>"0110000001010000",
								
								7=>"1000001000000000",
								8=>"1001110000101010",
							   9=>"1010110110000000",
								10=>"1011000000000000",
								
								11=>"1100000001000001",
								12=>"1111000000000000",
								13=>"1101000000000001",
								14=>"0000000001111000",
								others=>"1111000001000000" );
	end if;							
	
	
	end process;
	
	data_read<=d_read;
	mem_loc<=RAM(to_integer(unsigned(switch)));
end Form;