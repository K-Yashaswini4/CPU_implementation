library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity bit4ADD is
port (B3,B2,B1,B0,A3,A2,A1,A0:in std_logic;Cout,S3,S2,S1,S0:out std_logic);
end entity bit4ADD;

architecture Struct of bit4ADD is
signal C1,C2,C3:std_logic;


component fulladder1 is
port (A,B,C: in std_logic;OUTPUT1,OUTPUT2: out std_logic);
end component fulladder1 ;

begin

FA0:fulladder1 port map(A=>'0',B=>A0,C=>B0,OUTPUT1=>S0,OUTPUT2=>C1);
FA1:fulladder1 port map(A=>C1,B=>A1,C=>B1,OUTPUT1=>S1,OUTPUT2=>C2);
FA2:fulladder1 port map(A=>C2,B=>A2,C=>B2,OUTPUT1=>S2,OUTPUT2=>C3);
FA3:fulladder1 port map(A=>C3,B=>A3,C=>B3,OUTPUT1=>S3,OUTPUT2=>Cout);
end Struct;