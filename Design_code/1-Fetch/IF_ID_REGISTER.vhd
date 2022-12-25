library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity IF_ID_REGISTER is 
    port(
	        CLK				: in	STD_LOGIC;			
			RESET			: in	STD_LOGIC;	
	        NEW_PC_ADDR_IN	: in	STD_LOGIC_VECTOR(31 downto 0);	
	        IMEM_REG_IN		: in	STD_LOGIC_VECTOR(31 downto 0);	
	        NEW_PC_ADDR_OUT	: out	STD_LOGIC_VECTOR(31 downto 0);	   
	        IMEM_REG_OUT	: out	STD_LOGIC_VECTOR(31 downto 0)	
        );
end IF_ID_REGISTER;

architecture IF_ID_REGISTER_ARC of IF_ID_REGISTER is        
begin	
		process(CLK,RESET)
		begin
			if RESET = '1' then
				NEW_PC_ADDR_OUT	<= (others => '0');
				IMEM_REG_OUT	<= (others => '0');
				
			elsif rising_edge(CLK) then
				NEW_PC_ADDR_OUT	<= NEW_PC_ADDR_IN;    
				IMEM_REG_OUT	<= IMEM_REG_IN;
				
			end if;
		end process; 
end IF_ID_REGISTER_ARC;
