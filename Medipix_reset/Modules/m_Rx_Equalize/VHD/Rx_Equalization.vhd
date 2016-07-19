--! VHDL FILE
--  @file
--------------------------------------------------------------------------------
--  @brief Rx Equalization
--------------------------------------------------------------------------------
--
-- Recebe eq
--
-- Project Name: Rx_Equalization.vhdl

-- Tools: Quartus II 10.0 SP1

-- @name Rx_Equalization
-- @author Franz Wagner
-- @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
-- @date 31/07/2014 
-- @version 1.0.0 (Jul/2014)
--
--------------------------------------------------------------------------------*/

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library altera;
use altera.altera_syn_attributes.all;

entity Rx_Equalization is
port (
		-- Entradas
		In_Clk  			  			 	: in std_logic;
		In_Rst    						: in std_logic;
		In_Eth_En  						: in std_logic;
      In_Eth_Data               	: in std_logic_vector(3 downto 0);
      -- Saidas
		Out_Cont                   : out integer range 0 to 1024;
		Out_Eth_Linux_En       		: out std_logic;
      Out_Eth_Linux_Data         : out std_logic_vector(3 downto 0); 
      Out_Eth_En            		: out std_logic;
      Out_Eth_Data	            : out std_logic_vector(3 downto 0);
		Out_Port_byte1  				: out std_logic_vector(3 downto 0);
		Out_Port_byte2  				: out std_logic_vector(3 downto 0);
		Out_Port_byte3  				: out std_logic_vector(3 downto 0);
		Out_Port_byte4  				: out std_logic_vector(3 downto 0)
);

end Rx_Equalization;

architecture Rx_Equalization_arq of Rx_Equalization is

-- CONSTANTES
constant DELAY	: natural	:= 100;
-- TIPOS
type Pipe_DELAYx4 is array (0 to DELAY-1) of std_logic_vector(4 downto 0);
-- SINAIS
signal sig_MacTx		: std_logic_vector(4 downto 0);
signal reg_MacTx		: Pipe_DELAYx4;
signal reg_MacTxEna	: std_logic;
signal reg_MacTxData	: std_logic_vector(3 downto 0);

begin
-- CONCURRENT STATEMENTS
-- Entrada do atrasador
sig_MacTx	<= (In_Eth_En&In_Eth_Data);

-- Saída do atrasador
reg_MacTxEna	<= reg_MacTx(DELAY-1)(4);
reg_MacTxData	<= reg_MacTx(DELAY-1)(3 downto 0);

TxClk:
process(In_Clk,In_Rst)

variable v_contador      : natural range 0 to 100 :=0;
variable v_conta_byte    : natural range 0 to 4095 :=0;
variable v_conta_pkt     : natural range 0 to 1023 :=0;
variable var_rem         : natural range 0 to 1 :=0;
variable var_en_fifo     : natural range 0 to 1 :=0;
variable reg_Port_byte1  : std_logic_vector(3 downto 0);
variable reg_Port_byte2  : std_logic_vector(3 downto 0);
variable reg_Port_byte3  : std_logic_vector(3 downto 0);
variable reg_Port_byte4  : std_logic_vector(3 downto 0);

begin
	if (In_Rst='1') then
		-- Saídas
		Out_Eth_En   		<= '0';
		Out_Eth_Data		<= (others=>'0');
		Out_Eth_Linux_En 	<= '0';
		Out_Eth_Linux_Data<= (others=>'0');
		-- Sinais
		reg_MacTx			<= (others=>(others=>'0'));
		v_contador     	:= 0;
		v_conta_byte   	:= 0;
		v_conta_pkt    	:= 0;
		var_rem				:= 0;
		var_en_fifo		   := 0;
		
	elsif (rising_edge(In_Clk)) then
		
		-- Linha de atrado do sinal de entrada
		reg_MacTx <= sig_MacTx&(reg_MacTx(0 to DELAY-2));
		Out_Cont <= v_conta_pkt;
		
		if((In_Eth_En='1')and(v_contador<=99))then
			v_contador := v_contador+1;
		elsif((In_Eth_En='1')and(v_contador>99))then

		else
			v_contador:=0;
		end if;
		
		if(reg_MacTxEna='1')then
			v_conta_byte := v_conta_byte+1;
		else
			v_conta_byte := 0;
		end if;
		
		if (v_contador=90) then
			reg_Port_byte1(3 downto 0)	:= In_Eth_Data(3 downto 0);
		elsif (v_contador=91) then
			reg_Port_byte2(3 downto 0)	:= In_Eth_Data(3 downto 0);
		elsif (v_contador=92) then
			reg_Port_byte3(3 downto 0)	:= In_Eth_Data(3 downto 0);
		elsif (v_contador=93) then
			reg_Port_byte4(3 downto 0)	:= In_Eth_Data(3 downto 0);
		end if;
		
		Out_Port_byte1<=reg_Port_byte1;
		Out_Port_byte2<=reg_Port_byte2;
		Out_Port_byte3<=reg_Port_byte3;
		Out_Port_byte4<=reg_Port_byte4;
		
		if (((reg_Port_byte2="0010")or(reg_Port_byte2="1000"))and((reg_Port_byte3="1000")or(reg_Port_byte3="1011")or(reg_Port_byte3="0010")))then--(reg_Port_byte1="0010")and(reg_Port_byte2="0010")and(reg_Port_byte3="1000")and(reg_Port_byte4="1011")
			if (v_conta_byte=1)then
				v_conta_pkt := v_conta_pkt+1;
			elsif(v_conta_pkt>769)then
				v_conta_pkt := 1;
			end if;
			
			if ((v_conta_byte>=102) and (v_conta_byte<=2149))then
	
				if(reg_MacTxData="1010")then
					Out_Eth_En <= '0';
					Out_Eth_Data <= (others=>'0');
					var_rem := 1;
				else
					if(var_rem=1)then
						var_rem := 0;
					else
						if(var_en_fifo=1)then
							Out_Eth_En <= '0';
							Out_Eth_Data <= reg_MacTxData(3 downto 0);
							var_en_fifo	:= 0;
							Out_Eth_Data <= (others=>'0');
						else
							Out_Eth_En <= reg_MacTxEna;
							Out_Eth_Data <= reg_MacTxData(3 downto 0);
							var_en_fifo	:= 1;
						end if;
					end if;
				end if;

			else
				Out_Eth_En <= '0';
				Out_Eth_Data <= (others=>'0');
			end if;
			Out_Eth_Linux_En <= '0';
			Out_Eth_Linux_Data <= (others=>'0');
		else
			Out_Eth_Linux_En <= reg_MacTxEna;
			Out_Eth_Linux_Data <= reg_MacTxData(3 downto 0);
			Out_Eth_En <= '0';
			Out_Eth_Data <= (others=>'0');
		end if;
		
	end if;
end process;

end Rx_Equalization_arq;
