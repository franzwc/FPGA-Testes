-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Medipix Bridge
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Bridge de comunicacao com o chip medipix
--!
--! DETAILS:      
--!
--!- Project Name: Medipix_Bridge.v                       
--!- Module Name: Medipix_Bridge
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
entity DAC_Bridge is
--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------
port(
	-- Entradas Nios
	In_Reset                    :   in std_logic;
	In_Clk_Dac                  :   in std_logic;
	
	-- Saidas
	Out_Clk_Dac                 :   out std_logic;
	Out_Data_Dac                :	  out std_logic

);

end DAC_Bridge;

architecture DAC_Bridge_arc of DAC_Bridge is
--------------------------------------------------------------------------------
--  >> Declara��o dos sinais do Processo
--------------------------------------------------------------------------------


begin
process (In_Clk_Dac, In_Reset)
--------------------------------------------------------------------------------
--  >> Declara��o das vari�veis do Processo
--------------------------------------------------------------------------------


begin
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicializa��o das sa�das

--------------------------------------------------------------------------------
--  >> Implementa��o do circuito - funcionamento em fun��o da transi��o de clock
--------------------------------------------------------------------------------
elsif (rising_edge(In_Clk_Dac)) then

     Out_Clk_Dac<='0';
	  Out_Data_Dac<='0';
	
end if;
End process;
end DAC_Bridge_arc;
