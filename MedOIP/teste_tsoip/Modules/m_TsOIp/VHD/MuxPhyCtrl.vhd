-- VHDL FILE
--{{{ HEADER
--!@file
--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--use ieee.std_logic_arith.all;			-- Arithmetic functions X Not use whith numeric_std
--use ieee.std_logic_unsigned.all;		-- Std_logic unsigned functions;

entity MuxPhyCtrl is
--{{{  >> GENERIC

port(
	
	i_Ctrl					: in std_logic;				-- Quem controla o Phy: 1 Nios, 0 TX	
		
	inout_MDIO_Nios		: inout std_logic;
  
  	inout_MDIO_Tx	      : inout std_logic;

  	inout_MDIO	         : inout std_logic

);

end MuxPhyCtrl;
--------------------------------------------------------------------------------
--}}} PORTS

--! @brief Architure definition
architecture MuxPhyCtrl_arc of MuxPhyCtrl is
--{{{  >> SIGNALS
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--}}} SIGNALS
begin


inout_MDIO <= inout_MDIO_Tx when i_Ctrl='0' else inout_MDIO_Nios;


end MuxPhyCtrl_arc;

