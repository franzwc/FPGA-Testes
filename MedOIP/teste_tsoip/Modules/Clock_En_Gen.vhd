-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Gera Enable e Clock
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Gera Enable e Clock
--!
--! DETAILS:      
--!
--!- Project Name: Clock_En_Gen.vhd                       
--!- Module Name: Clock_En_Gen
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 21/2/2014     
--!- Version: 1.0.0 (Dez/2014) 
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
entity Clock_En_Gen is
--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------
port(
	-- Entradas
	In_Reset                    : in std_logic;
	In_Clk                      : in std_logic;
	In_M                        : in std_logic_vector(2 downto 0);
	In_Ready                    : in std_logic;
	
	-- Saidas
	Out_Clk_Medipix1            : out std_logic;
	Out_Clk_Medipix2            : out std_logic

);

end Clock_En_Gen;

architecture Clock_En_Gen_arc of Clock_En_Gen is
--------------------------------------------------------------------------------
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------
signal sig_Clk_Mdpx1           : std_logic :='0';
signal sig_Clk_Mdpx2  			 : std_logic :='0';

begin
process (In_Clk, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable conta_byte		       : natural := 0;
variable var_M                 : std_logic_vector(2 downto 0) :=(others=>'0');
variable var_En                : std_logic :='0';

begin
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_Clk_Medipix1    <='0';
	Out_Clk_Medipix2    <='0';
	
	sig_Clk_Mdpx1       <='0';
	sig_Clk_Mdpx2       <='0';
	
	var_En              :='0';
	var_M               :=(others=>'0');

--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------
elsif (falling_edge(In_Clk))then
   
	sig_Clk_Mdpx2<=not(sig_Clk_Mdpx2);
		
	if conta_byte >= 0 then
	if var_En='1' then
	   Out_Clk_Medipix2<=sig_Clk_Mdpx2;
   else
	   Out_Clk_Medipix2<='0';
	end if;
	end if;
	
elsif (rising_edge(In_Clk)) then
	
	if In_Ready='1' then
	conta_byte:=0;
	var_M:=In_M;
	end if;
	
	if conta_byte >= 0 then
	
	case var_M is
	when "000" =>
		if conta_byte<=98 then
		   var_En:='1';
			Out_Clk_Medipix1<=sig_Clk_Mdpx1;
	   else
		   var_En:='0';
			Out_Clk_Medipix1<='0';
		end if;
	when "001" =>
		-- Sequential Statement(s)
		if conta_byte<=98 then
		   var_En:='1';
			Out_Clk_Medipix1<=sig_Clk_Mdpx1;
	   else
		   var_En:='0';
			Out_Clk_Medipix1<='0';
		end if;
	when "010" =>
		-- Sequential Statement(s)
		if conta_byte<=98 then
		   var_En:='1';
			Out_Clk_Medipix1<=sig_Clk_Mdpx1;
	   else
		   var_En:='0';
			Out_Clk_Medipix1<='0';
		end if;
	when "011" =>
		-- Sequential Statement(s)
		if conta_byte<=98 then
		   var_En:='1';
			Out_Clk_Medipix1<=sig_Clk_Mdpx1;
	   else
		   var_En:='0';
			Out_Clk_Medipix1<='0';
		end if;
	when "100" =>
		-- Sequential Statement(s)
		if conta_byte<=98 then
		   var_En:='1';
			Out_Clk_Medipix1<=sig_Clk_Mdpx1;
	   else
		   var_En:='0';
			Out_Clk_Medipix1<='0';
		end if;
	when "101" =>
		-- Sequential Statement(s)
		if conta_byte<=98 then
		   var_En:='1';
			Out_Clk_Medipix1<=sig_Clk_Mdpx1;
	   else
		   var_En:='0';
			Out_Clk_Medipix1<='0';
		end if;
	when "110" =>
		-- Sequential Statement(s)
		if conta_byte<=98 then
		   var_En:='1';
			Out_Clk_Medipix1<=sig_Clk_Mdpx1;
	   else
		   var_En:='0';
			Out_Clk_Medipix1<='0';
		end if;
	when "111" =>
		if conta_byte>=0 and conta_byte<=120 then
		   var_En:='1';
			Out_Clk_Medipix1<=sig_Clk_Mdpx1;
	   else
		   var_En:='0';
			Out_Clk_Medipix1<='0';
		end if;
	when others =>
	   var_En:='0';
		Out_Clk_Medipix1<='0';
   end case;
   
	end if;
	
	sig_Clk_Mdpx1<=not(sig_Clk_Mdpx1);
	conta_byte:=conta_byte+1;
	
end if;
End process;
end Clock_En_Gen_arc;
