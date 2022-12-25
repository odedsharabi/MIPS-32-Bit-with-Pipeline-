library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity CONTROL is
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
end entity CONTROL;

architecture CONTROL_ARC of CONTROL is  

begin 
   process (OP)
     begin
	    case OP is                				 --R_TYPE
                     when "000000" =>
                               RegDst<='1';
                               ALUOp1<='1';
                               ALUOp0<='0';
                               ALUSrc<='0';
                               Branch<='0'; 
                               MemRead<='0';
                               MemWrite<='0';
                               RegWrite<='1';
                               MemtoReg<='0';
                     when "100011"  =>            --LW
                               RegDst<='0';
                               ALUOp1<='0';
                               ALUOp0<='0';
                               ALUSrc<='1';
                               Branch<='0'; 
                               MemRead<='1';
                               MemWrite<='0';
                               RegWrite<='1';
                               MemtoReg<='1';
                     when "101011"  =>          	--SW
                               RegDst<='0';	
                               ALUOp1<='0';
                               ALUOp0<='0';
                               ALUSrc<='1';
                               Branch<='0'; 
                               MemRead<='0';
                               MemWrite<='1';
                               RegWrite<='0';
                               MemtoReg<='0';
                       when "000100"  =>        	 --BEQ
                               RegDst<='0';
                               ALUOp1<='0';
                               ALUOp0<='1';
                               ALUSrc<='0';
                               Branch<='1'; 
                               MemRead<='0';
                               MemWrite<='0';
                               RegWrite<='0';
                               MemtoReg<='0';

                       when "001000"  =>        	 --ADDI
                               RegDst<='0';
                               ALUOp1<='0';
                               ALUOp0<='0';
                               ALUSrc<='1';
                               Branch<='0'; 
                               MemRead<='0';
                               MemWrite<='0';
                               RegWrite<='1';
                               MemtoReg<='0';


                       when others=> 
                               RegDst<='0';
                               ALUOp1<='0';
                               ALUOp0<='0';
                               ALUSrc<='0';
                               Branch<='0'; 
                               MemRead<='0';
                               MemWrite<='0';
                               RegWrite<='0';
                               MemtoReg<='0';                 
    
	end case;
end process;

end architecture CONTROL_ARC;