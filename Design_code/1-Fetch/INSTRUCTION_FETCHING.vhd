library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--##This is the block of all the componnents in the FETCH ##--

entity INSTRUCTION_FETCHING is
	port(
		CLK				: in STD_LOGIC;					
		RESET			: in STD_LOGIC;					
		PCSrc           : in STD_LOGIC;                                       				
		NEW_PC_ADDR_IN2	: in STD_LOGIC_VECTOR(31 downto 0);	
		NEW_PC_ADDR_OUT	: out STD_LOGIC_VECTOR(31 downto 0);	
		INSTRUCTION 	: out STD_LOGIC_VECTOR(31 downto 0)	
	);
end INSTRUCTION_FETCHING;

architecture INSTRUCTION_FETCHING_ARC of INSTRUCTION_FETCHING is	

--------------------------------------------------------------------------
component REG is 
	port(
		CLK			: in	STD_LOGIC;					
		RESET		: in	STD_LOGIC;			
		DATA_IN		: in	STD_LOGIC_VECTOR(31 downto 0);	
		DATA_OUT	: out	STD_LOGIC_VECTOR(31 downto 0)	
	);
end component REG;

-------------------------------------------------------------------------


component imem is
port ( PC:    in  std_logic_vector(31 downto 0);
       INSTR: out std_logic_vector(31 downto 0)
	  );
end component imem;

--------------------------------------------------------------------------

component IF_ID_REGISTER is 
    port(
	        CLK				: in	STD_LOGIC;			
		RESET				: in	STD_LOGIC;	
	        NEW_PC_ADDR_IN	: in	STD_LOGIC_VECTOR(31 downto 0);	
	        IMEM_REG_IN		: in	STD_LOGIC_VECTOR(31 downto 0);	
	        NEW_PC_ADDR_OUT	: out	STD_LOGIC_VECTOR(31 downto 0);	   
	        IMEM_REG_OUT	: out	STD_LOGIC_VECTOR(31 downto 0)	
        );
end component IF_ID_REGISTER;
----------------------------------------------------------------------------------

	signal PC_ADDR_AUX1	: STD_LOGIC_VECTOR (31 downto 0);	    --between pc and imem
	signal PC_ADDR_AUX2	: STD_LOGIC_VECTOR (31 downto 0);       --between ADDER and upperMUX
	signal PC_ADDR_AUX3	: STD_LOGIC_VECTOR (31 downto 0);       --between upperMUX and pc
	signal INST_AUX		: STD_LOGIC_VECTOR (31 downto 0);	    --between imem and IF_ID

begin

PC_ADDR_AUX2<=conv_STD_LOGIC_VECTOR((conv_integer(PC_ADDR_AUX1)+4),32);

LeftMUX:  
               process(PCSrc,PC_ADDR_AUX2,NEW_PC_ADDR_IN2)
                      begin
 
                          if(PCSrc='0') then
                                PC_ADDR_AUX3<=PC_ADDR_AUX2;
                            else
                                PC_ADDR_AUX3<=NEW_PC_ADDR_IN2;
                          end if;
               end process LeftMUX;

	PC : 
		REG           
		port map(
			CLK			=> CLK,
			RESET		=> RESET,
			DATA_IN		=> PC_ADDR_AUX3,
			DATA_OUT	=> PC_ADDR_AUX1
		);
	
	Imemory:
		imem 
                    port map(
			PC	    	=>	PC_ADDR_AUX1,
			INSTR		=> 	INST_AUX
		);
		
	IFID:
		IF_ID_REGISTER port map(
			CLK	         	=> CLK,
			RESET	    	=> RESET,
			NEW_PC_ADDR_IN	=> PC_ADDR_AUX2,
			IMEM_REG_IN  	=> INST_AUX,
			NEW_PC_ADDR_OUT	=> NEW_PC_ADDR_OUT,
			IMEM_REG_OUT	=> INSTRUCTION
		);	


end INSTRUCTION_FETCHING_ARC;
