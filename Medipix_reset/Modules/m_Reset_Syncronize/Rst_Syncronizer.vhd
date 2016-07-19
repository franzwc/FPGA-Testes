--! VHDL FILE
--  @file
--------------------------------------------------------------------------------
--  @brief Rst_Syncronizer
--------------------------------------------------------------------------------

-- Sincroniza os resets

-- Project Name: Rst_Syncronizer.v  

-- Tools: Quartus II 10.0 SP1

-- @name Rst_Syncronizer
-- @author Franz Wagner
-- @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
-- @date 2/12/2013
-- @version 1.0.0 (Dez/2013)

--------------------------------------------------------------------------------
-- VHDL FILE
--{{{ HEADER
--!@file
--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--use ieee.std_logic_arith.all;			-- Arithmetic functions X Not use whith numeric_std
--use ieee.std_logic_unsigned.all;		-- Std_logic unsigned functions;

--
-- Conversion
-- std => Integer  ->  int = to_integer( unsigned());                        
-- integer => Std  ->  std = std_logic_vector( to_unsigned (integer ,8));
-- integer => Unsigned -> to_unsigned(IntNumb, width);
-- UNSIGNED => STD_logic -> std_logic_vector(UnsignedNumb);
--------------------------------------------------------------------------------
--}}} Header

entity Rst_Syncronizer is

--{{{  >> PORTS
--------------------------------------------------------------------------------
port(

	In_Clk    				: in std_logic; 	--! Clock de recepcao dos dados
	In_nRst    				: in std_logic; 	--! Reset - Alto ativo
	In_Clk_Mdpx          : in std_logic;

	Out_clk_rst_mdpx     : out std_logic;
	Out_rst 					: out std_logic;	--! Reset de sa�da Alto ativo 
	Out_nrst 				: out std_logic	--! Reset de sa�da Baixo ativo 

);
--------------------------------------------------------------------------------
--}}} PORTS

end Rst_Syncronizer;
--! @brief Architure definition
architecture Rst_Syncronizer_arc of Rst_Syncronizer is

begin
Process_Rst_Syncronizer:
process (In_Clk, In_nRst)

--{{{  >> Variables
--------------------------------------------------------------------------------

variable v_ContaClkIn		: integer range 0 to 10000000 :=0;

--------------------------------------------------------------------------------
--}}} Variables

begin

---{{{ >>PROCESSING
--------------------------------------------------------------------------------
if (rising_edge(In_Clk)) then


	if (In_nRst = '0') THEN
		--Reset externo ou boucing
		-- Inicializa��o
		Out_rst			<='1';
		Out_nrst			<='0';
		v_ContaClkIn	:=0;	
		
	else
	--Sem reset externo
		if v_ContaClkIn <=9000000 then
			v_ContaClkIn:=v_ContaClkIn+1;

			if v_ContaClkIn <=5000000 then
			--Circuito em reset
				Out_rst<='1';
				Out_nrst<='0';
				Out_clk_rst_mdpx<=In_Clk_Mdpx;
			else 
			--Finalizou o processo de reset
				Out_rst<='0';
				Out_nrst<='1';
				Out_clk_rst_mdpx<=In_Clk_Mdpx;
			end if;
			
		else
			Out_clk_rst_mdpx<='0';
		end if;
		
end if;
end if;
--------------------------------------------------------------------------------
---}}} PROCESSING

End process;

end Rst_Syncronizer_arc;

