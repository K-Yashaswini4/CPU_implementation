library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity FULLADDER1 is
port (A,B,C: in std_logic;OUTPUT1,OUTPUT2: out std_logic);
end entity FULLADDER1;



architecture Struct of FULLADDER1 is
signal A_BAR,B_BAR,D,E,F,AB_BAR,AB,F_BAR,C_BAR,G,H,FC_BAR,FC:std_logic;

begin
NAND1:NAND_2 port map (A=> A,B=> A,Y=> A_BAR);
NAND2:NAND_2 port map (A=> B,B=> B,Y=> B_BAR);
NAND3:NAND_2 port map (A=> A_BAR,B=> B,Y=> D);
NAND4:NAND_2 port map (A=> B_BAR,B=> A,Y=> E);
NAND5:NAND_2 port map (A=> D,B=> E,Y=> F);
NAND6:NAND_2 port map (A=> A,B=> B,Y=> AB_BAR);
NAND7:NAND_2 port map (A=> F,B=> F,Y=> F_BAR);
NAND8:NAND_2 port map (A=> C,B=> C,Y=> C_BAR);
NAND9:NAND_2 port map (A=> F_BAR,B=> C,Y=> G);
NAND10:NAND_2 port map (A=> C_BAR,B=> F,Y=> H);
NAND11:NAND_2 port map (A=> G,B=> H,Y=> OUTPUT1);
NAND12:NAND_2 port map (A=> F,B=> C,Y=> FC_BAR);
NAND13:NAND_2 port map (A=> FC_BAR,B=>AB_BAR ,Y=> OUTPUT2);

end Struct;