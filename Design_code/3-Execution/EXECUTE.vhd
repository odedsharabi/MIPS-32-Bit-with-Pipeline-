library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--##This is the block of all the componnents in the EXECUTE ##--

entity EXECUTE is
       port(
	        
		CLK                             : in  STD_LOGIC;
		RESET                           : in  STD_LOGIC;
 
		REG_WRITE_IN		         	: in  STD_LOGIC; 
        MEM_TO_REG_IN                   : in  STD_LOGIC;
                		
		BRANCH_IN			            : in  STD_LOGIC; 		
		MEM_READ_IN			            : in  STD_LOGIC; 
        MEM_WRITE_IN                    : in  STD_LOGIC; 
                
        REGDST_IN                       : in    STD_LOGIC; --From Execution
        ALUOP0_IN                       : in    STD_LOGIC; --   ''    '' 
        ALUOP1_IN                       : in    STD_LOGIC; --   ''    '' 
        ALUSRC_IN                       : in    STD_LOGIC; --   ''    '' 	

		NEW_PC_ADDR_OUT		        	: in	STD_LOGIC_VECTOR (31 downto 0);
		
		OFFSET_OUT			            : in	STD_LOGIC_VECTOR (31 downto 0);--    [15-0]
		RT_ADDR_OUT			            : in	STD_LOGIC_VECTOR (4 downto 0);-- RT [20-16]
		RD_ADDR_OUT			            : in	STD_LOGIC_VECTOR (4 downto 0);-- RD [15-11]
		RS_ADDR_OUT			            : in	STD_LOGIC_VECTOR (4 downto 0);-- RS [25-21]  --lechavet
		
		READ_DATA1_OUT	 		        : in	STD_LOGIC_VECTOR (31 downto 0); 
		READ_DATA2_OUT_IN 		        : in	STD_LOGIC_VECTOR (31 downto 0); 	

        forward_A                       : in  std_logic_vector (1 downto 0);       -- forward mux select 1   --forward A
		forward_B                       : in  std_logic_vector (1 downto 0);       -- forward mux select 2   --forward B
        ALU_OUT_MEM_IN                  : in  std_logic_vector (31 downto 0);      -- data from memory stage for alu
		RESULT_WB                       : in  std_logic_vector (31 downto 0);      -- data from stage writeback for alu

		REG_WRITE			            : out	STD_LOGIC; 
        MEM_TO_REG                      : out    STD_LOGIC;
                		
		BRANCH				            : out	STD_LOGIC; 		
		MEM_READ			            : out	STD_LOGIC; 
        MEM_WRITE                       : out   STD_LOGIC; 	
             
        NEW_PC_AFTER_ADD_RESULT         : out	std_logic_vector(31 downto 0);
        ZERO                            : out   std_logic;
        ALU_RESULT                      : out   std_logic_vector(31 downto 0);
		READ_DATA2_OUT 			        : out	STD_LOGIC_VECTOR (31 downto 0); 
        DOWN_MUX_OUT                    : out   std_logic_vector(4 downto 0);
 	
        RS_Exe                          : out   std_logic_vector(4 downto 0)            -- output to forward unit	
	);
end entity EXECUTE;

architecture EXECUTE_ARC of EXECUTE is 

component ALU is

port ( 
       READ_DATA1             :    in  std_logic_vector(31 downto 0);
       READ_DATA2             :    in  std_logic_vector(31 downto 0);
       ALU_CONTROL            :    in  std_logic_vector(2 downto 0);
       ZERO                   :    out std_logic;
       ALU_RESULT             :    out std_logic_vector(31 downto 0)

     );

end component ALU;
------------------------------------------------------------------------------
component ALU_CONTROL is
	port( 
			FUNCT	    	:	in STD_LOGIC_VECTOR(5 downto 0);	
			ALUOP0_IN   	:	in STD_LOGIC;			
			ALUOP1_IN   	:	in STD_LOGIC;	
		    ALU_IN		    :	out STD_LOGIC_VECTOR(2 downto 0)			
	    );

end  component ALU_CONTROL;
------------------------------------------------------------------------------
component EX_MEM_REGISTER is 
	port(
		CLK			                    : in	STD_LOGIC;				
		RESET		                    : in	STD_LOGIC;	
                  --input
		NEW_PC_AFTER_ADD_RESULT_IN      : in	STD_LOGIC_VECTOR (31 downto 0);

		REG_WRITE_IN		         	: in	STD_LOGIC; 
		MEM_TO_REG_IN                   : in    STD_LOGIC;
                		
		BRANCH_IN			            : in	STD_LOGIC; 		
		MEM_READ_IN			            : in	STD_LOGIC; 
		MEM_WRITE_IN                    : in    STD_LOGIC; 
     
		ZERO_IN      			        : in	STD_LOGIC; 
		ALU_RESULT_IN                   : in    STD_LOGIC_VECTOR (31 downto 0);                             
		READ_DATA2_OUT_IN 	            : in	STD_LOGIC_VECTOR (31 downto 0);
		DOWN_MUX_OUT_IN 	            : in	STD_LOGIC_VECTOR (4 downto 0);

                  --output
		NEW_PC_AFTER_ADD_RESULT_OUT     : out	STD_LOGIC_VECTOR (31 downto 0);

		REG_WRITE			            : out	STD_LOGIC; 
		MEM_TO_REG                      : out   STD_LOGIC;
                		
		BRANCH				            : out	STD_LOGIC; 		
		MEM_READ			            : out	STD_LOGIC; 
		MEM_WRITE                       : out   STD_LOGIC; 
     
		ZERO      		             	: out	STD_LOGIC; 
		ALU_RESULT                      : out   STD_LOGIC_VECTOR (31 downto 0);                               
		READ_DATA2_OUT 	                : out	STD_LOGIC_VECTOR (31 downto 0);
		DOWN_MUX_OUT 	                : out	STD_LOGIC_VECTOR (4 downto 0)
);
end  component EX_MEM_REGISTER;

-------------------------------------------------------------------------
        signal S_ADDR2_TO_EXmem   	    : STD_LOGIC_VECTOR (31 downto 0);
        signal S_ADDR2           	    : STD_LOGIC_VECTOR (31 downto 0);	
     
        signal S_ZERO_TO_EXmem	        : STD_LOGIC;	
        signal S_ALU_TO_EXmem	        : STD_LOGIC_VECTOR (31 downto 0);	
      
        signal S_ALUcontrol_TO_ALU   	: STD_LOGIC_VECTOR (2 downto 0);
        signal S_DOWNmux_TO_EXmem	    : STD_LOGIC_VECTOR (4 downto 0);

        signal S_ALU_MUX1             	: STD_LOGIC_VECTOR (31 downto 0);	
        signal S_ALU_MUX2        	    : STD_LOGIC_VECTOR (31 downto 0);
        signal S_ALU_BEFORE_midlle_mux  : STD_LOGIC_VECTOR (31 downto 0);	

begin
ALUblock:
		ALU                                  
          port map(
			READ_DATA1	       => S_ALU_MUX1,
			READ_DATA2         => S_ALU_MUX2,
			ALU_CONTROL        => S_ALUcontrol_TO_ALU,
			ZERO               => S_ZERO_TO_EXmem,
			ALU_RESULT         => S_ALU_TO_EXmem
 );
ALUcontrol:
		ALU_CONTROL
          port map(
			FUNCT              => OFFSET_OUT(5 downto 0),                      
			ALUOP0_IN          => ALUOP0_IN,
			ALUOP1_IN          => ALUOP1_IN,
			ALU_IN	           => S_ALUcontrol_TO_ALU
);
EXmemREG:
		EX_MEM_REGISTER
          port map(	
    --in
			CLK	                            => CLK,
			RESET	                        => RESET,
            NEW_PC_AFTER_ADD_RESULT_IN      => S_ADDR2_TO_EXmem,       
			REG_WRITE_IN	     		    => REG_WRITE_IN,
			MEM_TO_REG_IN	      		    => MEM_TO_REG_IN,
			BRANCH_IN	       			    => BRANCH_IN,
            MEM_READ_IN	       			    => MEM_READ_IN,
			MEM_WRITE_IN	     		    => MEM_WRITE_IN,
			ZERO_IN		       			    => S_ZERO_TO_EXmem,
			ALU_RESULT_IN	    		    => S_ALU_TO_EXmem,
			READ_DATA2_OUT_IN   	        => READ_DATA2_OUT_IN,
			DOWN_MUX_OUT_IN                 => S_DOWNmux_TO_EXmem,
   --out
             REG_WRITE	                    => REG_WRITE,
			MEM_TO_REG	                    => MEM_TO_REG,
			BRANCH		                    => BRANCH,
			MEM_READ	                    => MEM_READ,
			MEM_WRITE		                => MEM_WRITE, 
   
		    NEW_PC_AFTER_ADD_RESULT_OUT     => NEW_PC_AFTER_ADD_RESULT,
			ZERO	                        => ZERO,
			ALU_RESULT		                => ALU_RESULT,
			READ_DATA2_OUT	                => READ_DATA2_OUT,
			DOWN_MUX_OUT		            => DOWN_MUX_OUT     
);
------------------------------------------------------------------
--mux of alu upper input,   FOR FORWARD

S_ALU_MUX1 <= READ_DATA1_OUT    when   forward_A = "00" else
              ALU_OUT_MEM_IN    when   forward_A = "01" else
              RESULT_WB         when   forward_A = "10" else  (others=>'0'); 
------------------------------------------------------------------
--mux before midlle mux,   FOR FORWARD

S_ALU_BEFORE_midlle_mux <= READ_DATA2_OUT_IN when forward_B = "00" else
                           ALU_OUT_MEM_IN    when forward_B = "01" else
                           RESULT_WB         when forward_B = "10" else  (others=>'0'); 
------------------------------------------------------------------
--down mux 

S_DOWNmux_TO_EXmem <= RT_ADDR_OUT when (REGDST_IN = '0') else
                      RD_ADDR_OUT when (REGDST_IN = '1') else (others=>'0'); 
------------------------------------------------------------------
--midlle mux 

S_ALU_MUX2 <=         S_ALU_BEFORE_midlle_mux when (ALUSRC_IN = '0') else
                      OFFSET_OUT              when (ALUSRC_IN = '1') else  (others=>'0'); 
--------------------------------------------------------------------
--ADDR 2(of the BRANCH)
S_ADDR2 <= conv_std_logic_vector(((conv_integer(OFFSET_OUT))*4),32);

S_ADDR2_TO_EXmem <= (S_ADDR2+NEW_PC_ADDR_OUT);

RS_Exe<=RS_ADDR_OUT;

end architecture EXECUTE_ARC;