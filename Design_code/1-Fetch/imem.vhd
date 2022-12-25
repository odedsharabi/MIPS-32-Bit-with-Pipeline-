library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity imem is
port ( PC:    in  std_logic_vector(31 downto 0);
       INSTR: out std_logic_vector(31 downto 0)
	  );
end entity imem;

architecture arc_imem of imem is
type mem_arr is array (natural range <>) of std_logic_vector(INSTR'range);    
signal instruction_mem: mem_arr((2**8)-1 downto 0):= 

(0=>x"20620008",         --<Reg2 = 8>
1=>x"20e1000a",          --<Reg1=10>				
2=>x"2044000e",          --<Reg4 = 22>
3=>x"20260033",          --<Reg6 = 61>
4=>x"204f0002",          --<Reg15 = 10>
5=>x"00c11822",          --SUB <Reg3 = 51>
6=>x"00825020",          --ADD <Reg10 = 30>
7=>x"00000000",			 --bubble
8=>x"004a402a",          -- SLT Rd=Rs<Rt  Reg8 = Reg2 <Reg10  ==>true
9=>x"00000000",			 --bubble
10=>x"00000000",		 --bubble
11=>x"ac2a000a",		 -- SW put to Reg 20 in the dmem the value 30			    
12=>x"ac2a000b",         -- SW put to Reg 21 in the dmem the value 30
13=>x"ac2a000d",         -- SW put to Reg 23 in the dmem the value 30
14=>x"10860002",         -- (Beq) if(Reg4 == Reg6) go to PC+=2*4   not taken
15=>x"ac2a000e",         -- SW  put into Reg 24 in the dmem 30
16=>x"8c25000a",         -- LW put into Reg5(from bor) the value of reg 20 in the dmem  (Reg5<=30)
17=>x"0086382a",         -- SLT Rd=Rs<Rt  Reg7 = Reg4 <Reg6  ==>true
 ----------
 others=>(others=>'0')
 );


begin
   INSTR<=instruction_mem(conv_integer(pc(9 downto 2)));
end architecture arc_imem;	  