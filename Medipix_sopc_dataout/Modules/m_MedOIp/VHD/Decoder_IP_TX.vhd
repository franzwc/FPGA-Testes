-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Decoder de parametros passados do Nios
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Decoder de parametros de transmissao
--!
--! DETAILS:      
--!
--!- Project Name: Decoder_IP_TX.vhd                       
--!- Module Name: Decoder_IP_TX
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
entity Decoder_IP_TX is
--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------
port(
	-- Entradas Nios
	In_Reset                    : in std_logic;
	In_Clk_nios                 : in std_logic;
	In_En_nios                  : in std_logic;
	In_Sync_nios                : in std_logic;
	In_Data_nios                :	in std_logic_vector(7 downto 0);
	
	-- Saidas
	Out_MAC                     : out std_logic_vector(47 downto 0) :=(others=>'0');
	Out_IP                      : out std_logic_vector(31 downto 0) :=(others=>'0');
	Out_PORT                    :	out std_logic_vector(15 downto 0) :=(others=>'0');
	Out_HOST_IP                 : out std_logic_vector(31 downto 0) :=(others=>'0');
	Out_HOST_MAC                : out std_logic_vector(47 downto 0) :=(others=>'0')

);

end Decoder_IP_TX;

architecture Decoder_IP_TX_arc of Decoder_IP_TX is
--------------------------------------------------------------------------------
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------
signal sig_valid               : std_logic;
signal sig_sinc   				 : std_logic;
signal sig_data   				 : std_logic_vector (7 downto 0);

signal sig_mac                 : std_logic_vector(47 downto 0);
signal sig_ip                  : std_logic_vector(31 downto 0);
signal sig_port                : std_logic_vector(15 downto 0);
signal sig_host_mac            : std_logic_vector(47 downto 0);
signal sig_host_ip             : std_logic_vector(31 downto 0);

