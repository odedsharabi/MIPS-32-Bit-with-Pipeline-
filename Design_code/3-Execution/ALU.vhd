library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU is

port (
      
       READ_DATA1             :    in  std_logic_vector(31 downto 0);
       READ_DATA2             :    in  std_logic_vector(31 downto 0);
       ALU_CONTROL            :    in  std_logic_vector(2 downto 0);
       ZERO                   :    out std_logic;
       ALU_RESULT             :    out std_logic_vector(31 downto 0)


    );

end entity ALU;
architecture ALU_arc of ALU is 

Signal ResultX : std_logic_vector(31 downto 0);
                              
   begin
    process(READ_DATA1,READ_DATA2,ALU_CONTROL)
      begin
            case ALU_CONTROL is
    
                    when "000" => 
                     ResultX <= READ_DATA1 and READ_DATA2;
                    
                   when "001" =>
                     ResultX <= READ_DATA1 or READ_DATA2;
 
                   when "010" =>
                    ResultX <=(unsigned(READ_DATA1) + unsigned(READ_DATA2));

                   when "110" =>
                     ResultX <=(unsigned(READ_DATA1) - unsigned(READ_DATA2));

                  when "111" =>
                    if(READ_DATA1<READ_DATA2) then
                     ResultX <= x"00000001";
                     else
                     ResultX <= x"00000000";
                    end if;

                when others =>
                  ResultX <= x"00000000";
                    

             end case;
        end process;
                                    

ALU_RESULT <= ResultX;
ZERO<= '1' when ResultX <= x"00000000" else '0';

end architecture ALU_arc;	