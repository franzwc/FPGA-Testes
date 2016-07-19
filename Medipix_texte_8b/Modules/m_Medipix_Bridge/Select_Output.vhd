-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Gera OMR
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Seleciona a saida pro medipic de acordo com M
--!
--! DETAILS:      
--!
--!- Project Name: Gera_OMR.v                       
--!- Module Name: Gera_OMR
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 17/2/2014     
--!- Version: 1.0.0 (Fev/2014) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2014
--------------------------------------------------------------------------------
--}}} Header*/

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
entity Select_Output is
--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------
port(
	-- Entradas Nios
	In_Clk                      : in std_logic;
	In_Reset                    : in std_logic;
	In_M                        : in std_logic_vector(2 downto 0);
	
	In_Clk_Mdpx_OMR        		 : in std_logic;
	In_Reset_Mdpx_OMR      		 : in std_logic;
	In_Data_Mdpx_OMR            : in std_logic;
	In_En_Mdpx_OMR              : in std_logic;
	
	In_Clk_Mdpx_LD        		 : in std_logic;
	In_Reset_Mdpx_LD      		 : in std_logic;
	In_Data_Mdpx_LD             : in std_logic;
	In_En_Mdpx_LD               : in std_logic;
	
	In_Clk_Mdpx_RD        		 : in std_logic;
	In_Reset_Mdpx_RD      		 : in std_logic;
	In_Data_Mdpx_RD             : in std_logic;
	In_En_Mdpx_RD               : in std_logic;
	
	In_Clk_Mdpx_LCTPR     		 : in std_logic;
	In_Reset_Mdpx_LCTPR   		 : in std_logic;
	In_Data_Mdpx_LCTPR          : in std_logic;
	In_En_Mdpx_LCTPR            : in std_logic;
	
	In_Clk_Mdpx_LCH     		    : in std_logic;
	In_Reset_Mdpx_LCH   	   	 : in std_logic;
	In_Data_Mdpx_LCH            : in std_logic;
	In_En_Mdpx_LCH              : in std_logic;
	
	In_Clk_Mdpx_RCH     		    : in std_logic;
	In_Reset_Mdpx_RCH   	   	 : in std_logic;
	In_Data_Mdpx_RCH            : in std_logic;
	In_En_Mdpx_RCH              : in std_logic;
	
	-- Saidas
	Out_Clk_Medipix             : out std_logic :='0';
	Out_Reset_Mdpx              : out std_logic :='0';
	Out_Data_Mdpx               :	out std_logic :='0';
	Out_En_Mdpx                 : out std_logic :='1'

);

end Select_Output;


architecture Select_Output_arc of Select_Output is
--------------------------------------------------------------------------------
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------

begin
process (In_Clk, In_Reset, In_M)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable var_M               : std_logic_vector(2 downto 0) :=(others=>'0');

begin

var_M:=In_M;
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_Clk_Medipix     <='0';
	Out_Reset_Mdpx      <='0';
	Out_Data_Mdpx       <='0';
	Out_En_Mdpx         <='0';
	
	var_M               :=(others=>'0');

elsif (rising_edge(In_Clk)) then
    
	 case var_M is
		 when b"000" =>
				Out_Clk_Medipix<=In_Clk_Mdpx_RCH;
				Out_Reset_Mdpx<=In_Reset_Mdpx_RCH;
				Out_Data_Mdpx<=In_Data_Mdpx_RCH;
				Out_En_Mdpx<=In_En_Mdpx_RCH;
		 when b"001" =>
		      Out_Clk_Medipix<=In_Clk_Mdpx_RCH;
				Out_Reset_Mdpx<=In_Reset_Mdpx_RCH;
				Out_Data_Mdpx<=In_Data_Mdpx_RCH;
				Out_En_Mdpx<=In_En_Mdpx_RCH;
		 when b"010" =>
		 -- Sequential Statement(s)
		 when b"011" =>
		      Out_Clk_Medipix<=In_Clk_Mdpx_LCH;
				Out_Reset_Mdpx<=In_Reset_Mdpx_LCH;
				Out_Data_Mdpx<=In_Data_Mdpx_LCH;
				Out_En_Mdpx<=In_En_Mdpx_LCH;
		 when b"100" =>
		      Out_Clk_Medipix<=In_Clk_Mdpx_LD;
				Out_Reset_Mdpx<=In_Reset_Mdpx_LD;
				Out_Data_Mdpx<=In_Data_Mdpx_LD;
				Out_En_Mdpx<=In_En_Mdpx_LD;
		 when b"101" =>
		      Out_Clk_Medipix<=In_Clk_Mdpx_LCTPR;
				Out_Reset_Mdpx<=In_Reset_Mdpx_LCTPR;
				Out_Data_Mdpx<=In_Data_Mdpx_LCTPR;
				Out_En_Mdpx<=In_En_Mdpx_LCTPR;
		 when b"110" =>
		      Out_Clk_Medipix<=In_Clk_Mdpx_RD;
				Out_Reset_Mdpx<=In_Reset_Mdpx_RD;
				Out_Data_Mdpx<=In_Data_Mdpx_RD;
				Out_En_Mdpx<=In_En_Mdpx_RD;
		 when b"111" =>
				Out_Clk_Medipix<=In_Clk_Mdpx_OMR;
				Out_Reset_Mdpx<=In_Reset_Mdpx_OMR;
				Out_Data_Mdpx<=In_Data_Mdpx_OMR;
				Out_En_Mdpx<=In_En_Mdpx_OMR;
		 when others =>
		 -- Sequential Statement(s)
	 end case;
	 
end if;
End process;
end Select_Output_arc;