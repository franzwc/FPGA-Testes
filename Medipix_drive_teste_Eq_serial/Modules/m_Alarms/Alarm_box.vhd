--! VHDL FILE
--  @file
--------------------------------------------------------------------------------
--  @brief Alarm box
--------------------------------------------------------------------------------
--
-- Alarm box . sinaliza a ocupaao do sistema
--
-- Project Name: Alarm_box.vhdl
--
-- Tools: Quartus II 10.0 SP1
--
-- @name Alarm Box
-- @author Franz Wagner
-- @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
-- @date 07/07/2014
-- @version 1.0.0 (Jul/2014)
--
--------------------------------------------------------------------------------*/
--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--------------------------------------------------------------------------------
				
entity Alarm_box is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :   in std_logic;
	In_Clk                      :   in std_logic;
	In_M                        :   in std_logic_vector(2 downto 0);
	In_Fifo_Use_Pkt             :   in std_logic_vector(15 downto 0);
	In_Fifo_Use_Eth             :   in std_logic_vector(11 downto 0);
	
	Out_Chip_Busy               :   out std_logic
		
);

end Alarm_box;

architecture Alarm_box_arc of Alarm_box is


begin

process (In_Clk, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------

variable v_Shutter_on        : std_logic;
variable v_Chip_read_on      : std_logic;
variable v_Eth_send_on       : std_logic;
variable v_OBusy             : std_logic;
variable v_M                 : std_logic_vector(2 downto 0);

begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then

	-- Inicialização das saídas
	Out_Chip_Busy       <='0';
	
	v_Chip_read_on      :='0';
	v_Eth_send_on		  :='0';
	v_OBusy				  :='0';
	v_M                 :="000";

--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (rising_edge(In_Clk)) then

-------------------------------------------------
--inicia leitura se o nivel da fifo esta correto
-------------------------------------------------
   	v_M:=In_M;
		
		if (v_M="000" or v_M="001") then
			--monitora fifo rec
			if (to_integer(unsigned(In_Fifo_Use_Pkt)) > 0) then
				v_Chip_read_on:='1';
			else
				v_Chip_read_on:='0';
			end if;
			--monitora fifo eth
			if (to_integer(unsigned(In_Fifo_Use_Eth)) > 0) then
				v_Eth_send_on:='1';
			else
				v_Eth_send_on:='0';
			end if;
		else
			v_OBusy:='0';
		end if;
		
		if (v_Chip_read_on='1' or v_Eth_send_on='1') then
			v_OBusy:='1';
		else 
			v_OBusy:='0';
		end if;
		
		Out_Chip_Busy<=v_OBusy;
		
end if;

End process;

end Alarm_box_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA