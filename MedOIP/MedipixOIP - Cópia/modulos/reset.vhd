Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--use ieee.std_logic_arith.all;			-- Arithmetic functions X Not use whith numeric_std
--use ieee.std_logic_unsigned.all;		-- Std_logic unsigned functions;
					 
entity reset is

port(
	-- Entradas
	i_Clk   				   : in std_logic;							--! Clock de 27 MHz
	
	-- Saídas
	o_reset					: out std_logic
	
);

end reset;

architecture reset_arc of reset is
--signal v_conta						: integer range 0 to 2;

begin
Process_Main:
process (i_Clk)

variable cont  				   	: natural;

begin

if rising_edge(i_Clk) then

	   cont:=cont+1;
		
		if cont<=10000 then--cont>=2048 and cont<=2050
				o_reset<='1';
		else
		      o_reset<='0';
		end if;
		
		if cont = 20000 then
		   cont :=0;
		end if;
		
end if;

--------------------------------------------------------------------------------
---}}} PROCESSING
End process;

end reset_arc;

