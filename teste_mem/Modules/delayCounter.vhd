-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief delayCounter
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! delayCounter
--!
--! DETAILS:      
--!
--!- Project Name: delayCounter.vhdl                       
--!- Module Name: delayCounter
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 2/12/2013     
--!- Version: 1.0.0 (Dez/2013) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2013
--------------------------------------------------------------------------------
--}}} Header*/
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delayCounter is port (
		reset : in std_logic;
		clock : in std_logic;
		resetAdc : out std_logic);
end entity;

architecture delayCounterInside of delayCounter is
	signal delayCounterInternalCount : integer; -- 32-bit counter
begin
	process(clock,reset)
	begin
		if reset = '0' then
			delayCounterInternalCount <= 0;
			resetAdc <= '0'; -- reset ADC is active low
		else
			if rising_edge(clock) then
				if delayCounterInternalCount >= 2000000 then
					resetAdc <= '1';
					delayCounterInternalCount <= 2000000; -- stop counter
				else
					resetAdc <= '0';
					delayCounterInternalCount <= delayCounterInternalCount + 1;
				end if;
			end if;
		end if;
	end process;
	
end delayCounterInside;
	