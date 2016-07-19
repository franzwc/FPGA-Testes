-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Phy Interface
--------------------------------------------------------------------------------
--! DESCRIPTION:
--!
--! Phy Interface
--!
--! DETAILS:      
--!
--!- Project Name:PhyInterface.vhdl                       
--!- Module Name: PhyInterface
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 22/04/2014     
--!- Version: 1.0.0 (Abr/2014) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2014
--------------------------------------------------------------------------------
--}}} Header

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity teste_crc is

port(
	-- Entradas
	i_Clk   		   		: in std_logic;							--! Clock de 27 MHz
	i_nRst    				: in std_logic;							--! Reset Baixo Ativo
	
	i_Sync					: in std_logic;			
	i_Valid					: in std_logic;							--! Nivel de escrita na fifo
	i_Data					: in std_logic_Vector(3 downto 0);	 	--! Numero de pacotes a serem lidos 1 a 7
	i_ValidCRC				: in std_logic;	
	
	-- Saídas
	o_Data					: out std_logic_Vector(7 downto 0);
	o_Clr				   	: out std_logic;
	o_Valid					: out std_logic


);

end teste_crc;

architecture teste_crc_arc of teste_crc is
--SIGNALS

begin
Process_Main:
process (i_Clk, i_nRst)
--{{{  >> Variables
variable v_data_aux		: std_logic_vector(3 downto 0);
variable v_conta		   : integer range 0 to 2;
variable v_start			: std_logic;
variable v_ctrl			: std_logic;
--}}} Variables
begin

--RESET
--------------------------------------------------------------------------------
if (i_nRst = '0') THEN

--Reseting outputs
	o_Data<=(others=>'0');
	o_Clr<='0';
	o_Valid<='0';
	
	v_conta:=0;
	v_ctrl:='0';
--------------------------------------------------------------------------------
elsif rising_edge(i_Clk) then
	
	o_Clr <= '0';
	o_Valid <= '0';
	if i_Sync = '1' and i_Valid = '1' then 
		if i_ValidCRC = '1' then
			v_conta:=1;
			v_start:='1';
			v_ctrl:='0';
		else
			v_conta:=0;
			v_start:='0';
		end if;
	end if;
	
	if v_start = '1' then
		case v_conta is
			when 1 =>
							if v_ctrl='0' then
								o_Clr<='1';
								v_ctrl:='1';
							end if;
							v_data_aux:=i_Data;
			when 2 =>
							o_Data<= i_Data & v_data_aux;
							o_Valid<='1';
			when others =>
							null;
		end case;
		
		if v_conta = 1 then 
			v_conta:=2;
		elsif v_conta = 2 then 
			v_conta:=1;
		end if;
	else
		o_Valid<='0';
	end if;
	
	if i_ValidCRC = '0' then
		v_conta:=0;
		v_start:='0';
		v_ctrl:='0';
	end if;
	
end if;
--------------------------------------------------------------------------------
---PROCESSING
End process;

end teste_crc_arc;

