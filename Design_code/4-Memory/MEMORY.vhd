library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--##This is the block of all the componnents in the MEMORY ##--

entity MEMORY is
   port(
--input
		CLK                             : in    std_logic;
		RESET                           : in    std_logic;

		REG_WRITE		            	: in	STD_LOGIC; -- From write-back
		MEM_TO_REG                      : in    STD_LOGIC;--  ''	''

		ADD_RESULT4_IN                  : in    STD_LOGIC_VECTOR (31 downto 0);
                		
		BRANCH			             	: in	STD_LOGIC; -- From Memmory access		
		MEM_READ			            : in	STD_LOGIC; --    ''    '' 
		MEM_WRITE                       : in    STD_LOGIC; --   ''    ''	
	
		ZERO			                : in	STD_LOGIC;
		ALU_RESULT			            : in	STD_LOGIC_VECTOR (31 downto 0);
		READ_DATA2_OUT 		        	: in	STD_LOGIC_VECTOR (31 downto 0);
		DOWN_MUX_OUT_IN                 : in    std_logic_vector(4 downto 0);
--out
		PCSrc                           : out	std_logic;
		ADD_RESULT4                     : out   STD_LOGIC_VECTOR (31 downto 0);
		REG_WRITE_OUT			        : out	STD_LOGIC; 
		MEM_TO_REG_OUT                  : out   STD_LOGIC;
     
		READ_DATA_MEM_OUT      		    : out	STD_LOGIC_VECTOR (31 downto 0); 
		ALU_RESULT_OUT                  : out   STD_LOGIC_VECTOR (31 downto 0);                    
		DOWN_MUX_OUT 	                : out	STD_LOGIC_VECTOR (4 downto 0);

		REG_write_HAZARD                : out   STD_LOGIC; 
		WRITE_REG_MEM_HAZARD            : out   STD_LOGIC_VECTOR (4 downto 0); 
		ALU_RESULT_HAZARD               : out   STD_LOGIC_VECTOR (31 downto 0)      
	);
end entity MEMORY;

architecture MEMORY_ARC of MEMORY is 
-----------------------------------------------------------------------
component dmem is
 port ( 
		clk        : in  std_logic;
		rst        : in  std_logic;
		address    : in  std_logic_vector(31  downto 0);
		-- write side
		mem_write  : in  std_logic;
		write_data : in  std_logic_vector(31 downto 0);
		-- read side
		mem_read   : in  std_logic;
		read_data  : out std_logic_vector(31 downto 0)	
	  );
end component dmem;
-----------------------------------------------------------
component MEM_WB_REGISTER is
 port ( 
		CLK			            : in	STD_LOGIC;				
		RESET		            : in	STD_LOGIC;	
                --Input
        REG_WRITE_IN			: in	STD_LOGIC; 
		MEM_TO_REG_IN           : in    STD_LOGIC;
     
		READ_DATA_MEM_IN        : in	STD_LOGIC_VECTOR (31 downto 0); 
		ALU_RESULT_IN           : in    STD_LOGIC_VECTOR (31 downto 0);                    
		DOWN_MUX_OUT_IN 	    : in	STD_LOGIC_VECTOR (4 downto 0);
                  --output
		REG_WRITE		    	: out	STD_LOGIC; 
		MEM_TO_REG              : out   STD_LOGIC;
     
		READ_DATA_MEM      		: out	STD_LOGIC_VECTOR (31 downto 0); 
		ALU_RESULT              : out   STD_LOGIC_VECTOR (31 downto 0);                    
		DOWN_MUX_OUT 	        : out	STD_LOGIC_VECTOR (4 downto 0)		
);
end component MEM_WB_REGISTER;
-------------------------------------------------------------------------
signal S_DATA_FROM_OUT_MEM      : STD_LOGIC_VECTOR (31 downto 0); 

begin

PCSrc       <= BRANCH and ZERO;
ADD_RESULT4 <= ADD_RESULT4_IN;

H1:
	dmem
         port map(	
--in
			clk	                => CLK,
			rst	                => RESET,
			address	            => ALU_RESULT,
			mem_write	        => MEM_WRITE,
			write_data	        => READ_DATA2_OUT,
            mem_read	        => MEM_READ,
			read_data	        => S_DATA_FROM_OUT_MEM    
);

H2:
	MEM_WB_REGISTER                                  
         port map(
            CLK                      =>  CLK,
            RESET                    => RESET,
			REG_WRITE_IN	         => REG_WRITE,
			MEM_TO_REG_IN            => MEM_TO_REG,
			READ_DATA_MEM_IN         => S_DATA_FROM_OUT_MEM,
			ALU_RESULT_IN            => ALU_RESULT,
			DOWN_MUX_OUT_IN          => DOWN_MUX_OUT_IN,

			REG_WRITE	             => REG_WRITE_OUT,
			MEM_TO_REG               => MEM_TO_REG_OUT,
			READ_DATA_MEM            => READ_DATA_MEM_OUT,
			ALU_RESULT               => ALU_RESULT_OUT,
			DOWN_MUX_OUT             => DOWN_MUX_OUT
		);	
		
		
			REG_write_HAZARD         <=  REG_WRITE;
			WRITE_REG_MEM_HAZARD     <= DOWN_MUX_OUT_IN;        
			ALU_RESULT_HAZARD        <= ALU_RESULT;

end architecture MEMORY_ARC;