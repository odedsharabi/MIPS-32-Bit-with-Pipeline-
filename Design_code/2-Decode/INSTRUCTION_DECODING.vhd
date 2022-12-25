library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--##This is the block of all the componnents in the DECODE ##--

entity INSTRUCTION_DECODING is
 port(
	        --input
		CLK                     : in    std_logic;
		RESET                   : in    std_logic;
		NEW_PC_ADDR_IN			: in	STD_LOGIC_VECTOR (31 downto 0); 	
		INSTRUCTION				: in	STD_LOGIC_VECTOR (31 downto 0); 
		WRITE_REG_OUT			: in	STD_LOGIC_VECTOR (4 downto 0); 
		WRITE_DATA_OUT			: in	STD_LOGIC_VECTOR (31 downto 0); 
		REG_WRITE_IN1		    : in	STD_LOGIC;
 
                --output
		RegWrite				: out	STD_LOGIC; -- From write-back
        MEM_TO_REG              : out    STD_LOGIC;--  ''	''
                		
		BRANCH					: out	STD_LOGIC; -- From Memmory access		
		MEM_READ				: out	STD_LOGIC; --    ''    '' 
        MEM_WRITE               : out    STD_LOGIC; --   ''    ''	
                
        REGDST                  : out    STD_LOGIC; --From Execution
        ALUOP0                  : out    STD_LOGIC; --   ''    '' 
        ALUOP1                  : out    STD_LOGIC; --   ''    '' 
        ALUSRC                  : out    STD_LOGIC; --   ''    '' 	

		NEW_PC_ADDR_OUT			: out	STD_LOGIC_VECTOR (31 downto 0);
		
		OFFSET_OUT				: out	STD_LOGIC_VECTOR (31 downto 0);--    [15-0]
		RT_ADDR_OUT				: out	STD_LOGIC_VECTOR (4 downto 0);-- RT [20-16]
		RD_ADDR_OUT				: out	STD_LOGIC_VECTOR (4 downto 0);-- RD [15-11]
		RS_ADDR_OUT				: out	STD_LOGIC_VECTOR (4 downto 0);-- RS [25-21]
		
		READ_DATA1_OUT	 		: out	STD_LOGIC_VECTOR (31 downto 0); 
		READ_DATA2_OUT 			: out	STD_LOGIC_VECTOR (31 downto 0)			

	);
end INSTRUCTION_DECODING;


architecture INSTRUCTION_DECODING_ARC of INSTRUCTION_DECODING is 

---------------------------------------------------------------
component CONTROL is
	port( 
	
		OP				: in	STD_LOGIC_VECTOR (5 downto 0); 	

		RegWrite		: out	STD_LOGIC; 				
		MemtoReg		: out	STD_LOGIC;  				
		Branch			: out	STD_LOGIC; 				
		MemRead			: out	STD_LOGIC; 				
		MemWrite		: out	STD_LOGIC; 				
		RegDst			: out	STD_LOGIC; 				
		ALUSrc			: out	STD_LOGIC;				
		ALUOp0			: out	STD_LOGIC; 				
		ALUOp1			: out	STD_LOGIC 			
				

	);
end component CONTROL;

------------------------------------------------------------

component bor is
 port ( 
		clk        : in  std_logic;
		rst        : in  std_logic;
		-- write side
		reg_write  : in  std_logic;
		write_reg  : in  std_logic_vector(4  downto 0);
		write_data : in  std_logic_vector(31 downto 0);
		-- read side
		read_reg1  : in  std_logic_vector(4  downto 0);
		read_data1 : out std_logic_vector(31 downto 0);
		read_reg2  : in  std_logic_vector(4  downto 0);
		read_data2 : out std_logic_vector(31 downto 0)		
	  );
end component bor;

------------------------------------------------------------


