--! VHDL FILE
--  @file
--------------------------------------------------------------------------------
--  @brief DAC Bridge
--------------------------------------------------------------------------------
--
-- Faz a comunicaao do dac com o sopc
--
-- Project Name: DAC_Bridge.vhdl
--
-- Tools: Quartus II 10.0 SP1
--
-- @name DAC Bridge
-- @author Franz Wagner
-- @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
-- @date 07/07/2014
-- @version 1.0.0 (Jul/2014)
--
--------------------------------------------------------------------------------*/

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
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------


begin
process (In_Clk_Dac, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------


begin
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas

--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------
elsif (rising_edge(In_Clk_Dac)) then

     Out_Clk_Dac<='0';
	  Out_Data_Dac<='0';
	
end if;
End process;
end DAC_Bridge_arc;
