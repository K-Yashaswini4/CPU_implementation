
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity control_path is
	port(
		reset, clk: in std_logic; 
		op: in std_logic_vector(3 downto 0);
      IR_out: in std_logic_vector(15 downto 0);		
		Z:in std_logic;
		O: out std_logic_vector(16 downto 0);				--MUX Control Signals
		en: out std_logic_vector(7 downto 0);				--Enables and Operation for ALUs
	  
	  s: out integer);
end entity;

architecture fsm of control_path is
	type fsm_state is ( S0, S1, S2, S3, S4, S5, S6, S7, S8,S9, S10, S11, S12, S13, S14, S15);
	signal Q, nQ: fsm_state := S0;
begin
--o(0)<=MEM_add
--o(2 downto 1)<=a3(RF input)
--o(4 downto 3)<=d3(RF input)
--o(6)<=T1_in
--o(7)<=T2_in
--o(10 downto 8)<=input 2 of ALU2
--o(13 downto 11)<=control of Alu1
--o(14)<= SE
--o(15)<=PC_in
--o(16)<=LLI and LHI

--en(0)<=RF_write
--en(1)<=IR_write
--en(2)<=T1_write
--en(3)<=T2_write
--en(4)<=T3_write
--en(5)<=mem_write
--en(6)<=Pc_write
--en(7)<=mem_read
	clocked:
	process(clk, nQ)
	begin
		if (clk'event and clk = '1') then
			Q <= nQ;
		end if;
	end process;
	
	outputs:
	process(Op, Q)
	begin
		O <= (others => '0');
		en <= (others => '0');
		case Q is
		   when S0 => 
				O <= (others => '0');
				en <= (others => '0');
				s<=0;
			when S1 => 
			   
				O(13 downto 11)<="000";
				en(1)<='1';  en(7)<='1';
				O(0)<='0';
				s<=1;
			when S2 => 
			   O(8)<=op(3) and  op(2) and (not op(1)) and (not op(0));
				O(9)<=op(3) and  op(2) and (not op(1)) and (not op(0));
				O(10)<=not(op(3) and  op(2) and (not op(1)) and (not op(0)) );
				O(15)<=not( op(3) and  op(2) and (not op(1)) and (not op(0)));
				en(6)<=op(3) and  op(2) and (not op(1)) and (not op(0)); 
				O(7 downto 6)<="00";
				en(3 downto 2)<="11";
				s<=2;
			when S3 => 
			   en(4)<='1';
				 
				
				O(11)<=(op(1)and (not op(0)) and (not op(3))) or (op(2)and (not op(0)));
			   O(12)<=(not op(3))and((op(1) and op(0)) or ((not op(1))and(not op(0))and op(2)));
			   O(13)<=(op(0)and  op(2)) or (op(2)and op(1));
			s<=3;	
			when S4 => 
				en(0)<='1';
				O(2 downto 1)<="00";
				O(4 downto 3)<="00";
				O(8) <=(not op(3))and ((not op(0)) or (op(2) xor op(1)));
				O(9) <=(not op(3))and ((not op(0)) or (op(2) xor op(1)));
				O(10) <=not((not op(3))and ((not op(0)) or (op(2) xor op(1))));
				O(15) <=not((not op(3))and((not op(0)) or (op(2) xor op(1))));
				en(6)<=not(IR_out(3) and IR_out(4) and IR_out(5));
				
				s<=4;
			when S5 => 
				en(3 downto 2)<="11";
				O(7 downto 6)<="10";
				s<=5;
			when S6 => 
			   O( 8)<= not(op(3) or op(2) or op(1) or (not op(0)));
			   O( 9)<= not(op(3) or op(2) or op(1) or (not op(0)));
		      O( 10)<= (op(3) or op(2) or op(1) or (not op(0))); 		
			   O(15)<= (op(3) or op(2) or op(1) or (not op(0)));
			   en(6)<=not(IR_out(6) and IR_out(7) and IR_out(8));	
				en(0)<='1';
				O(4 downto 1)<="0010";
				s<=6;
			when S7 => 
			   
			   O(8)<=not(not(op(3)) or op(2) or op(1)); 
				O(9)<=not(not(op(3)) or op(2) or op(1));
			   O(10)<=(not(op(3)) or op(2) or op(1)); 
			   O(15)<=(not(op(3)) or op(2) or op(1));
		      en(6)<=not(IR_out(9) and IR_out(10) and IR_out(11));		
				en(0)<='1';
				O(4 downto 1)<="1001";
				O(16)<= op(0);
				s<=7;
				
			when S8 => 
				en(3 downto 2)<="11";
				O(7 downto 6)<="11";
				o(14)<='1';
				s<=8;
			when S9 => 
			   
			   O(8)<=op(3) and (not op(2)) and op(1) and (not op(0));
			   O(9)<=op(3) and (not op(2)) and op(1) and (not op(0));
			   O(10)<=not(op(3) and (not op(2)) and op(1) and (not op(0)));
			   O(15)<=not(op(3) and (not op(2))  and op(1) and (not op(0)));
			   en(6)<=not(IR_out(9) and IR_out(10) and IR_out(11));	
				en(0)<='1';en(7)<='1';
				O(4 downto 0)<="01011";
				s<=9;
			when s10 => 
			   O(8)<=op(3) and (not op(2)) and op(1) and op(0);
				O(9)<=op(3) and (not op(2)) and op(1) and op(0);
				O(10)<=not(op(3) and (not op(2)) and op(1) and op(0));
				O(15)<=not(op(3) and (not op(2)) and op(1) and op(0));
				en(6)<='1';
				O(0)<='1';
				en(5)<='1';
				s<=10;
			when S11 =>
		      O(14)<='1';
			   O(10 downto 8)<="010";
				O(15)<='0';
				en(6)<='1';
				s<=11;
			when S12 =>	
			  
				en(6)<='1';
				O(10 downto 8)<="001";
				O(15)<='0';
				O(13 downto 11)<="001";
				s<=12;
			when S13 => 
		      en(6)<='1';	
			   
				O(15 downto 14)<="00";
				O(10 downto 8)<="010";
				s<=13;
			when S14 =>	
			   
			   en(0)<='1';
				O(4 downto 1)<="1101";
				s<=14;
			when S15 =>
		      en(6)<='1';
				O(15)<='1';
				s<=15;
		end case;
	end process;
	
	
	next_state:
	process(op, reset,Z, Q ,clk)
	begin
		nQ <= Q;
		case Q is
			when S0 => nQ <= S1;
			when S1 =>
				case op is
					when "0000"|"0010"|"0011"|"0100"|"0101"|"0110"|"1100" => nQ <= S2;	--ADD,SUB,MUL,AND,OR,IMP,BEQ
					when "0001" => nQ <= S5;	--ADI
					when "1000"|"1001" => nQ <= S7;	--LHI,LLI					
					when "1010"|"1011" => nQ <= S8;	--LW,SW
               when "1101" => nQ <= S13;	--JAL
               when "1111" => nQ <= S15;	--JLR
					
					when others =>	nQ <= S1;--DUMMY
				end case;
			when S2 =>
				case op is
					when "0000"|"0010"|"0011"|"0100"|"0101"|"0110"|"1100"=> nQ <=S3;--ADD,SUB,MUL,AND,OR,IMP,BEQ
					
					when others =>	nQ <= S1;
				end case;
			when S3 =>	
				case op is
					when "0000"|"0010"|"0011"|"0100"|"0101"|"0110"=> nQ <=S4;--ADD,SUB,MUL,AND,OR,IMP
					when "1100" =>
				      if(Z='1') then	
					      nQ <= S11;--BEQ
						else
					       nQ <= S1;--nxt_instruction
						end if;	 
					when "0001" => nQ <= S6;--ADI
					when "1010" => nQ <= S9;--LW
					when "1011" => nQ <= S10;--SW
					
					when others => nQ <= S1;
				end case;
			when S4 => 	
				case op is
					when "0000"|"0010"|"0011"|"0100"|"0101"|"0110"=> nQ <=S1;--ADD,SUB,MUL,AND,OR,IMP 
						
					when others => nQ <= S1;
				end case;
			when S5 =>		
				case op is
					when "0001" => nQ<= S3;--ADI
					when others => nQ <= S1;
				end case;
			when S6 =>	
				 nQ <= S1; --ADI
					
			when S7 =>
				 nQ <= S1;--LHI
					
			when S8 =>
				case op is
					when "1010"|"1011" => nQ <= S3;--SW,LW
					when others => nQ <= S1;
				end case;
			when S9 => 
				 nQ <= S1;
			when S10=>
		       nQ<= S1;	
			when S11=>
			    case op is
				    when "1100" => nQ <= s12; --BEQ
					 when others => nQ <= s1;
					 end case;
			when S12=>
			     
				    nQ<= S1;
					 
			when S13 =>
			    case op is
				    when "1101"=> nQ <= s14;--JAL
					 when others => nQ <= S1;
				end case;
			when S14=>
			    case op is
				    when "1111"=> nQ <= s1;--last_instruction
			       when others => nQ<= S1;
				end case;	 
			when S15=>
			    case op is
				    when "1111" => nQ <= s14;
					 when others => nQ <= S1;
		end case;
		end case;
		if (reset = '1') then
			nQ <= S0;
		end if;
	end process;
	
		
end architecture;
