--------------------------------------------------------------------------------
-- File       : PhyInterface.vhd
-- Author     : Henry Douglas Rodrigues
-- Company    : Linear
--------------------------------------------------------------------------------
-- Description: Periférico do NiosII do tipo Avalon Memory-Mapped.
-- Implementa uma interface com o PHY.
--------------------------------------------------------------------------------
-- Revisions  :
-- Date        	Version	Author	Description
-- 2010-11-04	1.0     HDR     Created.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library altera;
use altera.altera_syn_attributes.all;

entity PhyInterface is															-- {{{
port (	
        
		-- Core
		in_Rst			: in std_logic;

      -- Phy MII TX
      in_TxClk		: in std_logic;
      out_PhyTxEna	: out std_logic;
      out_PhyTxData	: out std_logic_vector(3 downto 0);

      in_MacTxEna		: in std_logic;
      in_MacTxData	: in std_logic_vector(7 downto 0);
      in_MacTxStart	: in std_logic;
      in_MacTxEnd		: in std_logic

);
end PhyInterface;																-- }}}

architecture a of PhyInterface is
													-- }}}

-- CONSTANTES
constant DELAY	   : natural	:= 17;
-- TIPOS																		{{{
type StateTypeRx   is (S_WAITRX, S_IDLE, S_PREAMBLE, S_PAYLOAD);
type Pipe_DELAYx11 is array (0 to DELAY-1) of std_logic_vector(10 downto 0);
type StateTypeTx   is (S_IDLE, S_TESTE, S_PREAMBLE, S_PAYLOAD);
-- }}}
-- SINAIS																		{{{

-- MII interface RX
signal StateRx		   : StateTypeRx;
signal ShiftReg	   : std_logic_vector(7 downto 0);
signal CntNibble	   : std_logic;
signal PresCrc		   : std_logic_vector(31 downto 0);
signal NextCrc		   : std_logic_vector(31 downto 0);
-- MII interface TX
signal sig_MacTx		: std_logic_vector(10 downto 0);
signal reg_MacTx		: Pipe_DELAYx11;
signal StateTx			: StateTypeTx;
signal reg_MacTxEnd	: std_logic;
signal reg_MacTxEna	: std_logic;
signal reg_MacTxData	: std_logic_vector(7 downto 0);
signal reg2_MacTxEnd	: std_logic;
-- }}}

begin

-- CONCURRENT STATEMENTS														{{{
-- Entrada do atrasador
sig_MacTx	<= (in_MacTxStart&in_MacTxEnd&in_MacTxEna&in_MacTxData);

-- Saída do atrasador
reg_MacTxEnd	<= reg_MacTx(DELAY-1)(9);
reg_MacTxEna	<= reg_MacTx(DELAY-1)(8);
reg_MacTxData	<= reg_MacTx(DELAY-1)(7 downto 0);
-- }}}
													-- }}}

TxClk:
process(in_Rst,in_TxClk)														-- {{{
	variable var_CntAux		: natural range 0 to 31;
begin
	if (in_Rst='1') then														-- {{{
		-- Saídas
		out_PhyTxEna	<= '0';
		out_PhyTxData	<= (others=>'0');
		-- Sinais
		reg_MacTx		<= (others=>(others=>'0'));
		StateTx			<= S_IDLE;
		reg2_MacTxEnd	<= '0';
		-- Variáveis
		var_CntAux		:= 0;

		-- }}}
	elsif rising_edge(in_TxClk) then
	
	
		-- Linha de atrado do sinal de entrada
		reg_MacTx		<= sig_MacTx&(reg_MacTx(0 to DELAY-2));
		reg2_MacTxEnd	<= reg_MacTxEnd;
		
		case StateTx is															-- {{{
			when S_IDLE =>														-- {{{
				out_PhyTxEna	<= '0';
				out_PhyTxData	<= x"0";
				-- Início da transmissão de um frame							{{{
				if (in_MacTxStart='1') then
					StateTx		<= S_PREAMBLE;
					var_CntAux	:= 0;
				end if;															-- }}}

			when S_PREAMBLE =>													-- {{{
				out_PhyTxEna	<= '1';
				if (var_CntAux<15) then
					out_PhyTxData	<= x"5";
				elsif (var_CntAux=15) then
					out_PhyTxData	<= x"d";
				else
					out_PhyTxData	<= reg_MacTxData(3 downto 0);
					StateTx			<= S_PAYLOAD;
				end if;
				var_CntAux	:= var_CntAux+1;
			-- }}}
			when S_PAYLOAD =>													-- {{{
				out_PhyTxEna	<= '1';
				if (reg_MacTxEna='1') then
					out_PhyTxData	<= reg_MacTxData(3 downto 0);
				else
					out_PhyTxData	<= reg_MacTxData(7 downto 4);
				end if;
				if (reg2_MacTxEnd='1') then
					StateTx			<= S_IDLE;
					out_PhyTxEna	<= '0';
				end if;
			-- }}}
			when others =>	StateTx	<= S_IDLE;
		end case;																-- }}}
	end if;
end process;																	-- }}}

end a;
