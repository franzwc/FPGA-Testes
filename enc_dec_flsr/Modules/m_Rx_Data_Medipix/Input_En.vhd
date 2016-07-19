-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Input_En
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Input_En
--!
--! DETAILS:      
--!
--!- Project Name: Input_En.v                       
--!- Module Name: Input_En
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
				
entity Input_En is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :   in std_logic;
	In_Clk                      :   in std_logic;
	In_Clk_Mdpx                 :   in std_logic;
	In_En_Mdpx                  :   in std_logic;
	In_Data_Mdpx                :   in std_logic;
	In_OutEn_Mdpx               :   in std_logic;
	
	Out_Clk                     :   out std_logic;
	Out_En                      :   out std_logic;
	Out_Data                    :   out std_logic
		
);

end Input_En;

architecture Input_En_arc of Input_En is

begin

process (In_Clk, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then

	-- Inicialização das saídas
	Out_Clk             <='0';
	Out_En              <='0';
	Out_Data            <='0';
	
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (rising_edge(In_Clk)) then

	 if (not(In_OutEn_Mdpx)='1') then
	 
		 Out_Clk<=In_Clk_Mdpx;
	    Out_En<=In_En_Mdpx;
	    Out_Data<=In_Data_Mdpx;
	 else
	    Out_Clk<='0';
	    Out_En<='0';
	    Out_Data<='0';
	 end if;
	 
end if;

End process;

end Input_En_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA
