library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



entity MIPS is
	port(
		CLK		: in STD_LOGIC;					
		RESET		: in STD_LOGIC					
                                      				
	);
end MIPS;

architecture MIPS_ARC of MIPS is	

--------------------------------------------------------------------------
component INSTRUCTION_FETCHING is
	port(
		CLK		: in STD_LOGIC;					
		RESET		: in STD_LOGIC;					
		PCSrc           : in STD_LOGIC;                                       				
		NEW_PC_ADDR_IN2	: in STD_LOGIC_VECTOR(31 downto 0);	
		NEW_PC_ADDR_OUT	: out STD_LOGIC_VECTOR(31 downto 0);	
		INSTRUCTION 	: out STD_LOGIC_VECTOR(31 downto 0)	
	);
end component INSTRUCTION_FETCHING;

-------------------------------------------------------------------------


component INSTRUCTION_DECODING is
 port(
	        --input
		CLK                             : in  std_logic;
		RESET                           : in  std_logic;
		NEW_PC_ADDR_IN			: in	STD_LOGIC_VECTOR (31 downto 0); 	
		INSTRUCTION			: in	STD_LOGIC_VECTOR (31 downto 0); 
		WRITE_REG_OUT			: in	STD_LOGIC_VECTOR (4 downto 0); 
		WRITE_DATA_OUT			: in	STD_LOGIC_VECTOR (31 downto 0); 
		REG_WRITE_IN1                   : in	STD_LOGIC;
 
                --output
		RegWrite			: out	STD_LOGIC; -- From write-back
                MEM_TO_REG                      : out    STD_LOGIC;--  ''	''
                		
		BRANCH				: out	STD_LOGIC; -- From Memmory access		
		MEM_READ			: out	STD_LOGIC; --    ''    '' 
                MEM_WRITE                       : out    STD_LOGIC; --   ''    ''	
                
                REGDST                          : out    STD_LOGIC; --From Execution
                ALUOP0                          : out    STD_LOGIC; --   ''    '' 
                ALUOP1                          : out    STD_LOGIC; --   ''    '' 
                ALUSRC                          : out    STD_LOGIC; --   ''    '' 	

		NEW_PC_ADDR_OUT			: out	STD_LOGIC_VECTOR (31 downto 0);
		
		OFFSET_OUT			: out	STD_LOGIC_VECTOR (31 downto 0);--    [15-0]
		RT_ADDR_OUT			: out	STD_LOGIC_VECTOR (4 downto 0);-- RT [20-16]
		RD_ADDR_OUT			: out	STD_LOGIC_VECTOR (4 downto 0);-- RD [15-11]
		RS_ADDR_OUT			: out	STD_LOGIC_VECTOR (4 downto 0);-- RS [25-21]      --lechavet
		
		READ_DATA1_OUT	 		: out	STD_LOGIC_VECTOR (31 downto 0); 
		READ_DATA2_OUT 			: out	STD_LOGIC_VECTOR (31 downto 0)			

	);
end component INSTRUCTION_DECODING;

--------------------------------------------------------------------------

