-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief mux_crc
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! mux_crc
--!
--! DETAILS:      
--!
--!- Project Name:mux_crc.vhdl                       
--!- Module Name: mux_crc
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
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--use ieee.std_logic_arith.all;			-- Arithmetic functions X Not use whith numeric_std
--use ieee.std_logic_unsigned.all;		-- Std_logic unsigned functions;

entity mux_crc is

port(
	-- Entradas
	i_Clk    				: in std_logic;						   	--! Clock de 27 MHz
	i_nRst    				: in std_logic;							   --! Reset Baixo Ativo
	
	i_Data					: in std_logic_Vector(7 downto 0);	 	--! Numero de pacotes a serem lidos 1 a 7
	i_Sync					: in std_logic;			
	i_Valid					: in std_logic;							   --! Nivel de escrita na fifo	
	i_ValidCRC				: in std_logic;
	i_CRC		   			: in std_logic_vector(31 downto 0);	
		
	-- Saídas
	o_Data					: out std_logic_Vector(7 downto 0);
	o_Sync					: out std_logic;
	o_Valid					: out std_logic;
	o_End					   : out std_logic


);

end mux_crc;

architecture mux_crc_arc of mux_crc is

begin
Process_Main:

process (i_Clk, i_nRst)

variable v_start						   : std_logic;
variable v_ctrl							: integer range 0 to 3;
variable v_conta_crc				   	: integer range 0 to 7;
variable v_data							: std_logic_vector(7 downto 0);
variable v_data_aux						: std_logic_vector(7 downto 0);
variable v_sync							: std_logic;
variable v_sync_aux						: std_logic;
variable v_valid						   : std_logic;
variable v_valid_aux					   : std_logic;

begin

--RESET
--------------------------------------------------------------------------------
if (i_nRst = '0') THEN

--Reseting outputs
	o_Data 		<= (others=>'0');
	o_Valid 	<= '0';
	o_Sync		<= '0';
	o_End		<= '0';
--Reseting variables
	v_start		:= '0';
	v_ctrl		:= 0;
	v_conta_crc := 0;
--------------------------------------------------------------------------------		
--Reset
--PROCESSING
--------------------------------------------------------------------------------
elsif rising_edge(i_Clk) then
	
	--atrasa 2 pulsos de clock os dados de entrada para a saída
	o_Data <= v_data;
	v_data := v_data_aux;
	v_data_aux := i_Data;
	
	o_Sync <= v_sync;
	v_sync := v_sync_aux;
	v_sync_aux := i_Sync;
	
	o_Valid <= v_valid;
	v_valid := v_valid_aux;
	v_valid_aux := i_Valid;
	
	o_End		<= '0';
	if i_Sync = '1' and i_Valid = '1' then 
		--o_Sync		<= '1';
		v_start     := '1';
	end if;
	
	if v_start = '1' then 
--		o_Data <= i_Data;
--		o_Valid <= '1';
		
		if i_ValidCRC = '1' then 
			v_ctrl := 1;
		end if;
			
		
		--add CRC
		if v_ctrl = 3 then 
			if v_conta_crc = 0 then 
				o_Data <= "0000" & i_CRC(3 downto 0);
			elsif v_conta_crc = 1 then 
				o_Data <= "0000" & i_CRC(7 downto 4);
			elsif v_conta_crc = 2 then 
				o_Data <= "0000" & i_CRC(11 downto 8);
			elsif v_conta_crc = 3 then 
				o_Data <= "0000" & i_CRC(15 downto 12);
			elsif v_conta_crc = 4 then 
				o_Data <= "0000" & i_CRC(19 downto 16);
			elsif v_conta_crc = 5 then 
				o_Data <= "0000" & i_CRC(23 downto 20);
			elsif v_conta_crc = 6 then 
				o_Data <= "0000" & i_CRC(27 downto 24);
			elsif v_conta_crc = 7 then 
				o_Data <= "0000" & i_CRC(31 downto 28);
				o_End <= '1';
				v_start	:= '0';
				--o_Valid 	<= '0';
			end if;
			
			if v_conta_crc /= 7 then 
				v_conta_crc := v_conta_crc + 1;
			end if;
		end if;
		
		if v_ctrl = 2 then 
			v_ctrl := 3;
		end if;
		
		if v_ctrl = 1 and i_ValidCRC = '0' then 
			v_ctrl := 2;
		end if;
	
	else
		o_Data<=(others=>'0');
		o_Valid<='0';
		o_Sync<='0';
		o_End<='0';
		v_ctrl:=0;
		v_conta_crc:=0;
	end if;
	
end if;
--------------------------------------------------------------------------------
---}}} PROCESSING
End process;

end mux_crc_arc;

