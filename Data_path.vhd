library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity data_path is
	port(
	   clk, reset: in std_logic;
		O: in std_logic_vector(16 downto 0);
		en: in std_logic_vector(7 downto 0);
		op: out std_logic_vector(3 downto 0);
		Z,carry: out std_logic;
		IR_out,IP,R0,R1,R2,R3,R4,R5,R6,memory_out,ALU_out: out std_logic_vector(15 downto 0)
		);
		
end entity;
	
architecture rtl of data_path is

	


   component SixteenBitRegister is
	port (
		reset,clk, write_flag : in std_logic;
		data_write      : in std_logic_vector(15 downto 0);
		data_read       : out std_logic_vector(15 downto 0)
	);
end component;

component LHI  is
  port (LH_IN: in std_logic_vector(8 downto 0); LH_OUT: out std_logic_vector(15 downto 0));
end component LHI;


component LLI  is
  port (LS_IN: in std_logic_vector(8 downto 0); LS_OUT: out std_logic_vector(15 downto 0));
end component LLI;

component sign_extend_6 is
  port(
   inp_6bit : in std_logic_vector(5 downto 0);
	outp_16bit : out std_logic_vector(15 downto 0)
  ) ;
end component ; 

component sign_extend_9 is
  port(
	inp_9bit : in std_logic_vector(8 downto 0);
	outp_16bit : out std_logic_vector(15 downto 0)
  ) ;
end component ;

component shift is 
port (SE_in:in std_logic_vector(15 downto 0);shift_out:out std_logic_vector(15 downto 0));
end component shift; 


	component Register_file is
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

 
end component Register_file;

	component ALU is
	port (
		a, b        : in std_logic_vector(15 downto 0);
		s          : in std_logic_vector(2 downto 0);
		c           : out std_logic_vector(15 downto 0);
		zero, carry : out std_logic
	);
end component ALU;
	

    component Memory is 
	   port (addr,data_write: in std_logic_vector(15 downto 0); switch : in std_logic_vector(7 downto 0);
	clk,write_flag,read_flag,reset: in std_logic;
				data_read: out std_logic_vector(15 downto 0);
				mem_loc: out std_logic_vector(15 downto 0));
     end component;
	

	signal V1: std_logic_vector(2 downto 0) := (others => '0');
	signal V3: std_logic_vector(15 downto 0) := (others => '0');
   signal inp_6bit:std_logic_vector(5 downto 0):=(others=>'0');
	signal inp_9bit:std_logic_vector(8 downto 0):=(others=>'0');
	signal data_write, d_r, d3, PC_in,d1,d2,PC_out,outp_16bit6,outp_16bit9,SEinp,shiftoutp: std_logic_vector(15 downto 0):=(others=>'0') ;
	signal a1,a2,a3:std_logic_vector(2 downto 0):=(others=>'0');
	signal mem_loc,a,x,y, c,b,c2: std_logic_vector(15 downto 0) :=(others=>'0');
	signal zero,zero2,carry2:std_logic:='0';
	signal addr,D_W,D_read:std_logic_vector(15 downto 0):=(others=>'0');
	signal t1_in,t1_out,t2_in,t2_out,t3_in,t3_out:std_logic_vector(15 downto 0):=(others=>'0');
	signal LL_out,LH_out:std_logic_vector(15 downto 0):=(others=>'0');
	signal LL_in,LH_in:std_logic_vector(8 downto 0):=(others=>'0');
	signal switch :std_logic_vector(7 downto 0);
	

begin
	
	--Instruction Register
	instruction_register: SixteenBitRegister
		port map(clk => clk,write_flag=>en(1),reset=>reset,data_write=>data_write,data_read=>d_r);
	
	--Register File
	rf: register_file
		port map(clk => clk, write_flag1 => en(0), write_flag2 => en(6),reset=>reset, a1=> a1, a2 => a2, 
			a3=> a3, d3=>d3, PC_in => PC_in, d1 => d1, d2 => d2,PC_out => PC_out,
			R0=>R0,R1=>R1,R2=>R2,R3=>R3,R4=>R4,R5=>R5,R6=>R6);
	
	
	--Sign Extend 6
	sign_extend_1: sign_extend_6
		port map( inp_6bit => inp_6bit, outp_16bit => outp_16bit6);
		
	--Sign Extend 9
	sign_extend_2: sign_extend_9
		port map( inp_9bit => inp_9bit, outp_16bit => outp_16bit9);
		
	--shift
	shift1:shift port map(SE_in=>SEinp,shift_out=> shiftoutp);
		
	--Arithmetic Logic Unit 1
	alu_instance_1: alu
		port map(a=> a, b => b, s => O(13 downto 11), c => c,
			carry => carry, zero => zero);
			
	--	Arithmetic Logic Unit 2
	alu_instance_2: alu
		port map(a=> x, b => y, s => "000", c => c2,
			carry => carry2, zero => zero2);
				
					
	--Memory
	mem: memory
		port map(addr => addr, data_write => D_W,switch=>switch,clk => clk, write_flag => en(5),read_flag => en(7),reset=>reset, Data_read => D_read,
			 mem_loc=>mem_loc);
	
		--Temporary Register 1
	T1: sixteenbitregister
		port map(clk => clk,write_flag => en(2), reset=> reset, data_write =>t1_in,  data_read=>t1_out);
		
		--Temporary Register 2
	T2: sixteenbitregister
		port map(clk => clk,write_flag => en(3),reset=>reset, data_write =>t2_in,  data_read=>t2_out);
		
		--Temporary Register 3
	T3: sixteenbitregister
		port map(clk => clk,write_flag => en(4), reset=> reset, data_write =>t3_in,  data_read=>t3_out);
	
	
	
	
	--Left Shift LLI
	LL_I: LLI
		port map(LS_IN => LL_IN, LS_OUT => LL_OUT);
	--Left Shift LHI
	LH_I: LHI
		port map(LH_IN => LH_IN, LH_OUT => LH_OUT);
	
	
	
	--Input 1 of ALU1
	   a <= T1_OUT ;
		 
		
	--Input 2 of ALU1
	   b <= t2_out;
		
	--Input1 of ALU2
	  x<= PC_out;
	  
	-- Input2 of ALU2
     y<="0000000000000001" when O(10 downto 8) ="011" else
        "1111111111111111" when O(10 downto 8) ="001" else
	      shiftoutp when O(10 downto 8) ="010" else
         V3;			
	
   
	--Register File RF_A3
	a3 <= d_r(5 downto 3) when (O(2 downto 1)= "00") else
		d_r(8 downto 6) when (O(2 downto 1)= "10") else
		d_r(11 downto 9) when (O(2 downto 1)= "01") else
		V1;
		
	
	--Register File RF_D3
	d3 <= D_read when (O(4 downto 3)= "01") else
		PC_OUT when (O(4 downto 3)= "11") else
		LH_OUT when ((O(4 downto 3)= "10")  and O(16)='0') else
		LL_OUT when ((O(4 downto 3)= "10")  and O(16)='1') else
		t3_out when (O(4 downto 3)= "00") else
		V3;
		
	 
memory_out<=D_read;
	
	--Register File RF_A1
	a1<=d_r(11 downto 9);
		
	--Register File RF_A2
	a2 <= d_r(8 downto 6);
		
	--Memory Address MEM_A
	addr <= PC_OUT when (O(0)= '0') else
		T3_OUT when (O(0)= '1') else
		V3;
	
	--Memory data MEM_DI
	D_W <= d1 when en(5)<='1' ;
	
	

	--Temp Reg T1
	t1_in <= d1 when (O(6) = '0')  else
		d2 when (O(6) = '1') else
		V3;
		
	--Temp Reg T2
	t2_in <= d2 when (O(7)='0') else
	 outp_16bit6 when (O(7)='1') else
     V3;	 
	
	--Temp Reg T3
	t3_in <= c;
	
	--LL_in
	LL_in<=d_r(8 downto 0) ;
	LH_in<=d_r(8 downto 0);
	
	
	
	--Info Reg IR
	data_write<=D_read;
	
	
	--SE16, 6 bit input
	inp_6bit <= d_r(5 downto 0);
	
	--SE16, 9 bit input
	inp_9bit <= d_r(8 downto 0);
	
	--Left Shifter
	SEinp <= outp_16bit6 when O(14)='1' else
	    outp_16bit9 when O(14)='0' else
		 V3;
		 
	PC_IN<= c2 when O(15)='0' else
	  d2 when O(15)='1' else
	   V3;
	  
   	
	IP<=PC_out;
	
	
	IR_out<=d_r;
		
	--Send Operation Code to the control path
	op <= d_r(15 downto 12) when (en(1) = '0') else 
		data_write(15 downto 12);
	
	Z<=zero;
	
	ALU_out<=c;
	
end architecture;
