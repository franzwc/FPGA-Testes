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
entity Gera_Shutter is
--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------
port(
	-- Entradas Nios
	In_Reset                    : in std_logic;
	In_Clk_Shutter              : in std_logic;
	In_Clk_Double               : in std_logic;
 
	In_Start_Shutter            : in std_logic;
	In_Time_Int                 : in natural range 0 to 100;
	In_Time_Fraq                : in natural range 0 to 999;
	
	-- Saidas
	Out_Shutter                 : out std_logic;
	Out_Clk_Shutter             : out std_logic

);

end Gera_Shutter;

architecture Gera_Shutter_arc of Gera_Shutter is
--------------------------------------------------------------------------------
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------
signal  sig_shutter            : std_logic :='0';

begin
process (In_Clk_Shutter, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable var_cont              : natural;
variable var_time_total        : natural;
variable var_start_shutter     : std_logic;
variable var_start_shutter_ant : std_logic;

begin
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_Shutter            <='1';
	
	var_cont               :=0;
	var_time_total         :=0;
	var_start_shutter      :='0';
	var_start_shutter_ant  :='0';
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------
elsif (rising_edge(In_Clk_Shutter)) then

		var_start_shutter_ant:=var_start_shutter;
		var_start_shutter:=In_Start_Shutter;
		var_time_total:=((In_Time_Int*10000000)+(In_Time_Fraq*10000));
		--Out_Shutter<=sig_shutter;
		
		if (var_start_shutter = '1' and var_start_shutter_ant = '0')then
			var_cont:=0;
		else
		   if var_cont<= var_time_total then
				var_cont:=var_cont+1;
			else
				var_cont:=1000000001;
			end if;
		end if;
		
		if (var_cont>=0 and var_cont<= var_time_total) then
			Out_Shutter<='0';
			sig_shutter<='0';
		else
			sig_shutter<='1';
			Out_Shutter<='1';
	   end if;
		
end if;
End process;


process (In_Clk_Double, In_Reset, sig_shutter)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------

begin
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_Clk_Shutter          <='0';
	
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------
elsif (falling_edge(In_Clk_Double)) then

		if sig_shutter='0' then
			Out_Clk_Shutter<=In_Clk_Shutter;
		else
			Out_Clk_Shutter<='0';
		end if;		
		
end if;
End process;

end Gera_Shutter_arc;
