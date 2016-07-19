-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief registra contagem
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! registra contagem
--!
--! DETAILS:      
--!
--!- Project Name: registra contagem.vhdl                       
--!- Module Name: registra contagem
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


entity Registra_Contagem is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :   in std_logic;
	In_Clk                      :   in std_logic;
	
	In_Reg_Wen                  :   in std_logic;
	In_Reg_Data                 :   in std_logic_vector(7 downto 0);
	
	Out_Reg_Sync                :   out std_logic;
	Out_Reg_Data                :   out std_logic_vector(7 downto 0);
	Out_Reg_Wen                 :   out std_logic
		
);

end Registra_Contagem;

architecture Registra_Contagem_arc of Registra_Contagem is

signal sig_in_reg_data         :  std_logic_vector(7 downto 0);
signal sig_in_reg_wen          :  std_logic;
signal sig_in_reg_wen_ant      :  std_logic;

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
	Out_Reg_Sync        <='0';
	Out_Reg_Data        <=(others=>'0');
	Out_Reg_Wen         <='0';
	

--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (rising_edge(In_Clk)) then

	sig_in_reg_wen_ant<=In_Reg_Wen;
	sig_in_reg_data<=In_Reg_Data;

   if sig_in_reg_wen_ant ='0' then
	   cont:=0;
	else
	   if cont > 512 then
			cont:=0;
		else
			cont:=cont+1;
		end if;
	end if;

   if cont = 1 and sig_in_reg_wen_ant ='1' then
		Out_Reg_Data<=x"47";
		Out_Reg_Wen<='1';
		Out_Reg_Sync<='1';
	elsif cont>=2 and cont<=512 and sig_in_reg_wen_ant ='1' then
	   Out_Reg_Data<=sig_in_reg_data;
		Out_Reg_Wen<='1';
		Out_Reg_Sync<='0';
	elsif cont>=1 and sig_in_reg_wen_ant ='0' then
	   Out_Reg_Data<=x"00";
		Out_Reg_Wen<='0';
		Out_Reg_Sync<='0';
	else
	   Out_Reg_Data<=x"00";
		Out_Reg_Wen<='0';
		Out_Reg_Sync<='0';
	end if;
	
end if;

End process;

end Registra_Contagem_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA
