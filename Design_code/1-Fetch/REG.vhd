library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

                           --This is the PC Reg
entity REG is 
	port(
		CLK			: in	STD_LOGIC;					
		RESET		: in	STD_LOGIC;			
		DATA_IN		: in	STD_LOGIC_VECTOR(31 downto 0);	
		DATA_OUT	: out	STD_LOGIC_VECTOR(31 downto 0)	
	);
end REG;

architecture REG_ARC of REG is        
begin
		process(CLK,RESET)
		begin
			if(RESET = '1') then
				DATA_OUT <= (others => '0');
			elsif rising_edge(CLK) then
				DATA_OUT <= DATA_IN;
			end if;
		end process; 
end REG_ARC;