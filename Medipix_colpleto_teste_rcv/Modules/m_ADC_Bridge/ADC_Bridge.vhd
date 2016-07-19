--! VHDL FILE
--  @file
--------------------------------------------------------------------------------
--  @brief ADC Bridge
--------------------------------------------------------------------------------
-- Adc Bridge.
--
-- faz a comunicacao com o adc e o fpga
--
-- Project Name: ADC_Bridge.vhdl
--
-- Tools: Quartus II 10.0 SP1
--
-- @name ADC_Bridge
-- @author Franz Wagner
-- @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
-- @date 30/10/2013
-- @version 1.0.0 (Nov/2013)
--
--------------------------------------------------------------------------------
--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
entity ADC_Bridge is
--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------
port(
	-- Entradas Nios
	In_Reset                    :   in std_logic;
	In_Clk_Adc                  :   in std_logic;
	In_Adc_data                 :   in std_logic;
	
	-- Saidas
	Out_Adc                     :   out std_logic

);

end ADC_Bridge;

architecture ADC_Bridge_arc of ADC_Bridge is
--------------------------------------------------------------------------------
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------


begin
process (In_Clk_Adc, In_Reset)
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
elsif (rising_edge(In_Clk_Adc)) then

	   	Out_Adc<='0';
end if;
End process;
end ADC_Bridge_arc;
