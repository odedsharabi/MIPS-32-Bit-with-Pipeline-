library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity ID_EX_REGISTER is 
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
end ID_EX_REGISTER;

architecture ID_EX_REGISTER_ARC of ID_EX_REGISTER is
begin

	  process(CLK,RESET)
	  begin
		if RESET = '1' then
				NEW_PC_ADDR_OUT			<= (others => '0');
				OFFSET_OUT				<= (others => '0');
				RT_ADDR_OUT				<= (others => '0');
				RD_ADDR_OUT				<= (others => '0');
				RS_ADDR_OUT				<= (others => '0');
				READ_DATA1_OUT	 		<= (others => '0');
				READ_DATA2_OUT 		    <= (others => '0');
				RegWrite                <= '0';
                MEM_TO_REG              <= '0';
                BRANCH                  <= '0';
                MEM_READ                <= '0';
                MEM_WRITE               <= '0';
                REGDST                  <= '0';
                ALUOP0                  <= '0';
                ALUOP1                  <= '0';
                ALUSRC                  <= '0';

		elsif rising_edge(CLK) then
				NEW_PC_ADDR_OUT			<= NEW_PC_ADDR_IN;
				OFFSET_OUT				<= OFFSET_IN;
				RT_ADDR_OUT				<= RT_ADDR_IN;
				RD_ADDR_OUT				<= RD_ADDR_IN;	
				RS_ADDR_OUT				<= RS_ADDR_IN;
				READ_DATA1_OUT          <= READ_DATA1_IN;
                READ_DATA2_OUT          <= READ_DATA2_IN;
                RegWrite                <= REG_WRITE_IN;
                MEM_TO_REG              <= MEM_TO_REG_IN;
                BRANCH                  <= BRANCH_IN;
                MEM_READ                <= MEM_READ_IN;
                MEM_WRITE               <= MEM_WRITE_IN;
                REGDST                  <= REGDST_IN;
                ALUOP0                  <= ALUOP0_IN;
                ALUOP1                  <= ALUOP1_IN;   
                ALUSRC                  <= ALUSRC_IN;
		end if;
	  end process;

end architecture ID_EX_REGISTER_ARC;