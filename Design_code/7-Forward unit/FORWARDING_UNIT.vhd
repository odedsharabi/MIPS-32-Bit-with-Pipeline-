library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


entity FORWARDING_UNIT is
	port(
		ID_EX_OUT_RS		: in STD_LOGIC_VECTOR(4 downto 0);					
		ID_EX_OUT_RT		: in STD_LOGIC_VECTOR(4 downto 0);					
		EX_MEM_RD               : in STD_LOGIC_VECTOR(4 downto 0);                                       				
		MEM_WB_RD	        : in STD_LOGIC_VECTOR(4 downto 0);
		MEM_WB_REG_WRITE 	: in STD_LOGIC;	                        -- regwrute wb
		EX_MEM_REG_WRITE	: in STD_LOGIC;	                         --regwrite mem
		forward_A	: out STD_LOGIC_VECTOR(1 downto 0);      --forward_mux_1_control     upper input of alu
		forward_B	: out STD_LOGIC_VECTOR(1 downto 0)        --forward_mux_2_control    down input of alu
	
	);
end FORWARDING_UNIT;


architecture FORWARDING_UNIT_ARC of FORWARDING_UNIT is	
begin
          
forward_A <=  ("01")  when ((EX_MEM_REG_WRITE='1') and (ID_EX_OUT_RS=EX_MEM_RD)) 
                     else ("10") when  ((MEM_WB_REG_WRITE='1') and (ID_EX_OUT_RS=MEM_WB_RD) and (EX_MEM_RD/=ID_EX_OUT_RS)) 
		     else ("00");

 forward_B <= "01"  when
                                 ((MEM_WB_REG_WRITE='1') and (EX_MEM_RD=ID_EX_OUT_RT))  
                else ("10")  when((MEM_WB_REG_WRITE='1') and (ID_EX_OUT_RT=MEM_WB_RD) and (MEM_WB_RD/=ID_EX_OUT_RT))
                else ("00");	

end FORWARDING_UNIT_ARC;