library ieee;--This Testbench is related to CPU file for RTL simulation 
use ieee.std_logic_1164.all;

entity Testbench_CPU is
end entity Testbench_CPU;
architecture struct of Testbench_CPU is
component CPU is
port(clock,reset: in std_logic;
     op: out std_logic_vector(3 downto 0);
		Z: out std_logic;
		IR_out,IP: out std_logic_vector(15 downto 0);
		R0,R1,R2,R3,R4,R5,R6: out std_logic_vector(15 downto 0);
		s:out integer;
		O_control: out std_logic_vector(16 downto 0);
		Enable:out std_logic_vector(7 downto 0);
		mem_out:out std_logic_vector(15 downto 0)
		);
end component;
signal CT,RT :std_logic:='1';
signal OPT :std_logic_vector(3 downto 0):=(others=>'0');
signal OT :std_logic_vector(16 downto 0):=(others=>'0');
signal IRT,IPT,R0T,R1T,R2T,R3T,R4T,R5T,R6T: std_logic_vector(15 downto 0):=(others=>'0');
signal ZT :std_logic:='0';
signal ST:integer:=0;
signal ET:std_logic_vector(7 downto 0):=(others=>'0');
signal mm_out: std_logic_vector(15 downto 0):=(others=>'0');

begin
CT<= not CT after 100 ns;
RT<= '0','1' after 10000 ns,'0' after 10300 ns;
DUT_instance: CPU port map(CT,RT,OPT,ZT,IRT,IPT,R0T,R1T,R2T,R3T,R4T,R5T,R6T,ST,OT,ET,mm_out);
end struct;