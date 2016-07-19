-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Read_Input_Fifo
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Read_Input_Fifo
--!
--! DETAILS:      
--!
--!- Project Name: Read_Input_Fifo.v                       
--!- Module Name: Read_Input_Fifo
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 2/12/2013     
--!- Version: 1.0.0 (Dez/2013) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2013
--------------------------------------------------------------------------------
--}}} Header*/

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--------------------------------------------------------------------------------
				
entity Read_Input_Fifo is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :   in std_logic;
	In_Clk                      :   in std_logic;
	In_Fifo_Use                 :   in std_logic_vector(15 downto 0);
	In_Fifo_Full                :   in std_logic;
	In_Packet_Length            :   in natural range 0 to 2047;
	In_q                        :   in std_logic;
	
	Out_Fifo_Read_En            :   out std_logic;
	Out_Fifo_rst                :   out std_logic;
	
	Out_data                    :   out std_logic_vector(7 downto 0);
	Out_valid                   :   out std_logic;
	Out_sync                    :   out std_logic
		
);

end Read_Input_Fifo;

architecture Read_Input_Fifo_arc of Read_Input_Fifo is


begin

process (In_Clk, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------

variable v_StartRd           : std_logic;
variable v_Standby           : integer range 0 to 100;
variable v_Sync              : std_logic;
variable v_OValid            : std_logic;
variable v_EnableRd          : std_logic;
variable v_AddrPct			  : integer range 0 to 1428;
variable conta_pkt           : natural range 0 to 1024;
variable conta_saida         : natural range 0 to 64;

begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) THEN

	-- Inicialização das saídas
	Out_Fifo_Read_En    <='0';
	Out_Fifo_rst		  <='0';
	
	Out_data            <=(others=>'0');
	Out_valid           <='0';
	Out_sync            <='0';
	
	v_Standby           :=0;
	v_StartRd           :='0';
	v_Sync				  :='0';
	v_OValid				  :='0';
	v_EnableRd  		  :='0';
	v_AddrPct           :=0;
	conta_pkt			  :=0;
	conta_saida			  :=0;

--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (rising_edge(In_Clk)) then

-------------------------------------------------
--inicia leitura se o nivel da fifo esta correto
-------------------------------------------------
   	if v_StartRd='1' then
			--lendo Dados/pcts
			v_EnableRd:='1';
			v_AddrPct:=v_AddrPct+1;
			if conta_pkt=1 then
			   --primeiro pacote pula 80 pulsos do omr + 16 bits pre-sync
				if v_AddrPct = 16 then--15
					v_OValid:='1';
					v_Sync:='1';
				else
					v_Sync:='0';
				end if;
				if v_AddrPct=(In_Packet_Length)+20 then--19
					--termino de leitura dos pacotes
					Out_valid<='0';
					v_StartRd:='0';
					v_AddrPct:=0;
					v_Standby:=1;
					v_OValid:='0';
					v_EnableRd:='0';
				end if;
			else
				--outros pacotes
				if v_AddrPct = 1 then
					v_OValid:='1';
					v_Sync:='1';
				else
					v_Sync:='0';
				end if;
				if v_AddrPct=(In_Packet_Length)+5 then
					--termino de leitura dos pacotes
					Out_valid<='0';
					v_StartRd:='0';
					v_AddrPct:=0;
					v_Standby:=1;
					v_OValid:='0';
					v_EnableRd:='0';
				end if;			
			end if;
		end if;
-------------------------------------------------
--verifica estado da fifo para iniciar a leitura
-------------------------------------------------
	if v_StartRd='0' and v_Standby =0 then
	   --verifica o uso da fifo e ve se pode ler
		if (to_integer(unsigned(In_Fifo_Use))=0) then
		   -- se a fifo ta vazia nao faz nada
		   conta_pkt:=0;
			v_StartRd:='0';
			conta_saida:=0;
		else
		   -- se tem dado na fifo
	      if (conta_pkt>=1) then
				v_StartRd:='1';
				conta_pkt:=conta_pkt+1;
			end if;
			if((to_integer(unsigned(In_Fifo_Use)) > 256) and conta_pkt=0) then
				-- espera ter 256 pacotes para comecar a leitura
				v_StartRd:='1';
				conta_pkt:=1;
				conta_saida:=0;
			end if;
		end if;
	end if;
---------------------------------------------------
-- intervalo entre um pacote e outro
---------------------------------------------------
	if v_Standby>0 and v_Standby<60 then
		v_Standby:=v_Standby+1;
	else
		v_Standby:=0;
	end if;
---------------------------------------------------
--se a fifo estoura reseta
---------------------------------------------------
	if In_Fifo_Full ='1' then
	   Out_Fifo_rst<='1';
	else
	   Out_Fifo_rst<='0';
	end if;
---------------------------------------------------
-- externando sinais de comando
---------------------------------------------------
--! sinal de saida	
	if (v_OValid = '1' and v_Sync = '1') then
	
		Out_valid<='1';
		Out_sync<='1';
		Out_data<=x"47";
		conta_saida:=1;
	else
	   if (conta_saida=1) then
			Out_valid<='1';
			Out_sync<='0';
			Out_data<=x"1f";
			conta_saida:=2;
		elsif (conta_saida=2) then
			Out_valid<='1';
			Out_sync<='0';
			Out_data<=x"ff";
			conta_saida:=3;	
		elsif (conta_saida=3) then
			Out_valid<='1';
			Out_sync<='0';
			Out_data<=std_logic_vector(to_unsigned(conta_pkt,8));
			conta_saida:=4;
		elsif (conta_saida>=4) then
			conta_saida:=5;
			Out_sync<=v_Sync;
			Out_data(0)<=In_q;
			Out_data(1)<='0';
			Out_data(2)<='0';
			Out_data(3)<='0';
			Out_data(4)<='0';
			Out_data(5)<='0';
			Out_data(6)<='0';
			Out_data(7)<='0';
		end if;
	end if;
-------------------------------------------
   if (conta_pkt=1) then
		Out_Fifo_Read_En<=v_EnableRd;
	else
	   if (conta_saida>=5) then
			Out_Fifo_Read_En<=v_EnableRd;
		else
			null;
		end if;
	end if;

end if;

End process;

end Read_Input_Fifo_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA