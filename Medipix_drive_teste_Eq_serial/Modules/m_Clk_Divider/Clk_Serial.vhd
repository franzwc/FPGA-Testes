-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Clk divider by 10
--------------------------------------------------------------------------------
--! DESCRIPTION:
--!
--! CtrlRdTxTsOIp
--!
--! DETAILS:      
--!
--!- Project Name:Clk_Serial.vhdl                       
--!- Module Name: Clk_Serial
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 22/04/2014     
--!- Version: 1.0.0 (Abr/2014) 
--------------------------------------------------------------------------------
--! LNLS - DET - 2014
--------------------------------------------------------------------------------
--}}} Header

-- Conversion
-- std => Integer  ->  int = to_integer( unsigned());                        
-- integer => Std  ->  std = std_logic_vector( to_unsigned (integer ,8));
-- integer => Unsigned -> to_unsigned(IntNumb, width);
-- UNSIGNED => STD_logic -> std_logic_vector(UnsignedNumb);
--------------------------------------------------------------------------------

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Clk_Serial is

--PORTS
--------------------------------------------------------------------------------
port(
	-- Entradas
	i_Clk   			  			 	: in std_logic;							--! Clock de 27 MHz
	i_nRst    						: in std_logic;							--! Reset Baixo Ativo
	
	-- Saídas
	o_Clk_Serial					: out std_logic   						-- saída de READ

);

end Clk_Serial;
--! @brief Architure definition
architecture Clk_Serial_arc of Clk_Serial is
--SIGNALS
--------------------------------------------------------------------------------
signal sig_Clk_serial   		: std_logic:='0';
--------------------------------------------------------------------------------

begin
Process_CtrlRdTxTsOIp:
process (i_Clk, i_nRst)
--Variables
--------------------------------------------------------------------------------
variable v_contador				: integer range 0 to 10;

begin

--RESET
--------------------------------------------------------------------------------
if (i_nRst = '0') THEN

	--Reseting outputs
	o_Clk_Serial		<='0';
	
	--Inicializa variaveis
	v_contador        :=0;
--------------------------------------------------------------------------------		
--PROCESSING
--------------------------------------------------------------------------------
elsif (rising_edge(i_Clk)) then


	if v_contador = 4 then
	   sig_Clk_serial<=not(sig_Clk_serial);
		v_contador:=0;
	else
	   v_contador:=v_contador+1;
	end if;
	
	o_Clk_Serial<=sig_Clk_serial;
	
end if;
--------------------------------------------------------------------------------
--PROCESSING
End process;

end Clk_Serial_arc;