component EXECUTE is
       port(
	        
		CLK                             : in  STD_LOGIC;
		RESET                           : in  STD_LOGIC;
 
                
		REG_WRITE_IN			: in  STD_LOGIC; 
                MEM_TO_REG_IN                   : in  STD_LOGIC;
                		
		BRANCH_IN			: in  STD_LOGIC; 		
		MEM_READ_IN			: in  STD_LOGIC; 
                MEM_WRITE_IN                    : in  STD_LOGIC; 
                
                REGDST_IN                       : in    STD_LOGIC; --From Execution
                ALUOP0_IN                       : in    STD_LOGIC; --   ''    '' 
                ALUOP1_IN                       : in    STD_LOGIC; --   ''    '' 
                ALUSRC_IN                       : in    STD_LOGIC; --   ''    '' 	

		NEW_PC_ADDR_OUT			: in	STD_LOGIC_VECTOR (31 downto 0);
		
		OFFSET_OUT			: in	STD_LOGIC_VECTOR (31 downto 0);--    [15-0]
		RT_ADDR_OUT			: in	STD_LOGIC_VECTOR (4 downto 0);-- RT [20-16]
		RD_ADDR_OUT			: in	STD_LOGIC_VECTOR (4 downto 0);-- RD [15-11]
		RS_ADDR_OUT			: in	STD_LOGIC_VECTOR (4 downto 0);-- RS [25-21]  --lechavet
		
		READ_DATA1_OUT	 		: in	STD_LOGIC_VECTOR (31 downto 0); 
		READ_DATA2_OUT_IN 		: in	STD_LOGIC_VECTOR (31 downto 0); 	

                forward_A                   : in  std_logic_vector (1 downto 0);       -- forward mux select 1   --forward A
		forward_B                   : in  std_logic_vector (1 downto 0);       -- forward mux select 2   --forward B
	        ALU_OUT_MEM_IN                  : in  std_logic_vector (31 downto 0);      -- data from memory stage for alu
		RESULT_WB                         : in  std_logic_vector (31 downto 0);      -- data from stage writeback for alu

		REG_WRITE			: out	STD_LOGIC; 
                MEM_TO_REG                      : out    STD_LOGIC;
                		
		BRANCH				: out	STD_LOGIC; 		
		MEM_READ			: out	STD_LOGIC; 
                MEM_WRITE                       : out   STD_LOGIC; 	
             
                NEW_PC_AFTER_ADD_RESULT         : out	std_logic_vector(31 downto 0);
                ZERO                            : out   std_logic;
                ALU_RESULT                      : out   std_logic_vector(31 downto 0);
		READ_DATA2_OUT 			: out	STD_LOGIC_VECTOR (31 downto 0); 
                DOWN_MUX_OUT                    : out   std_logic_vector(4 downto 0);
 
              --  EXE_OUT_TO_FORWARD              : out   std_logic_vector(4 downto 0);           --output to forward unit		
                RS_Exe                          : out   std_logic_vector(4 downto 0)            -- output to forward unit	

	);
end component EXECUTE;

----------------------------------------------------------------------
component MEMORY is
port(
--input
		CLK                             : in  std_logic;
		RESET                           : in  std_logic;

		REG_WRITE			: in	STD_LOGIC; -- From write-back
                MEM_TO_REG                      : in    STD_LOGIC;--  ''	''

                ADD_RESULT4_IN                  : in   STD_LOGIC_VECTOR (31 downto 0);
                		
		BRANCH				: in	STD_LOGIC; -- From Memmory access		
		MEM_READ			: in	STD_LOGIC; --    ''    '' 
                MEM_WRITE                       : in    STD_LOGIC; --   ''    ''	
	
		ZERO			        : in	STD_LOGIC;
		ALU_RESULT			: in	STD_LOGIC_VECTOR (31 downto 0);
		READ_DATA2_OUT 			: in	STD_LOGIC_VECTOR (31 downto 0);
	        DOWN_MUX_OUT_IN                 : in   std_logic_vector(4 downto 0);
--out
                PCSrc                           : out	std_logic;
                ADD_RESULT4                     : out   STD_LOGIC_VECTOR (31 downto 0);
                REG_WRITE_OUT			: out	STD_LOGIC; 
                MEM_TO_REG_OUT                  : out    STD_LOGIC;
     
                READ_DATA_MEM_OUT      		: out	STD_LOGIC_VECTOR (31 downto 0); 
                ALU_RESULT_OUT                  : out    STD_LOGIC_VECTOR (31 downto 0);                    
                DOWN_MUX_OUT 	                : out	STD_LOGIC_VECTOR (4 downto 0);

                REG_write_HAZARD                : out    STD_LOGIC; 
                WRITE_REG_MEM_HAZARD            : out    STD_LOGIC_VECTOR (4 downto 0); 
                ALU_RESULT_HAZARD               : out    STD_LOGIC_VECTOR (31 downto 0)      
	
	);
end component MEMORY;




