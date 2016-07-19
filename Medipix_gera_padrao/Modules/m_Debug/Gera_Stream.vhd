-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Gera_stream
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Gera Stream de imagem para debug
--!
--! DETAILS:      
--!
--!- Project Name: Gera_Stream.v                       
--!- Module Name: Gera_Stream
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 11/07/2014     
--!- Version: 1.0.0 (Jul/2014) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2014
--------------------------------------------------------------------------------
--}}} Header*/

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--------------------------------------------------------------------------------
				
entity Gera_Stream is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :   in std_logic;
	In_Clk                      :   in std_logic;
	In_Start_Use                :   in std_logic;
	In_CountL                   :   in std_logic_vector(1 downto 0);
	
	Out_data                    :   out std_logic;
	Out_valid                   :   out std_logic
		
);

end Gera_Stream;

architecture Gera_Stream_arc of Gera_Stream is


begin

process (In_Clk, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable conta_byte		       : natural range 0 to 2097151 := 0;
variable CountL                : std_logic_vector(1 downto 0);

begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then

	-- Inicialização das saídas
	Out_data            <='0';
	Out_valid           <='1';
	
	conta_byte          :=0;
	CountL              :=(others=>'0');
	
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (rising_edge(In_Clk)) then

   CountL:=In_CountL;

	if In_Start_Use = '0' then
		conta_byte:=0;
		Out_data<='0';
		Out_valid<='1';
	else
	
		case (CountL) is
			when b"00" =>--2x1bit
			------------------------------------------------
			--envio de dados
			------------------------------------------------
				if conta_byte=0 then
					Out_data<='1';
					Out_valid<='0';
				elsif conta_byte=1 then
					Out_data<='0';
					Out_valid<='0';
				elsif conta_byte=2 then
					Out_data<='1';
					Out_valid<='0';
				elsif conta_byte>=3 and conta_byte<=15 then
					Out_data<='0';
					Out_valid<='0';	
				--comeca imagem
				elsif conta_byte=16 then
					Out_data<='1';
					Out_valid<='0';
				elsif conta_byte>=17 and conta_byte<=270 then-- conta_byte<=65550
					Out_data<='0';
					Out_valid<='0';
				elsif conta_byte=271 then
					Out_data<='1';
					Out_valid<='0';	
				elsif conta_byte>=272 and conta_byte<=65295 then--65550
					Out_data<='0';
					Out_valid<='0';
				elsif conta_byte=65296 then
					Out_data<='1';
					Out_valid<='0';
				elsif conta_byte>=65297 and conta_byte<=65550 then
					Out_data<='0';
					Out_valid<='0';	
				elsif conta_byte=65551 then
					Out_data<='1';
					Out_valid<='0';
				-------------------------------------------------
				elsif conta_byte>=65552 and conta_byte<=65566 then
					Out_data<='0';
					Out_valid<='0';
					
				elsif conta_byte=65567 then
					Out_data<='0';
					Out_valid<='1';
				end if;
				
				if (conta_byte <65671) then
					conta_byte:=conta_byte+1;
				else
					conta_byte:=666666;
				end if;
				
		when b"01" =>--2x12bit
		
		when b"10" =>--2x6bit
				if conta_byte=0 then
					Out_data<='1';
					Out_valid<='0';
				elsif conta_byte=1 then
					Out_data<='0';
					Out_valid<='0';
				elsif conta_byte=2 then
					Out_data<='1';
					Out_valid<='0';
				elsif conta_byte>=3 and conta_byte<=15 then
					Out_data<='0';
					Out_valid<='0';	
				--comeca imagem
				elsif conta_byte=16 then
					Out_data<='1';
					Out_valid<='0';
				elsif conta_byte>=17 and conta_byte<=270 then
					Out_data<='0';
					Out_valid<='0';
				elsif conta_byte=271 then
					Out_data<='1';
					Out_valid<='0';
				elsif conta_byte>=272 and conta_byte<=391695 then
					Out_data<='0';
					Out_valid<='0';
				elsif conta_byte=391696 then
					Out_data<='1';
					Out_valid<='0';	
				elsif conta_byte>=391697 and conta_byte<=391950 then
					Out_data<='0';
					Out_valid<='0';	
				elsif conta_byte=391951 then
					Out_data<='1';
					Out_valid<='0';
				elsif conta_byte>=391952 and conta_byte<=393230 then
					Out_data<='0';
					Out_valid<='0';	
				elsif conta_byte=393231 then
					Out_data<='1';
					Out_valid<='0';
				-------------------------------------------------
				elsif conta_byte>=393232 and conta_byte<=393247 then
					Out_data<='0';
					Out_valid<='0';
					
				elsif conta_byte=393248 then
					Out_data<='0';
					Out_valid<='1';
				end if;
				
				if (conta_byte <393250) then
					conta_byte:=conta_byte+1;
				else
					conta_byte:=666666;
				end if;
				
		when b"11" =>--1x24bit
		
		end case;
			
		
	end if;	
end if;

End process;

end Gera_Stream_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA