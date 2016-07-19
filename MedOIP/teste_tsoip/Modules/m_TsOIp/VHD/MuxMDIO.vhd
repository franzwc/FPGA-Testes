-- VHDL FILE
--{{{ HEADER
--!@file
--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--use ieee.std_logic_arith.all;			-- Arithmetic functions X Not use whith numeric_std
--use ieee.std_logic_unsigned.all;		-- Std_logic unsigned functions;

entity MuxMDIO is
--{{{  >> GENERIC
--------------------------------------------------------------------------------
--generic(
--g_PacketLengthAsiMode	: integer range 0 to 255:=204 	--! Tamanho do pacote (188/204)
--);
--------------------------------------------------------------------------------
--}}} Generic

--{{{  >> PORTS
--------------------------------------------------------------------------------
port(
	-- Entradas
	
	i_Ctrl				: in std_logic;				-- Quem controla o Phy: 1 Nios, 0 TX	
	
	in_MDIO_Nios		: in std_logic;
    
   in_MDIO_Tx		: in std_logic;
    
   inout_MDIO	: inout std_logic
     
);

end MuxMDIO;
--------------------------------------------------------------------------------
--}}} PORTS

--! @brief Architure definition
architecture MuxMDIO_arc of MuxMDIO is
--{{{  >> SIGNALS
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--}}} SIGNALS
begin


--From NIOS
--Saida
inout_MDIO <= in_MDIO_Nios when (i_Ctrl='1') else in_MDIO_Tx ;

end MuxMDIO_arc;