----------------------------------------------------------------------------------
component WRITE_BACK is
port( 		
                --Input
                MEM_TO_REG_IN                      : in    STD_LOGIC;--  ''	''
                READ_DATA_MEM_IN      		: in	STD_LOGIC_VECTOR (31 downto 0); 
                ALU_RESULT_IN                      : in    STD_LOGIC_VECTOR (31 downto 0);                    
                  --output                 
                WRITE_DATA_OUT                  : out    STD_LOGIC_VECTOR (31 downto 0);
                 WB_Hazard                       : out    STD_LOGIC_VECTOR (31 downto 0)                 	

);
end component WRITE_BACK;

------------------------------------------------------------------------------------------------
component FORWARDING_UNIT is
	port(
		ID_EX_OUT_RS		: in STD_LOGIC_VECTOR(4 downto 0);					
		ID_EX_OUT_RT		: in STD_LOGIC_VECTOR(4 downto 0);					
		EX_MEM_RD               : in STD_LOGIC_VECTOR(4 downto 0);                                       				
		MEM_WB_RD	        : in STD_LOGIC_VECTOR(4 downto 0);
		MEM_WB_REG_WRITE 	: in STD_LOGIC;	                        -- regwrute wb
		EX_MEM_REG_WRITE	: in STD_LOGIC;	                         --regwrite mem
		forward_A	        : out STD_LOGIC_VECTOR(1 downto 0);      --forward_mux_1_control     upper input of alu
		forward_B	        : out STD_LOGIC_VECTOR(1 downto 0)        --forward_mux_2_control    down input of alu
	
	);
end component FORWARDING_UNIT;
-----------------------------------------------------------------------------------
	signal S_MIPS_AUX1	: STD_LOGIC_VECTOR (31 downto 0);	
	signal S_MIPS_AUX2	: STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX3	: STD_LOGIC;
	signal S_MIPS_AUX4	: STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX5	: STD_LOGIC;
	signal S_MIPS_AUX6	: STD_LOGIC;
	signal S_MIPS_AUX7	: STD_LOGIC;
	signal S_MIPS_AUX8	: STD_LOGIC;
	signal S_MIPS_AUX9	: STD_LOGIC;
	signal S_MIPS_AUX10	: STD_LOGIC;
	signal S_MIPS_AUX11	: STD_LOGIC;
	signal S_MIPS_AUX12	: STD_LOGIC;
	signal S_MIPS_AUX13	: STD_LOGIC;
	signal S_MIPS_AUX14	: STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX15	: STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX16	: STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX17	: STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX18	: STD_LOGIC_VECTOR (4 downto 0);
	signal S_MIPS_AUX19	: STD_LOGIC_VECTOR (4 downto 0);
	signal S_MIPS_AUX20	: STD_LOGIC;
	signal S_MIPS_AUX21	: STD_LOGIC;
	signal S_MIPS_AUX22	: STD_LOGIC;
	signal S_MIPS_AUX23	: STD_LOGIC;
	signal S_MIPS_AUX24	: STD_LOGIC;
	signal S_MIPS_AUX25	: STD_LOGIC;
	signal S_MIPS_AUX26	: STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX27	: STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX28	: STD_LOGIC_VECTOR (4 downto 0);
	signal S_MIPS_AUX29	: STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX30	: STD_LOGIC_VECTOR (4 downto 0);
	signal S_MIPS_AUX31	: STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX32	: STD_LOGIC;

	signal S_MIPS_AUX4_EX_MEM_ADDRESULT	            : STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX_EX_MEM_MEMTOREG	            : STD_LOGIC;
	signal S_MIPS_AUX_EX_MEM_READDATA2	            : STD_LOGIC_VECTOR (31 downto 0);
	signal S_MIPS_AUX_EX_MEM_ALURESULT	            : STD_LOGIC_VECTOR (31 downto 0);
        signal S_MIPS_FromMem_To_EX                         : STD_LOGIC_VECTOR (31 downto 0); -- Going from the memory to the muxes in the execute
        signal S_MIPS_FromMem_To_ForwardUnit_Address        :STD_LOGIC_VECTOR(4 downto 0);
        signal S_MIPS_FromMem_To_ForwardingUnit_bit         :STD_LOGIC;
        signal S_MIPS_RS_From_Decode_To_execute             :STD_LOGIC_VECTOR(4 downto 0);
        signal S_MIPS_MUXSelect_For_UpperMux_OfALU          :STD_LOGIC_VECTOR(1 downto 0);
        signal S_MIPS_MUXSelect_For_NewMiddleMux_OfALU      :STD_LOGIC_VECTOR(1 downto 0);
        signal S_MIPS_RS_TO_FORWARDING                      :STD_LOGIC_VECTOR(4 downto 0);   
        signal S_MIPS_SHO                                   :STD_LOGIC_VECTOR(31 downto 0);  
        


