-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Read_Equalize_Fifo
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Read_Equalize_Fifo
--!
--! DETAILS:      
--!
--!- Project Name: Read_Equalize_Fifo.v                       
--!- Module Name: Read_Equalize_Fifo
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
				
entity Read_Equalize_Fifo is

--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------

port(
	
	-- Entradas Medipix
	In_Reset                    :   in std_logic;
	In_Clk                      :   in std_logic;
	In_Fifo_Use                 :   in std_logic_vector(16 downto 0);
	In_q                        :   in std_logic;
	
	Out_Fifo_Read_En            :   out std_logic;
	Out_Fifo_rst                :   out std_logic;
	
	Out_data                    :   out std_logic;
	Out_valid                   :   out std_logic;
	Out_sync                    :   out std_logic
		
);

end Read_Equalize_Fifo;

architecture Read_Equalize_Fifo_arc of Read_Equalize_Fifo is


begin

process (In_Clk, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------

variable v_StartRd           : std_logic;
variable v_Sync              : std_logic;
variable v_OValid            : std_logic;
variable v_OValid2           : std_logic;
variable v_EnableRd          : std_logic;
variable v_AddrPct			  : natural range 0 to 1048575 :=0;
variable conta_pkt           : natural range 0 to 9 :=0;

begin

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then

	-- Inicialização das saídas
	Out_Fifo_Read_En    <='0';
	Out_Fifo_rst		  <='0';
	
	Out_data            <='0';
	Out_valid           <='0';
	Out_sync            <='0';
	
	v_StartRd           :='0';
	v_Sync				  :='0';
	v_OValid				  :='0';
	v_OValid2           :='0';
	v_EnableRd  		  :='0';
	v_AddrPct           :=0;
	conta_pkt			  :=0;

--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------

elsif (rising_edge(In_Clk)) then

-------------------------------------------------
--inicia leitura se o nivel da fifo esta correto
-------------------------------------------------
   	if (v_StartRd='1') then
			v_AddrPct:=v_AddrPct+1;
			if (conta_pkt=1) then
			   --primeiro pacote pula 3 bits pre-sync
				if (v_AddrPct = 1) then
					Out_sync<='1';
				elsif (v_AddrPct = 117) then
					--lendo Dados/pcts
					v_EnableRd:='1';
				elsif (v_AddrPct = 119) then
					v_OValid:='1';
					v_OValid2:='1';
					v_Sync:='1';
				elsif (v_AddrPct = 98422) then
					v_EnableRd:='0';
				elsif (v_AddrPct = 98423) then
					--termino de leitura dos pacotes
					Out_valid<='0';
					v_StartRd:='0';
					v_AddrPct:=0;
					v_OValid:='0';
					conta_pkt:=conta_pkt+1;
				else
					Out_sync<='0';
					v_Sync:='0';
				end if;
			else
				--outros
				if (v_AddrPct = 1) then
					v_OValid:='1';
					v_OValid2:='1';
				elsif (v_AddrPct = 18) then
					--lendo Dados/pcts
					v_EnableRd:='1';
					v_Sync:='1';
				elsif (v_AddrPct = 98322) then
					v_EnableRd:='0';
				elsif (v_AddrPct = 98323) then
					--termino de leitura dos pacotes
					Out_valid<='0';
					v_StartRd:='0';
					v_AddrPct:=0;
					v_OValid:='0';
					conta_pkt:=conta_pkt+1;
				else
					null;
				end if;
			end if;  			
		end if;
-------------------------------------------------
--verifica estado da fifo para iniciar a leitura
-------------------------------------------------
	if v_StartRd='0' then
	   --verifica o uso da fifo e ve se pode ler
		if (to_integer(unsigned(In_Fifo_Use))=0) then
		   -- se a fifo ta vazia nao faz nada
		   conta_pkt:=0;
			v_StartRd:='0';
			Out_Fifo_rst<='0';
		else
		   -- se tem dado na fifo
			if(conta_pkt=0)then
				if((to_integer(unsigned(In_Fifo_Use)) > 100000)) then
				-- espera ter 130000 pacotes para comecar a leitura
					v_StartRd:='1';
					conta_pkt:=1;
				end if;
			elsif(conta_pkt>=2 and conta_pkt<=7)then
				if((to_integer(unsigned(In_Fifo_Use)) > 100000)) then
				-- espera ter 100000 pacotes para comecar a leitura
					v_StartRd:='1';
				end if;
			elsif(conta_pkt=8)then
				if((to_integer(unsigned(In_Fifo_Use)) > 97000)) then
				-- espera ter 100000 pacotes para comecar a leitura
					v_StartRd:='1';
				end if;
			elsif(conta_pkt=9)then
				Out_Fifo_rst<='1';
			else 
				v_StartRd:='1';
			end if;
		end if;
	end if;
---------------------------------------------------
-- externando sinais de comando
---------------------------------------------------
--! sinal de saida	
	if (v_OValid = '1' and v_Sync = '1') then
		Out_valid<='1';
		Out_data<=In_q;
	elsif(v_OValid = '0') then
		Out_data<='0';
	else
		Out_valid<=v_OValid2;
		v_OValid2:=v_OValid;
		Out_data<=In_q;
	end if;
-------------------------------------------
	Out_Fifo_Read_En<=v_EnableRd;

end if;

End process;

end Read_Equalize_Fifo_arc;

--------------------------------------------------------------------------------
--  >> TÉRMINO DO PROGRAMA