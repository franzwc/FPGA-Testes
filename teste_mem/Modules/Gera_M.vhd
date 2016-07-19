-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Gera M
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Gera M
--!
--! DETAILS:      
--!
--!- Project Name: Gera_M.vhd                       
--!- Module Name: Gera_M
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
entity Gera_M is
--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------
port(
	-- Entradas Nios
	In_Reset                    : in std_logic;
	In_Clk_nios                 : in std_logic;
	-- decoder param
	In_Send_OMR                 : in std_logic;
	In_Send_LDac                : in std_logic;
	In_Send_RDac                :	in std_logic;
	In_Send_LCtpr               :	in std_logic;
	In_Send_LCH                 :	in std_logic;
	In_Send_RCH                 :	in std_logic;
	--load dacs
	In_Send_DACS                :	in std_logic;
	
	-- Saidas
	Out_M                       : out std_logic_vector(2 downto 0) :=(others=>'0')

);

end Gera_M;

architecture Gera_M_arc of Gera_M is
--------------------------------------------------------------------------------
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------

begin
process (In_Clk_nios, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable var_tipo              : std_logic_vector(7 downto 0) :=(others=>'0');

begin
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_M               <=(others=>'0');
	
	var_tipo            :=(others=>'0');
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------
elsif (rising_edge(In_Clk_nios)) then

   var_tipo(0):=In_Send_OMR;
	var_tipo(1):=In_Send_LDac;
	var_tipo(2):=In_Send_RDac;
	var_tipo(3):=In_Send_LCtpr;
	var_tipo(4):=In_Send_LCH;
	var_tipo(5):=In_Send_RCH;
	var_tipo(6):=In_Send_DACS;
	var_tipo(7):='0';

	case var_tipo is
		when b"00000001" =>
			Out_M<=b"111";
		when b"00000010" =>
			Out_M<=b"100";
		when b"00000100" =>
			Out_M<=b"110";
		when b"00001000" =>
			Out_M<=b"101";
		when b"00010000" =>
			Out_M<=b"011";
		when b"00100000" =>
			Out_M<=b"001";
		when b"01000000" =>
			Out_M<=b"100";
		when others =>
			-- Sequential Statement(s)
	end case;

	
end if;
End process;
end Gera_M_arc;