begin



instra : 
	INSTRUCTION_FETCHING           
		port map(
			CLK		        => CLK,
			RESET		        => RESET,
			PCSrc		        => S_MIPS_AUX3,
			NEW_PC_ADDR_IN2   	=> S_MIPS_AUX4,
			NEW_PC_ADDR_OUT		=> S_MIPS_AUX1,
			INSTRUCTION	        => S_MIPS_AUX2

		);
	
decode:
		INSTRUCTION_DECODING
                  port map(
			CLK		        =>      CLK,
			RESET		        =>      RESET,
			NEW_PC_ADDR_IN		=>      S_MIPS_AUX1,
			INSTRUCTION		=>      S_MIPS_AUX2,
			WRITE_REG_OUT		=>      S_MIPS_AUX30,
			WRITE_DATA_OUT		=>      S_MIPS_AUX31,
			REG_WRITE_IN1		=>      S_MIPS_AUX32,

			RegWrite		=> 	S_MIPS_AUX5,
			MEM_TO_REG		=>      S_MIPS_AUX6,
			BRANCH		        =>      S_MIPS_AUX7,
			MEM_READ		=>	S_MIPS_AUX8,
			MEM_WRITE		=> 	S_MIPS_AUX9,
			REGDST		        =>      S_MIPS_AUX10,
			ALUOP0		        =>      S_MIPS_AUX11,
			ALUOP1		        =>	S_MIPS_AUX12,
			ALUSRC		        => 	S_MIPS_AUX13,

			NEW_PC_ADDR_OUT		=>	S_MIPS_AUX14,
			OFFSET_OUT		=> 	S_MIPS_AUX17,
			RT_ADDR_OUT		=>      S_MIPS_AUX18,
			RD_ADDR_OUT		=>      S_MIPS_AUX19,
			READ_DATA1_OUT		=>	S_MIPS_AUX15,
			READ_DATA2_OUT		=> 	S_MIPS_AUX16,
                        RS_ADDR_OUT             =>      S_MIPS_RS_From_Decode_To_execute
                        
		);
		
exe:
		EXECUTE
                   port map(
			CLK		        	=>      CLK,
			RESET		        	=>      RESET,
			REG_WRITE_IN			=> 	S_MIPS_AUX5,
			MEM_TO_REG_IN			=>      S_MIPS_AUX6,
			BRANCH_IN		        =>      S_MIPS_AUX7,
			MEM_READ_IN			=>	S_MIPS_AUX8,
			MEM_WRITE_IN			=> 	S_MIPS_AUX9,
			REGDST_IN		        =>      S_MIPS_AUX10,
			ALUOP0_IN		        =>      S_MIPS_AUX11,
			ALUOP1_IN		        =>	S_MIPS_AUX12,
			ALUSRC_IN		        => 	S_MIPS_AUX13,

			NEW_PC_ADDR_OUT			=>	S_MIPS_AUX14,
			OFFSET_OUT			=> 	S_MIPS_AUX17,
			RT_ADDR_OUT			=>      S_MIPS_AUX18,
			RD_ADDR_OUT			=>      S_MIPS_AUX19,
                        RS_ADDR_OUT                     =>      S_MIPS_RS_From_Decode_To_execute,
			READ_DATA1_OUT			=>	S_MIPS_AUX15,
			READ_DATA2_OUT_IN		=>      S_MIPS_AUX16,
                        forward_A                       =>      S_MIPS_MUXSelect_For_UpperMux_OfALU,  
                        forward_B                       =>      S_MIPS_MUXSelect_For_NewMiddleMux_OfALU,
                        ALU_OUT_MEM_IN                  =>      S_MIPS_FromMem_To_EX,
                        RESULT_WB                       =>       S_MIPS_SHO,

                       --out
			REG_WRITE			=> 	S_MIPS_AUX20,
			MEM_TO_REG			=>      S_MIPS_AUX21,
			BRANCH		   	        =>      S_MIPS_AUX22,
			MEM_READ			=>	S_MIPS_AUX23,
			MEM_WRITE			=> 	S_MIPS_AUX24,
			NEW_PC_AFTER_ADD_RESULT	        =>      S_MIPS_AUX4_EX_MEM_ADDRESULT,
			ZERO		                =>      S_MIPS_AUX25,
			ALU_RESULT		        =>	S_MIPS_AUX26,
			READ_DATA2_OUT		        => 	S_MIPS_AUX27,
			DOWN_MUX_OUT		        =>	S_MIPS_AUX28,     
                        RS_Exe                          =>      S_MIPS_RS_TO_FORWARDING



		);	
  
