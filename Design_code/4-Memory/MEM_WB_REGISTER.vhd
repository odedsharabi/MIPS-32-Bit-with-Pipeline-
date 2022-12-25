library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity MEM_WB_REGISTER is 
	port(
		
		CLK			        : in	STD_LOGIC;				
		RESET		        : in	STD_LOGIC;	
                --Input
		REG_WRITE_IN		: in	STD_LOGIC; 
		MEM_TO_REG_IN       : in    STD_LOGIC;
     
		READ_DATA_MEM_IN    : in	STD_LOGIC_VECTOR (31 downto 0); 
		ALU_RESULT_IN       : in    STD_LOGIC_VECTOR (31 downto 0);                    
		DOWN_MUX_OUT_IN     : in	STD_LOGIC_VECTOR (4 downto 0);
                  --output
		REG_WRITE			: out	STD_LOGIC; 
		MEM_TO_REG          : out   STD_LOGIC;
		READ_DATA_MEM       : out	STD_LOGIC_VECTOR (31 downto 0); 
		ALU_RESULT          : out   STD_LOGIC_VECTOR (31 downto 0);                    
		DOWN_MUX_OUT 	    : out	STD_LOGIC_VECTOR (4 downto 0)		

);
end entity MEM_WB_REGISTER;


architecture MEM_WB_REGISTER_ARC of MEM_WB_REGISTER is
begin

	  process(CLK,RESET)
	  begin
		if RESET = '1' then
				REG_WRITE                               <= '0';				
				MEM_TO_REG                              <= '0';
                READ_DATA_MEM                           <= (others => '0');
                ALU_RESULT                              <= (others => '0');
                DOWN_MUX_OUT                            <= (others => '0');
                             

		elsif rising_edge(CLK) then
				REG_WRITE                               <= REG_WRITE_IN;				
				MEM_TO_REG                              <= MEM_TO_REG_IN;
                READ_DATA_MEM                           <= READ_DATA_MEM_IN;
                ALU_RESULT                              <= ALU_RESULT_IN;
                DOWN_MUX_OUT                            <= DOWN_MUX_OUT_IN;

		end if;
	  end process;

end architecture MEM_WB_REGISTER_ARC;
                