component ID_EX_REGISTER is 
	port(
	
		CLK						: in	STD_LOGIC;				
		RESET					: in	STD_LOGIC;	
-------------ID SIDE			
                --Input from Data
		NEW_PC_ADDR_IN			: in	STD_LOGIC_VECTOR (31 downto 0);
		OFFSET_IN				: in	STD_LOGIC_VECTOR (31 downto 0);--    [15-0]
		RT_ADDR_IN				: in	STD_LOGIC_VECTOR (4 downto 0);-- RT [20-16]
		RD_ADDR_IN				: in	STD_LOGIC_VECTOR (4 downto 0);-- RD [15-11]
		RS_ADDR_IN				: in	STD_LOGIC_VECTOR (4 downto 0);-- RS [25-21]
		
		READ_DATA1_IN 	 		: in	STD_LOGIC_VECTOR (31 downto 0);
		READ_DATA2_IN 			: in	STD_LOGIC_VECTOR (31 downto 0);

		        --Input from Control
		REG_WRITE_IN			: in	STD_LOGIC; -- From write-back
        MEM_TO_REG_IN           : in    STD_LOGIC;--  ''	''
                		
		BRANCH_IN		        : in	STD_LOGIC; -- From Memmory access		
		MEM_READ_IN				: in	STD_LOGIC; --   ''    '' 
        MEM_WRITE_IN            : in    STD_LOGIC; --   ''    ''	
                
        REGDST_IN               : in    STD_LOGIC; --From Execution
        ALUOP0_IN               : in    STD_LOGIC; --   ''    '' 
        ALUOP1_IN               : in    STD_LOGIC; --   ''    '' 
        ALUSRC_IN               : in    STD_LOGIC; --   ''    '' 	
	      
		--------- EX Side
                --Output from Data
		
		NEW_PC_ADDR_OUT			: out	STD_LOGIC_VECTOR (31 downto 0);
		
		OFFSET_OUT				: out	STD_LOGIC_VECTOR (31 downto 0);--    [15-0]
		RT_ADDR_OUT				: out	STD_LOGIC_VECTOR (4 downto 0);-- RT [20-16]
		RD_ADDR_OUT				: out	STD_LOGIC_VECTOR (4 downto 0);-- RD [15-11]
		RS_ADDR_OUT				: out	STD_LOGIC_VECTOR (4 downto 0);-- RS [25-21]		
		READ_DATA1_OUT	 		: out	STD_LOGIC_VECTOR (31 downto 0); 
		READ_DATA2_OUT 			: out	STD_LOGIC_VECTOR (31 downto 0); 

                --Output from Control
		RegWrite				: out	STD_LOGIC; -- From write-back
        MEM_TO_REG              : out    STD_LOGIC;--  ''	''
                		
		BRANCH					: out	STD_LOGIC; -- From Memmory access		
		MEM_READ				: out	STD_LOGIC; --    ''    '' 
        MEM_WRITE               : out    STD_LOGIC; --   ''    ''	
                
        REGDST                  : out    STD_LOGIC; --From Execution
        ALUOP0                  : out    STD_LOGIC; --   ''    '' 
        ALUOP1                  : out    STD_LOGIC; --   ''    '' 
        ALUSRC                  : out    STD_LOGIC --   ''    ''  				
	);
end component ID_EX_REGISTER;

------------------------------------------------------------------------------

        signal CONTROL_WB1	: STD_LOGIC;	
        signal CONTROL_WB2	: STD_LOGIC;	

        signal CONTROL_M1	: STD_LOGIC;	
        signal CONTROL_M2	: STD_LOGIC;	
        signal CONTROL_M3	: STD_LOGIC;	

        signal CONTROL_EX1	: STD_LOGIC;	          
        signal CONTROL_EX2	: STD_LOGIC;	
        signal CONTROL_EX3	: STD_LOGIC;	
        signal CONTROL_EX4	: STD_LOGIC;	

        signal S_READ_DATA1	: STD_LOGIC_VECTOR (31 downto 0);	
        signal S_READ_DATA2	: STD_LOGIC_VECTOR (31 downto 0);	
        signal S_SIGN1   	: STD_LOGIC_VECTOR (31 downto 0);	
        signal S_SIGN2   	: STD_LOGIC_VECTOR (4 downto 0);	
        signal S_SIGN3   	: STD_LOGIC_VECTOR (4 downto 0);	
        signal S_SIGN4   	: STD_LOGIC_VECTOR (4 downto 0);	
        signal S_SIGN5   	: STD_LOGIC_VECTOR (5 downto 0);	
        signal S_RT         : STD_LOGIC_VECTOR (4 downto 0);
        signal S_RD         : STD_LOGIC_VECTOR (4 downto 0); 
        signal S_RS         : STD_LOGIC_VECTOR (4 downto 0); 
      

begin

S_SIGN1	<=  "0000000000000000" & INSTRUCTION(15 downto 0)   when INSTRUCTION(15) = '0'
					                                        else  "1111111111111111" & INSTRUCTION(15 downto 0);
					
S_SIGN5 <= INSTRUCTION(31 downto 26);
S_SIGN2 <= INSTRUCTION(20 downto 16);
S_SIGN3 <= INSTRUCTION(15 downto 11);
S_SIGN4 <= INSTRUCTION(25 downto 21);

S_RT    <= INSTRUCTION(20 downto 16);
S_RD    <= INSTRUCTION(15 downto 11);
S_RS    <= INSTRUCTION(25 downto 21);

contr : 
	 CONTROL           
		port map(
			OP		    => S_SIGN5,
			RegWrite	=> CONTROL_WB1,
			MemtoReg	=> CONTROL_WB2,
			Branch	    => CONTROL_M1,
            MemRead		=> CONTROL_M2,
			MemWrite	=> CONTROL_M3,
			RegDst		=> CONTROL_EX1,
			ALUSrc	    => CONTROL_EX2,
			ALUOp0		=> CONTROL_EX3,
			ALUOp1		=> CONTROL_EX4
		);

bankofregs:
	 bor
                port map(
			clk	                => CLK,
			rst	                => RESET,
			reg_write	        =>REG_WRITE_IN1,
            write_reg	        =>WRITE_REG_OUT,
            write_data	        =>WRITE_DATA_OUT,
			read_reg1           =>S_SIGN4,
            read_data1	        =>S_READ_DATA1,
			read_reg2           =>S_SIGN2,
			read_data2	        =>S_READ_DATA2
		);

IDEXreg:
	 ID_EX_REGISTER
                port map(	
--in
			CLK	                => CLK,
			RESET	            => RESET,
            NEW_PC_ADDR_IN	    => NEW_PC_ADDR_IN,
			OFFSET_IN	        => S_SIGN1,
			RT_ADDR_IN		    => S_RT,    
			RD_ADDR_IN		    => S_RD,
			RS_ADDR_IN		    => S_RS,
			READ_DATA1_IN	    => S_READ_DATA1,
			READ_DATA2_IN		=> S_READ_DATA2,
			REG_WRITE_IN	    => CONTROL_WB1,
			MEM_TO_REG_IN	    => CONTROL_WB2,
			BRANCH_IN	        => CONTROL_M1,
            MEM_READ_IN	        => CONTROL_M2,
			MEM_WRITE_IN	    => CONTROL_M3,
			REGDST_IN	        => CONTROL_EX1,
			ALUOP0_IN           => CONTROL_EX3,
			ALUOP1_IN	        => CONTROL_EX4,
			ALUSRC_IN	        => CONTROL_EX2,
--out
            NEW_PC_ADDR_OUT	    => NEW_PC_ADDR_OUT,
			OFFSET_OUT	        => OFFSET_OUT,
			RT_ADDR_OUT	        => RT_ADDR_OUT,    
			RD_ADDR_OUT			=> RD_ADDR_OUT,
			RS_ADDR_OUT			=> RS_ADDR_OUT,
			READ_DATA1_OUT	    => READ_DATA1_OUT,
			READ_DATA2_OUT		=> READ_DATA2_OUT,
			RegWrite	        => RegWrite,
			MEM_TO_REG	        => MEM_TO_REG,
			BRANCH	            => BRANCH,
            MEM_READ	        => MEM_READ,
			MEM_WRITE	        => MEM_WRITE,
			REGDST		        => REGDST,
			ALUOP0		        => ALUOP0,
			ALUOP1		        => ALUOP1,
			ALUSRC	            => ALUSRC   
);

end architecture INSTRUCTION_DECODING_ARC;