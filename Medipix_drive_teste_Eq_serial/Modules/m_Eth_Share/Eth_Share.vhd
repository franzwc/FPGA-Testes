--! VHDL FILE
--  @file
--------------------------------------------------------------------------------
--  @brief Ethernet Transfer Share
--------------------------------------------------------------------------------
--
-- Compartilhamento de Ethernet
--
-- Project Name: Eth_Share.vhdl

-- Tools: Quartus II 10.0 SP1

-- @name Eth_Share
-- @author Franz Wagner
-- @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
-- @date 24/04/2014 
-- @version 1.0.0 (Abr/2014)
--
--------------------------------------------------------------------------------*/
--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--------------------------------------------------------------------------------


entity Eth_Share is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :  in std_logic;
	In_Clk                      :  in std_logic;
	
	In_Eth_Valid_Medpx          :  in std_logic;
	In_Eth_Data_Medpx           :  in std_logic_vector(3 downto 0);
	In_Eth_Valid_Linux          :  in std_logic;
	In_Eth_Data_Linux           :  in std_logic_vector(3 downto 0);
	
	Out_Eth_Valid               :  out std_logic;
	Out_Eth_Data                :  out std_logic_vector(3 downto 0)
		
);

end Eth_Share;

architecture Eth_Share_arc of Eth_Share is

signal sig_in_reg_eth_valid_mdpx    :  std_logic;
signal sig_in_reg_eth_data_mdpx     :  std_logic_vector(3 downto 0);
signal sig_in_reg_eth_valid_linux   :  std_logic;
signal sig_in_reg_eth_data_linux    :  std_logic_vector(3 downto 0);

begin

process (In_Clk, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable cont : natural;
begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) THEN

	-- Inicialização das saídas
	Out_Eth_Valid       				 <='0';
	Out_Eth_Data        				 <=(others=>'0');
	
   sig_in_reg_eth_valid_mdpx      <='0';
   sig_in_reg_eth_data_mdpx       <=(others=>'0');
   sig_in_reg_eth_valid_linux     <='0';
   sig_in_reg_eth_data_linux      <=(others=>'0');
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (rising_edge(In_Clk)) then
		
   sig_in_reg_eth_valid_mdpx<=In_Eth_Valid_Medpx;
   sig_in_reg_eth_data_mdpx<=In_Eth_Data_Medpx;
   sig_in_reg_eth_valid_linux<=In_Eth_Valid_Linux;
   sig_in_reg_eth_data_linux<=In_Eth_Data_Linux;
	
	if sig_in_reg_eth_valid_mdpx = '1' then
	   Out_Eth_Valid<=sig_in_reg_eth_valid_mdpx;
	   Out_Eth_Data<=sig_in_reg_eth_data_mdpx;
	else
	   Out_Eth_Valid<=sig_in_reg_eth_valid_linux;
	   Out_Eth_Data<=sig_in_reg_eth_data_linux;
	end if;
	
end if;

End process;

end Eth_Share_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA
