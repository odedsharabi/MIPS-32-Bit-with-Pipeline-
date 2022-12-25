library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity EX_MEM_REGISTER is 
	port(
		CLK			       		      : in	STD_LOGIC;				
		RESET		                  : in	STD_LOGIC;	
                --Input
		NEW_PC_AFTER_ADD_RESULT_IN    : in	STD_LOGIC_VECTOR (31 downto 0);

        REG_WRITE_IN				  : in	STD_LOGIC; -- From write-back
        MEM_TO_REG_IN                 : in  STD_LOGIC;--  ''	''
                		
		BRANCH_IN					  : in	STD_LOGIC; -- From Memmory access		
		MEM_READ_IN					  : in	STD_LOGIC; --   ''    '' 
        MEM_WRITE_IN                  : in  STD_LOGIC; --   ''    ''	
     
        ZERO_IN      				  : in	STD_LOGIC; 
        ALU_RESULT_IN                 : in  STD_LOGIC_VECTOR (31 downto 0);                                
        READ_DATA2_OUT_IN	          : in	STD_LOGIC_VECTOR (31 downto 0);
        DOWN_MUX_OUT_IN 	          : in	STD_LOGIC_VECTOR (4 downto 0);

                  --output
		NEW_PC_AFTER_ADD_RESULT_OUT   : out	STD_LOGIC_VECTOR (31 downto 0);

        REG_WRITE					  : out	STD_LOGIC; -- From write-back
        MEM_TO_REG                    : out STD_LOGIC;--  ''	''
                		
		BRANCH						  : out	STD_LOGIC; -- From Memmory access		
		MEM_READ					  : out	STD_LOGIC; --   ''    '' 
        MEM_WRITE                     : out STD_LOGIC; --   ''    ''	
     
        ZERO      			          : out	STD_LOGIC; 
        ALU_RESULT                    : out STD_LOGIC_VECTOR(31 downto 0);                       
          
        READ_DATA2_OUT 	              : out	STD_LOGIC_VECTOR (31 downto 0);
        DOWN_MUX_OUT 	              : out	STD_LOGIC_VECTOR (4 downto 0)

);
end entity EX_MEM_REGISTER;


architecture EX_MEM_REGISTER_ARC of EX_MEM_REGISTER is
begin

	  process(CLK,RESET)
	  begin
		if (RESET = '1') then
				NEW_PC_AFTER_ADD_RESULT_OUT	        	<= X"00000000";
				REG_WRITE                               <= '0';
                MEM_TO_REG                              <= '0';
                BRANCH                                  <= '0';
                MEM_READ                                <= '0';
                MEM_WRITE                               <= '0';
                ZERO                                    <= '0';
                ALU_RESULT                              <= X"00000000";
                READ_DATA2_OUT                          <= X"00000000";
                DOWN_MUX_OUT                            <= "00000";
                             

		elsif rising_edge(CLK) then
				NEW_PC_AFTER_ADD_RESULT_OUT	            <= NEW_PC_AFTER_ADD_RESULT_IN;
				REG_WRITE		                        <= REG_WRITE_IN;
				MEM_TO_REG		                        <= MEM_TO_REG_IN;
				BRANCH		                            <= BRANCH_IN;	
				MEM_READ                                <= MEM_READ_IN;
                MEM_WRITE                               <= MEM_WRITE_IN;
                ZERO                                    <= ZERO_IN;
                ALU_RESULT                              <= ALU_RESULT_IN;
                READ_DATA2_OUT                          <= READ_DATA2_OUT_IN;
                DOWN_MUX_OUT                            <= DOWN_MUX_OUT_IN;

		end if;
	  end process;

end architecture EX_MEM_REGISTER_ARC;
                