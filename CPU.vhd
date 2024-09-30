library ieee;--This file is for simulation purpose to which Testbench_CPU is written
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity CPU is
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
end entity;
architecture struct of CPU is
component control_path is
	port(
		reset, clk: in std_logic; 
		op: in std_logic_vector(3 downto 0);
		IR_out: in std_logic_vector(15 downto 0);
		Z:in std_logic;
		O: out std_logic_vector(16 downto 0);				--MUX Control Signals
		en: out std_logic_vector(7 downto 0);		--Enables and Operation for ALUs
		s:out integer
	  );
end component;

component data_path is
	port(
	   clk, reset: in std_logic;
		O: in std_logic_vector(16 downto 0);
		en: in std_logic_vector(7 downto 0);
		op: out std_logic_vector(3 downto 0);
		Z,carry: out std_logic;
		IR_out,IP,R0,R1,R2,R3,R4,R5,R6,memory_out,ALU_out: out std_logic_vector(15 downto 0)
		);
end component;		
signal O:  std_logic_vector(16 downto 0):=(others=>'0');
signal en:  std_logic_vector(7 downto 0):=(others=>'0');
signal op_out: std_logic_vector(3 downto 0):=(others=>'0');
signal Z_out,C : std_logic:='0';
signal IR,m_out,ALU_out: std_logic_vector(15 downto 0):=(others=>'0');


begin
D_P: data_path port map(clock,reset,O,en,op_out,Z_out,C,IR,IP,R0,R1,R2,R3,R4,R5,R6,m_out,ALU_out);
FSM: control_path port map (reset, clock,op_out,IR,Z_out,O,en,s);
op<=op_out;
Z<=Z_out;
Enable<=En;
O_control<=O;
mem_out<=m_out;
IR_out<=IR;
end struct;
		