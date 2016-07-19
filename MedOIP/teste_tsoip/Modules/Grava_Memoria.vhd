-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief grava memoria
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! grava memoria
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


entity Grava_Memoria is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :   in std_logic;
	In_Clk                      :   in std_logic;
	In_send                     :   in std_logic;
	
	Out_Data                    :   out std_logic_vector(7 downto 0);
	Out_Addr                    :   out std_logic_vector(9 downto 0);
	Out_Wen                     :   out std_logic;
	Out_rdaddr                  :   out std_logic_vector(9 downto 0)
		
);

end Grava_Memoria;

architecture Grava_Memoria_arc of Grava_Memoria is

signal sig_in_send_atual       :  std_logic;
signal sig_in_send_anterior    :  std_logic;

begin

process (In_Clk, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------

variable contador		     : natural :=0;
variable cont  		     : natural :=0;

begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) THEN

	-- Inicialização das saídas
	Out_Data            <=(others=>'0');
	Out_Addr            <=(others=>'0');
	Out_Wen             <='0';
	
	contador            :=0;

--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (rising_edge(In_Clk)) then

   sig_in_send_anterior<=sig_in_send_atual;
	sig_in_send_atual<=In_send;

   if (sig_in_send_anterior='0' and sig_in_send_atual='1') then
	   contador:=0;
		cont:=0;
	end if;
	if (sig_in_send_anterior='1' and sig_in_send_atual='1') then
	   contador:=contador+1;
		if (contador>=0 and contador<=50) then
	   Out_Addr<=std_logic_vector( to_unsigned(contador,10));
		if contador <=4 then
		Out_Data<=b"01011010";
		elsif contador>=5 then
		Out_Data<=b"10100101";
		end if;
		Out_Wen<='1';
	   else
	   Out_Data<=(others=>'0');
		Out_Addr<=(others=>'0');
	   Out_Wen<='0';
		end if;
	end if;
	
	if contador=49 then
	   cont:=0;
	else
	   cont:=cont+1;
	end if;
	
	Out_rdaddr<=std_logic_vector( to_unsigned(cont,10));

end if;

End process;

end Grava_Memoria_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA
