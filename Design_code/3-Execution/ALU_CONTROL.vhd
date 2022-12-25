library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU_CONTROL is
	port(
			FUNCT			:	in STD_LOGIC_VECTOR(5 downto 0);	
			ALUOP0_IN   	:	in STD_LOGIC;			
			ALUOP1_IN   	:	in STD_LOGIC;	
		    ALU_IN	     	:	out STD_LOGIC_VECTOR(2 downto 0)			
	);
end entity ALU_CONTROL;

architecture ALU_CONTROL_ARC of ALU_CONTROL is
begin

    ALU_IN(0) <= (FUNCT(3)or FUNCT(0))and ALUOP1_IN;
	ALU_IN(1) <= not ALUOP1_IN or not FUNCT(2);
	ALU_IN(2) <= ALUOP0_IN or ( ALUOP1_IN and FUNCT(1) );
	
end architecture ALU_CONTROL_ARC;