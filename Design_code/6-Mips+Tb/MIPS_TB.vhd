library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MIPS_TB is

end entity MIPS_TB;



architecture MIPS_TB_ARC of MIPS_TB is


	component MIPS is
          port(
		CLK		: in STD_LOGIC;					
		RESET		: in STD_LOGIC	

		);
	end component MIPS;

	signal RESET1	: STD_LOGIC;
	signal CLK1	: STD_LOGIC;


begin
	MIPS_TB:
		MIPS port map(
			CLK => CLK1,
			RESET => RESET1
		);

	CLK:
		process
		begin
			while true loop
				CLK1 <= '0';
				wait for 10 ns;
				CLK1 <= '1';
				wait for 10 ns;
			end loop;
		end process CLK;


	RESET:
		process
		begin
			RESET1<='1';
			wait for 40 ns;
			RESET1<='0';
			wait;
		end process RESET;
   	
end architecture MIPS_TB_ARC;