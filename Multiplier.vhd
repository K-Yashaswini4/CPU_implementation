library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Multiplier is
port (A: in std_logic_vector(15 downto 0);B: in std_logic_vector(15 downto 0);M:out std_logic_vector(15 downto 0));
end entity Multiplier;

architecture Struct of Multiplier is
signal w,x,y,z,s,t,c:std_logic_vector(3 downto 0);
signal N:std_logic_vector(15 downto 0):=(others => '0');

component mux is
port (I:in std_logic_vector(1 downto 0);S:in std_logic;Y:out std_logic);
end component mux;

component bit4ADD is
port (B3,B2,B1,B0,A3,A2,A1,A0:in std_logic;Cout,S3,S2,S1,S0:out std_logic);
end component bit4ADD;

component FULLADDER1 is
port (A,B,C: in std_logic;OUTPUT1,OUTPUT2: out std_logic);
end component FULLADDER1;




begin
n1_bit : for i in 0 to 3 generate
L1: mux port map(I(0) => '0', I(1) => a(i), S => B(0), Y => w(i));

end generate ;


n2_bit : for i in 0 to 3 generate
L2: mux port map(I(0) => '0', I(1) => a(i), S => B(1), Y => x(i));

end generate ;

n3_bit : for i in 0 to 3 generate
L3: mux port map(I(0) => '0', I(1) => a(i), S => B(2), Y => y(i));

end generate ;

n4_bit : for i in 0 to 3 generate
L3: mux port map(I(0) => '0', I(1) => a(i), S => B(3), Y => z(i));

end generate ;
N(0)<=W(0);
N(1)<=s(0);
N(2)<=t(0);
bit4_1:bit4ADD port map('0',w(3),w(2),w(1),x(3),x(2),x(1),x(0),c(0),s(3),s(2),s(1),s(0));
bit4_2:bit4ADD port map(c(0),s(3),s(2),s(1),y(3),y(2),y(1),y(0),c(1),t(3),t(2),t(1),t(0));
bit4_3:bit4ADD port map(c(1),t(3),t(2),t(1),z(3),z(2),z(1),z(0),N(7),N(6),N(5),N(4),N(3));
M<=N;
end Struct;