mem:
              MEMORY
                port map(
			CLK		        =>      CLK,
			RESET		        =>      RESET,
			REG_WRITE		=> 	S_MIPS_AUX20,
			MEM_TO_REG		=>      S_MIPS_AUX21,
                        ADD_RESULT4_IN          =>      S_MIPS_AUX4_EX_MEM_ADDRESULT,
			BRANCH		        =>      S_MIPS_AUX22,
			MEM_READ		=>	S_MIPS_AUX23,
			MEM_WRITE		=> 	S_MIPS_AUX24,
			ZERO		        =>      S_MIPS_AUX25,
			ALU_RESULT	        =>      S_MIPS_AUX26,
			READ_DATA2_OUT		=>	S_MIPS_AUX27,
			DOWN_MUX_OUT_IN		=> 	S_MIPS_AUX28,
			PCSrc		        => 	S_MIPS_AUX3,
			ADD_RESULT4		=> 	S_MIPS_AUX4,
			REG_WRITE_OUT		=> 	S_MIPS_AUX32,
			MEM_TO_REG_OUT		=> 	S_MIPS_AUX_EX_MEM_MEMTOREG,
			READ_DATA_MEM_OUT 	=> 	S_MIPS_AUX_EX_MEM_READDATA2,
			ALU_RESULT_OUT		=> 	S_MIPS_AUX_EX_MEM_ALURESULT,
			DOWN_MUX_OUT		=> 	S_MIPS_AUX30,

                        REG_write_HAZARD        =>      S_MIPS_FromMem_To_ForwardingUnit_bit,
                        WRITE_REG_MEM_HAZARD    =>      S_MIPS_FromMem_To_ForwardUnit_Address,             
                        ALU_RESULT_HAZARD       =>      S_MIPS_FromMem_To_EX  
                        

                );

Wback:
              WRITE_BACK
                 port map(
			MEM_TO_REG_IN	       => S_MIPS_AUX_EX_MEM_MEMTOREG,
			READ_DATA_MEM_IN       => S_MIPS_AUX_EX_MEM_READDATA2,
                        ALU_RESULT_IN          => S_MIPS_AUX_EX_MEM_ALURESULT,
                        WRITE_DATA_OUT         => S_MIPS_AUX31,   
                        WB_Hazard              => S_MIPS_SHO

                );

ForwarUnit:  FORWARDING_UNIT
                port map(
                         ID_EX_OUT_RS	  => S_MIPS_RS_TO_FORWARDING,				
		         ID_EX_OUT_RT	  => S_MIPS_AUX18,			
		         EX_MEM_RD        => S_MIPS_FromMem_To_ForwardUnit_Address,                                             				
		         MEM_WB_RD	  => S_MIPS_AUX30,    
		         MEM_WB_REG_WRITE => S_MIPS_AUX32,
		         EX_MEM_REG_WRITE => S_MIPS_FromMem_To_ForwardingUnit_bit,
		         forward_A        => S_MIPS_MUXSelect_For_UpperMux_OfALU,      
		         forward_B	  => S_MIPS_MUXSelect_For_NewMiddleMux_OfALU   
);   
	

end architecture MIPS_ARC;