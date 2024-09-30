library ieee;--This is the main Toplevel file which is used for Board Implementation
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
--Inputs are clock embeded in board, reset, push buttons, switches
--reset<=PB1
--P(0)<=PB2(MSB(1) and LSB(0))
--P(1)<=PB3(Memory (1))
--P(2)<=PB4(Registers data(1))
--Switch(0)<=sw1
--Switch(1)<=sw2
--Switch(2)<=sw3 
--Switch(3)<=sw4
--Switch(4)<=sw5 
--Switch(5)<=sw6 
--Switch(6)<=sw7 
--Switch(7)<=sw8 


 
entity Top is
port(clock,reset: in std_logic;
     P:in std_logic_vector(2 downto 0);
     Switch: in std_logic_vector(7 downto 0);
		outp: out std_logic_vector(7 downto 0)
		
		);
end entity;
architecture struct of Top is

component hz_clock is--This is a clock of 10 sec time period this means it takes 10 seconds to go to next state
port( inclock,reset: in std_logic;
outclock: out std_logic);
end component; 

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
component Memory is 
	port (addr,data_write: in std_logic_vector(15 downto 0); switch : in std_logic_vector(7 downto 0);
	clk,write_flag,read_flag,reset: in std_logic;
				data_read: out std_logic_vector(15 downto 0);
				mem_loc: out std_logic_vector(15 downto 0));
end component;
signal O:  std_logic_vector(16 downto 0):=(others=>'0');
signal en:  std_logic_vector(7 downto 0):=(others=>'0');
signal op_out: std_logic_vector(3 downto 0):=(others=>'0');
signal Z,C,write_flag,read_flag,out_clk: std_logic:='0';
signal output,mem_loc,m_out,IR_out,IP,R0,R1,R2,R3,R4,R5,R6,alu_out: std_logic_vector(15 downto 0):=(others=>'0');
signal s: integer;
signal addr,data_write,data_read :std_logic_vector(15 downto 0);
signal sw :std_logic_vector(7 downto 0);

begin
clk1: hz_clock port map(clock,reset,out_clk);
D_P: data_path port map(out_clk,reset,O,en,op_out,Z,C,IR_out,IP,R0,R1,R2,R3,R4,R5,R6,m_out,alu_out);
FSM: control_path port map (reset, out_clk,op_out,IR_out,Z,O,en,s);
MEM: Memory port map (addr,data_write,sw,out_clk,write_flag,read_flag,reset,data_read,mem_loc);
process(switch,clock,reset)
begin
   if(P(1)='0'and P(2)='1')then--To access the register data
	   if(switch(2 downto 0)="000")then
		  output<=R0;
		elsif(switch(2 downto 0)="001")then
		  output<=R1; 
		 elsif(switch(2 downto 0)="010")then
		  output<=R2;  
	    elsif(switch(2 downto 0)="011")then
		  output<=R3;
		 elsif(switch(2 downto 0)="100")then
		  output<=R4; 
		 elsif(switch(2 downto 0)="101")then
		  output<=R5; 
		 elsif(switch(2 downto 0)="110")then
		  output<=R6; 
		 elsif(switch(2 downto 0)="111")then
		  output<=IP;
		 end if; 
	elsif(P(1)='1'and P(2)='0')then--To access the memory locations
        sw<=switch(7 downto 0);
		  output<=mem_loc;	 
	elsif(P(1)='0'and P(2)='0')then
	     if(switch(7)='1')then--To access PC
		      output<=IP;
		elsif(switch(7 downto 6)="01")then--To access current Instruction
		      output<=IR_out;
		elsif(switch(7 downto 5)="001")then	--To access Zero flag	
		      if(Z='1')then
		          output<="1111111111111111";
				else 
		          output<="0000000000000000";
				end if;
			
		 elsif(switch(7 downto 4)="0001")then--To access carry flag
		      if(C='1')then
		          output<="1111111111111111";
				else 
		          output<="0000000000000000";
				end if;
		elsif(switch(7 downto 3)="00001")then--To access output of Alu1	
		          output<=alu_out;
					 
	   elsif(switch(7 downto 2)="000001")then--To access Transition in states
		          output<=std_logic_vector(to_unsigned(s, 16)); 
		 else 
		 output<="0000000000000000";
	end if;
   end if;
	
	if(P(0)='1')then
     outp<=	output(15 downto 8);--MSB
	  else
	  outp<=	output(7 downto 0);--LSB
	end if;
end process;

end struct;
		