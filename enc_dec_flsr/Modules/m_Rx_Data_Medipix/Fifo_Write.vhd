-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Fifo_Write
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Fifo_Write
--!
--! DETAILS:      
--!
--!- Project Name: Fifo_Write.v                       
--!- Module Name: Fifo_Write
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 2/12/2013     
--!- Version: 1.0.0 (Dez/2013) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2013
--------------------------------------------------------------------------------
--}}} Header*/

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--------------------------------------------------------------------------------
				
entity Fifo_Write is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :   in std_logic;
	In_Clk_Mdpx                 :   in std_logic;
	In_En_Mdpx                  :   in std_logic;
	In_Data_Mdpx                :   in std_logic;
	In_PS                       :   in std_logic_vector(1 downto 0);
	
	Out_En_RCH                  :   out std_logic;
	Out_Data_RCH                :   out std_logic
		
);

end Fifo_Write;

architecture Fifo_Write_arc of Fifo_Write is

signal sig_in_en               :  std_logic;
signal sig_in_en_ant           :  std_logic;
signal sig_in_data             :  std_logic;

begin

process (In_Clk_Mdpx, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable cont                  : natural;
variable v_clk_pulses          : natural;
variable v_Standby             : natural range 0 to 30; 

begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) THEN

	-- Inicialização das saídas
	Out_En_RCH          <='0';
	Out_Data_RCH        <='0';

   sig_in_data         <='0';
	sig_in_en_ant       <='0';
	sig_in_en           <='0';
	
	cont                :=0;
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (falling_edge(In_Clk_Mdpx)) then

    sig_in_data<=In_Data_Mdpx;
    sig_in_en_ant<=sig_in_en;
	 sig_in_en<=In_En_Mdpx;
	 
	 --v_PS:=to_integer(unsigned(In_PS))
	 
	 if cont>=v_clk_pulses then
	    cont:=0;
		 v_Standby:=1;
		 sig_in_data<='0';
		 sig_in_en_ant<='0';
		 sig_in_en<='0';
		 Out_En_RCH<='0';
		 Out_Data_RCH<='0';
	 end if;
	 
	 case In_PS is
			when b"00" =>--data out 0
	                  v_clk_pulses:=65500;
							if ((sig_in_en_ant='0' and sig_in_en='1') and v_Standby =0) then
								cont:=1;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							elsif ((sig_in_en_ant='1' and sig_in_en='1') and (v_Standby =0) and (cont<=v_clk_pulses)) then
								cont:=cont+1;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							elsif ((sig_in_en_ant='1' and sig_in_en='0') and v_Standby =0) then
								cont:=65666;
								v_Standby:=1;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							else
							   v_Standby:=0;
								cont:=0;
								Out_En_RCH<='0';
								Out_Data_RCH<='0';
							end if;
							
			when b"10" =>--data out [3:0]
			            v_clk_pulses:=16530;
							if (sig_in_en_ant='0' and sig_in_en='1') then
								cont:=1;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							elsif ((sig_in_en_ant='1' and sig_in_en='1') and (cont>=1 and cont<=v_clk_pulses)) then
								cont:=cont+1;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							elsif (sig_in_en_ant='1' and sig_in_en='0' and cont>1) then
								cont:=65666;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							else
								cont:=0;
								Out_En_RCH<='0';
								Out_Data_RCH<='0';
							end if;
			when b"01" =>--data out [1:0]
			            v_clk_pulses:=32914;
							if (sig_in_en_ant='0' and sig_in_en='1') then
								cont:=1;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							elsif ((sig_in_en_ant='1' and sig_in_en='1') and (cont>=1 and cont<=v_clk_pulses)) then
								cont:=cont+1;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							elsif (sig_in_en_ant='1' and sig_in_en='0' and cont>1) then
								cont:=65666;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							else
								cont:=0;
								Out_En_RCH<='0';
								Out_Data_RCH<='0';
							end if;
			when b"11" =>--data out [7:0]
			            v_clk_pulses:=8329;
							if (sig_in_en_ant='0' and sig_in_en='1') then
								cont:=1;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							elsif ((sig_in_en_ant='1' and sig_in_en='1') and (cont>=1 and cont<=v_clk_pulses)) then
								cont:=cont+1;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							elsif (sig_in_en_ant='1' and sig_in_en='0' and cont>1) then
								cont:=65666;
								Out_En_RCH<='1';
								Out_Data_RCH<=sig_in_data;
							else
								cont:=0;
								Out_En_RCH<='0';
								Out_Data_RCH<='0';
							end if;
			when others =>
			            Out_En_RCH<='0';
							Out_Data_RCH<='0';
							cont:=0;
	 end case;
	 
	 if v_Standby>0 and v_Standby< 5 then
		v_Standby:=v_Standby+1;
	else
		v_Standby:=0;
	end if;
	 
end if;

End process;

end Fifo_Write_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA
