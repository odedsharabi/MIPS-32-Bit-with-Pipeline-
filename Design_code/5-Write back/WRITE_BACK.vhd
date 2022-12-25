library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

--##This is the block of all the componnents in the WRITE BACK ##--

entity WRITE_BACK is
port( 		
                --Input
        MEM_TO_REG_IN               : in    STD_LOGIC;--  ''	''
        READ_DATA_MEM_IN      		: in	STD_LOGIC_VECTOR (31 downto 0); 
        ALU_RESULT_IN               : in    STD_LOGIC_VECTOR (31 downto 0);                    
                  --output                 
        WRITE_DATA_OUT              : out    STD_LOGIC_VECTOR (31 downto 0);
        WB_Hazard                   : out    STD_LOGIC_VECTOR (31 downto 0)                 	
);
end entity WRITE_BACK;

architecture WRITE_BACK_ARC of WRITE_BACK is 

signal S_WRITE_DATA_OUT      : STD_LOGIC_VECTOR (31 downto 0);

begin

S_WRITE_DATA_OUT <=ALU_RESULT_IN    when MEM_TO_REG_IN='0'    else   READ_DATA_MEM_IN;
WRITE_DATA_OUT   <=S_WRITE_DATA_OUT;
WB_Hazard        <= S_WRITE_DATA_OUT;

end architecture WRITE_BACK_ARC;