begin
process (In_Clk_nios, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable conta_byte		       : natural range 0 to 128 :=0;
variable var_out_mac           : natural range 0 to 255;
variable var_out_ip            : natural range 0 to 255;
variable var_out_port          : natural range 0 to 65535;
variable var_host_mac          : natural range 0 to 255;
variable var_host_ip           : natural range 0 to 255;
variable var_tipo              : std_logic_vector(7 downto 0) :=(others=>'0');
variable var_tipo2             : std_logic_vector(7 downto 0) :=(others=>'0');

begin
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_MAC             <=(others=>'0');
	Out_IP              <=(others=>'0');
	Out_PORT            <=(others=>'0');
	
	sig_valid           <='0';
	sig_sinc            <='0';
	sig_data            <=(others=>'0');
	
	sig_mac             <=(others=>'0');
   sig_ip              <=(others=>'0');
   sig_port            <=(others=>'0');
	sig_host_mac        <=(others=>'0');
   sig_host_ip         <=(others=>'0');
	
	conta_byte          :=0;
	var_out_mac         :=0;
   var_out_ip          :=0;
   var_out_port        :=0;
   var_tipo            :=(others=>'0');
   var_tipo2           :=(others=>'0');
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------
elsif (rising_edge(In_Clk_nios)) then

   sig_valid<=In_En_nios;
	sig_sinc<=In_Sync_nios;
	sig_data<=In_Data_nios;
	
	if (sig_valid='1') then
		
		conta_byte:=conta_byte+1;

		if (sig_sinc='1' and sig_data=x"47") then
			conta_byte:=0;
		end if;

	   if conta_byte=4 then
			var_tipo:=sig_data(7 downto 0);
		elsif conta_byte=5 then
			var_tipo2:=sig_data(7 downto 0);
		end if;
		
		if (conta_byte>11 and (var_tipo=x"54" and var_tipo2=x"58")) then
		   -- IP de destino
			if conta_byte=12 then
				var_out_ip:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=13 then
				var_out_ip:=var_out_ip+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=14 then
				var_out_ip:=var_out_ip+to_integer(unsigned(sig_data(3 downto 0)));
				sig_ip(31 downto 24)<=std_logic_vector(to_unsigned(var_out_ip,8));
			elsif conta_byte=15 then
				var_out_ip:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=16 then
				var_out_ip:=var_out_ip+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=17 then
				var_out_ip:=var_out_ip+to_integer(unsigned(sig_data(3 downto 0)));
				sig_ip(23 downto 16)<=std_logic_vector(to_unsigned(var_out_ip,8));
			elsif conta_byte=18 then
				var_out_ip:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=19 then
				var_out_ip:=var_out_ip+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=20 then
				var_out_ip:=var_out_ip+to_integer(unsigned(sig_data(3 downto 0)));
				sig_ip(15 downto 8)<=std_logic_vector(to_unsigned(var_out_ip,8));
			elsif conta_byte=21 then
				var_out_ip:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=22 then
				var_out_ip:=var_out_ip+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=23 then
				var_out_ip:=var_out_ip+to_integer(unsigned(sig_data(3 downto 0)));
				sig_ip(7 downto 0)<=std_logic_vector(to_unsigned(var_out_ip,8));
			-- PORTA de destino
			elsif conta_byte=24 then
				var_out_port:= to_integer(unsigned(sig_data(3 downto 0)))*10000;
			elsif conta_byte=25 then
				var_out_port:=var_out_port+to_integer(unsigned(sig_data(3 downto 0)))*1000;
			elsif conta_byte=26 then
				var_out_port:=var_out_port+to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=27 then
				var_out_port:=var_out_port+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=28 then
				var_out_port:=var_out_port+to_integer(unsigned(sig_data(3 downto 0)));
				sig_port(15 downto 0)<=std_logic_vector(to_unsigned(var_out_port,16));
			-- MAC de destino
			elsif conta_byte=29 then
				var_out_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=30 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=31 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_mac(47 downto 40)<=std_logic_vector(to_unsigned(var_out_mac,8));
			elsif conta_byte=32 then
				var_out_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=33 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=34 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_mac(39 downto 32)<=std_logic_vector(to_unsigned(var_out_mac,8));
			elsif conta_byte=35 then
				var_out_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=36 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=37 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_mac(31 downto 24)<=std_logic_vector(to_unsigned(var_out_mac,8));
			elsif conta_byte=38 then
				var_out_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=39 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=40 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_mac(23 downto 16)<=std_logic_vector(to_unsigned(var_out_mac,8));
			elsif conta_byte=41 then
				var_out_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=42 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=43 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_mac(15 downto 8)<=std_logic_vector(to_unsigned(var_out_mac,8));
			elsif conta_byte=44 then
				var_out_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=45 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=46 then
				var_out_mac:=var_out_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_mac(7 downto 0)<=std_logic_vector(to_unsigned(var_out_mac,8));
				
				-- IP do Host
			elsif conta_byte=47 then
				var_host_ip:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=48 then
				var_host_ip:=var_host_ip+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=49 then
				var_host_ip:=var_host_ip+to_integer(unsigned(sig_data(3 downto 0)));
				sig_host_ip(31 downto 24)<=std_logic_vector(to_unsigned(var_host_ip,8));
			elsif conta_byte=50 then
				var_host_ip:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=51 then
				var_host_ip:=var_host_ip+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=52 then
				var_host_ip:=var_host_ip+to_integer(unsigned(sig_data(3 downto 0)));
				sig_host_ip(23 downto 16)<=std_logic_vector(to_unsigned(var_host_ip,8));
			elsif conta_byte=53 then
				var_host_ip:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=54 then
				var_host_ip:=var_host_ip+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=55 then
				var_host_ip:=var_host_ip+to_integer(unsigned(sig_data(3 downto 0)));
				sig_host_ip(15 downto 8)<=std_logic_vector(to_unsigned(var_host_ip,8));
			elsif conta_byte=56 then
				var_host_ip:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=57 then
				var_host_ip:=var_host_ip+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=58 then
				var_host_ip:=var_host_ip+to_integer(unsigned(sig_data(3 downto 0)));
				sig_host_ip(7 downto 0)<=std_logic_vector(to_unsigned(var_host_ip,8));
			-- MAC do Host
			elsif conta_byte=59 then
				var_host_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=60 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=61 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_host_mac(47 downto 40)<=std_logic_vector(to_unsigned(var_host_mac,8));
			elsif conta_byte=62 then
				var_host_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=63 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=64 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_host_mac(39 downto 32)<=std_logic_vector(to_unsigned(var_host_mac,8));
			elsif conta_byte=65 then
				var_host_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=66 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=67 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_host_mac(31 downto 24)<=std_logic_vector(to_unsigned(var_host_mac,8));
			elsif conta_byte=68 then
				var_host_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=69 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=70 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_host_mac(23 downto 16)<=std_logic_vector(to_unsigned(var_host_mac,8));
			elsif conta_byte=71 then
				var_host_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=72 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=73 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_host_mac(15 downto 8)<=std_logic_vector(to_unsigned(var_host_mac,8));
			elsif conta_byte=74 then
				var_host_mac:= to_integer(unsigned(sig_data(3 downto 0)))*100;
			elsif conta_byte=75 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)))*10;
			elsif conta_byte=76 then
				var_host_mac:=var_host_mac+to_integer(unsigned(sig_data(3 downto 0)));
				sig_host_mac(7 downto 0)<=std_logic_vector(to_unsigned(var_host_mac,8));
			--fim da leitura comea a mandar dados pro medipix
			elsif (conta_byte>=76) then
				Out_IP(31 downto 0)<=sig_ip(31 downto 0);
				
				Out_PORT(15 downto 0)<=sig_port(15 downto 0);
				
				Out_MAC(47 downto 0)<=sig_mac(47 downto 0);
				
				Out_HOST_IP(31 downto 0)<=sig_host_ip(31 downto 0);
				
				Out_HOST_MAC(47 downto 0)<=sig_host_mac(47 downto 0);
				
			else
				NULL;
			end if;
		end if;
	end if;
	
end if;
End process;
end Decoder_IP_TX_arc;
