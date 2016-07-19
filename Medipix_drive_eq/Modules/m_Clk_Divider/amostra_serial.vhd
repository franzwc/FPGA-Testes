-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief amostra serial
--------------------------------------------------------------------------------
--! DESCRIPTION:
--!
--! CtrlRdTxTsOIp
--!
--! DETAILS:      
--!
--!- Project Name: amostra_serial.vhdl                       
--!- Module Name: amostra_serial
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

entity amostra_serial is

--PORTS
--------------------------------------------------------------------------------
port(
	-- Entradas
	In_Clk  			  			 	: in std_logic;
	In_Rst    						: in std_logic;
	In_Serial  						: in std_logic;
	
	-- Saídas
	Out_Serial	   				: out std_logic;
	Out_Clk                    : out std_logic

);

end amostra_serial;
--! @brief Architure definition
architecture amostra_serial_arc of amostra_serial is
--SIGNALS
--------------------------------------------------------------------------------
signal sig_serial       		: std_logic:='0';
signal clk_up                 : std_logic:='0';
signal clk_down               : std_logic:='0';
--------------------------------------------------------------------------------

begin
Process_CtrlRdTxTsOIp:
process (In_Clk, In_Rst, clk_up, clk_down)
--Variables
--------------------------------------------------------------------------------

begin

Out_Clk<=(clk_up xor clk_down);

--RESET
--------------------------------------------------------------------------------
if (In_Rst = '1') THEN

	--Reseting outputs
	Out_Serial		<='0';
	sig_serial     <='0';
	clk_up			<='0';
	clk_down 		<='0';
--------------------------------------------------------------------------------		
--PROCESSING
--------------------------------------------------------------------------------
elsif (falling_edge(In_Clk)) then
	
	clk_down<=not(clk_down);
	
elsif (rising_edge(In_Clk)) then

	clk_up<=not(clk_up);
	Out_Serial<=sig_serial;
	sig_serial<=In_Serial;
	
end if;
--------------------------------------------------------------------------------
--PROCESSING
End process;

end amostra_serial_arc;

