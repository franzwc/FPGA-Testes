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
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--------------------------------------------------------------------------------


entity Rx_Data_Medipix is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :   in std_logic;
	In_Clk_Mdpx                 :   in std_logic;
	In_En_Mdpx                  :   in std_logic;
   In_Data_Mdpx                :	  in std_logic;
	In_M                        :	  in std_logic_vector(2 downto 0);
	
	Out_En_RCL                  :   out std_logic;
	Out_Data_RCL                :   out std_logic;
	
	Out_En_RCH                  :   out std_logic;
	Out_Data_RCH                :   out std_logic;
	
	Out_En_RDAC                 :   out std_logic;
	Out_Data_RDAC               :   out std_logic;
	
	Out_En_ROMR                 :   out std_logic;
	Out_Data_ROMR               :   out std_logic
		
);

end Rx_Data_Medipix;

architecture Rx_Data_Medipix_arc of Rx_Data_Medipix is

signal sig_in_data_mdpx        :  std_logic_vector(7 downto 0);
signal sig_in_en_mdpx          :  std_logic;

begin

process (In_Clk_Mdpx, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------

variable conta_byte		     : integer range 0 to 255;
variable var_M               : std_logic_vector(2 downto 0);

begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
	var_M:=In_M;

if (In_Reset = '1' ) THEN

	-- Inicialização das saídas
	Out_En_ETH          <='0';
	Out_Data_ETH        <=(others=>'0');

--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (falling_edge(In_Clk_Mdpx)) then

	sig_in_data_mdpx<=In_Data_Mdpx;
	sig_in_en_mdpx<=In_En_Mdpx;
	
	case var_M is
		when b"000" =>
			-- read counter l
			Out_En_RCL<=sig_in_en_mdpx;
	      Out_Data_RCL<=sig_in_en_mdpx;
		when b"001" =>
			-- read counter h
			Out_En_RCH<=sig_in_en_mdpx;
	      Out_Data_RCH<=sig_in_en_mdpx;
		when b"010" =>
			-- load counter l
		when b"011" =>
			-- load counter h
		when b"100" =>
			-- load dacs
		when b"101" =>
			-- load ctpr
		when b"110" =>
			-- read dacs
			Out_En_RDAC<=sig_in_en_mdpx;
	      Out_Data_RDAC<=sig_in_en_mdpx;
		when b"111" =>
			-- read omr
			Out_En_ROMR<=sig_in_en_mdpx;
	      Out_Data_ROMR<=sig_in_en_mdpx;
		when others =>
			Out_En_RCL<='0';
			Out_Data_RCL<='0';
			Out_En_RCH<='0';
			Out_Data_RCH<='0';
			Out_En_RDAC<='0';
			Out_Data_RDAC<='0';
			Out_En_ROMR<='0';
			Out_Data_ROMR<='0';
	end case;

end if;

End process;

end Rx_Data_Medipix_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA
