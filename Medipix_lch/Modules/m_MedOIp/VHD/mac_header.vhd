-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!/brief Recebe as Informacoes da Interface WEB pelo Nios e discrimina os dados 
--! do cabecalho ETH
--------------------------------------------------------------------------------
--! DESCRIPTION:
--!
--! mac_header
--!
--! DETAILS:      
--!
--!- Project Name:mac_header.vhdl                       
--!- Module Name: mac_header
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 22/04/2014     
--!- Version: 1.0.0 (Abr/2014) 
--------------------------------------------------------------------------------
--! LNLS - DET - 2014
--------------------------------------------------------------------------------
--}}} Header

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith

--0		  4				  8			 12			16		   20		 24		   28 		 		31		32
--|-------|---------------|-----------|----------|----------|---------|---------|----------------|--------|
--|MAC Destination						  |MAC Source	     			       |TYPE                               |
--|-------------------------------------------------------------------------------------------------------|
--|version|hdr            |Type Of Service (TOS) | TOTAL length                                           |
--|-------------------------------------------------------------------------------------------------------|
--|Identification			                         |	FLAGS		|Fragment                                     |
--|-------------------------------------------------------------------------------------------------------|
--|Time To Live (TTL)	  |Protocol	             | CheckSum (CS)			                                  |
--|-------------------------------------------------------------------------------------------------------|
--|Source Address 													                                                 |
--|-------------------------------------------------------------------------------------------------------|
--|Destination Address                                                                                    |
--|-------------------------------------------------------------------------------------------------------|
--|Options (Variable)							                                                				    |
--|-------------------------------------------------------------------------------------------------------|
--|										      Data														                      |
--|-------------------------------------------------------------------------------------------------------|		

											 
entity mac_header is
--{{{  >> GENERIC
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--}}} Generic

--{{{  >> PORTS
--------------------------------------------------------------------------------
port(
	--! Entradas
	i_Clk   				   : in std_logic;							--! Clock do Nios
	i_nRst    				: in std_logic;							--! Reset Baixo Ativo			
	
	i_MacDest				: in std_logic_vector(47 downto 0);	--! MAC de Destino
	i_Macsource				: in std_logic_vector(47 downto 0);	--! MAC de Origem
	i_IPDest				   : in std_logic_vector(31 downto 0);	--! IP de Destino
	i_IPSource				: in std_logic_vector(31 downto 0);	--! IP de Origem
	i_Protocol				: in std_logic_vector(7 downto 0);	--! Protocolo
	i_PortDest				: in std_logic_vector(15 downto 0);	--! Porta de Destino
	i_PortSource			: in std_logic_vector(15 downto 0);	--! Porta de Origem
	i_TTL					   : in std_logic_vector(7 downto 0);	--! Time to Live
	
	i_ts_PacketLength		: in integer range 0 to 2047;			--! Tamanho do Pacote de Informacao
	
	--! Saídas
	o_Data					: out std_logic_vector(7 downto 0);	--! Saida do Dado
	o_Add					   : out std_logic_vector(5 downto 0);	--! Endereco de gravacao na Memoria
	o_Valid					: out std_logic;							--! Valid do Dado
	o_HeaderReady			: out std_logic
	
);

end mac_header;
--------------------------------------------------------------------------------
--! @brief Architure Mack Header
architecture mac_header_arc of mac_header is
--!SIGNALS
--------------------------------------------------------------------------------

begin
Process_Main:
process (i_Clk, i_nRst)
--!Variables
--------------------------------------------------------------------------------
variable v_conta				   	: integer range 0 to 63;

variable v_MacDest					: std_logic_vector(47 downto 0);
variable v_Macsource				   : std_logic_vector(47 downto 0);
variable v_IPDest				   	: std_logic_vector(31 downto 0);
variable v_IPSource					: std_logic_vector(31 downto 0);
variable v_Protocol					: std_logic_vector(7 downto 0);
variable v_PortDest					: std_logic_vector(15 downto 0);
variable v_PortSource				: std_logic_vector(15 downto 0);
variable v_TTL					   	: std_logic_vector(7 downto 0);

variable v_MacDest_aux				: std_logic_vector(47 downto 0);
variable v_Macsource_aux			: std_logic_vector(47 downto 0);
variable v_IPDest_aux				: std_logic_vector(31 downto 0);
variable v_IPSource_aux				: std_logic_vector(31 downto 0);
variable v_PortDest_aux				: std_logic_vector(15 downto 0);
variable v_PortSource_aux			: std_logic_vector(15 downto 0);
variable v_ChangeParameters		: std_logic;
variable v_ChangeParameters_ctrl	: std_logic;

variable v_CheckSum					: std_logic_vector(15 downto 0);
variable v_CheckSum_aux				: integer range 0 to 1048575;
variable var_total_length        : natural range 0 to 1500;
variable var_total_length_aux    : natural range 0 to 1500;
variable v_total_length				: std_logic_vector(15 downto 0);
variable v_total_length_aux		: std_logic_vector(15 downto 0);
variable v_ttl_aux					: std_logic_vector(15 downto 0);
variable v_ipSource_1				: std_logic_vector(15 downto 0);
variable v_ipSource_2				: std_logic_vector(15 downto 0);
variable v_ipDest_1					: std_logic_vector(15 downto 0);
variable v_ipDest_2					: std_logic_vector(15 downto 0);
variable v_CheckSum_aux1			: integer range 0 to 1048575;
variable v_CheckSum_aux2			: integer range 0 to 1048575;
variable v_CheckSum_aux3			: std_logic_vector(19 downto 0);
variable v_CheckSum_aux4			: integer range 0 to 1048575;

variable v_aux						   : std_logic_vector(15 downto 0);
variable v_aux1						: std_logic_vector(15 downto 0);
variable v_aux2						: std_logic_vector(15 downto 0);

begin

--!RESET
--------------------------------------------------------------------------------
if (i_nRst = '0') THEN

--Reseting outputs
	o_Data 						<=(others=>'0');
	o_Add 						<=(others=>'0');
	o_Valid 					   <='0';
	o_HeaderReady 				<='0';
	
--Reseting variables
	v_conta 					   :=0;
	                    		
	v_MacDest					:=(others => '0');	
	v_Macsource					:=(others => '0');
	v_IPDest					   :=(others => '0');	
	v_IPSource					:=(others => '0');	
	v_Protocol					:=(others => '0');	
	v_PortDest					:=(others => '0');	
	v_PortSource				:=(others => '0');	
	v_TTL						   :=(others => '0');	
	                            
	v_CheckSum					:=(others => '0');
	v_CheckSum_aux		      :=0;
	v_total_length		      :=(others => '0');
	v_total_length_aux	   :=(others => '0');
	v_ttl_aux			      :=(others => '0');
	v_ipSource_1		      :=(others => '0');
	v_ipSource_2		      :=(others => '0');
	v_ipDest_1			      :=(others => '0');
	v_ipDest_2			      :=(others => '0');
	v_CheckSum_aux1	      :=0;
	v_CheckSum_aux2	      :=0;
	v_CheckSum_aux3	      :=(others => '0');
	v_CheckSum_aux4	      :=0;
	                           
	v_aux				         :=(others => '0');
	v_aux1				      :=(others => '0');
	v_aux2				      :=(others => '0');
--------------------------------------------------------------------------------		
---PROCESSING
--------------------------------------------------------------------------------
elsif rising_edge(i_Clk) then

	--valores são registrados uma vez para posteriores comparações para mudança de paramêtros
	if v_ChangeParameters_ctrl = '0' then
		v_MacDest_aux:=i_MacDest;		
		v_Macsource_aux:=i_Macsource;	
		v_IPDest_aux:=i_IPDest;			
		v_IPSource_aux:=i_IPSource;
		v_PortSource_aux:=i_PortDest;
		v_PortDest_aux:=i_PortSource;
			    
	   v_ChangeParameters_ctrl:='1';
	 end if;
	 
	 v_MacDest	    :=i_MacDest;
	 v_Macsource	 :=i_Macsource;
	 v_IPDest     	 :=i_IPDest;
	 v_IPSource	 	 :=i_IPSource;
	 v_Protocol   	 :=i_Protocol;
	 v_PortSource 	 :=i_PortDest;
	 v_PortDest  	 :=i_PortSource;
	 v_TTL		 	 :=i_TTL;
	 
	 --compara as entradas atuais com a registrada após o Rst para verificar se houve alterações
	 v_ChangeParameters := '0';
	 if v_MacDest_aux /= v_MacDest then
	 	v_MacDest_aux:=v_MacDest;
		v_ChangeParameters := '1';
	 end if;
	 
	 if v_Macsource_aux /= v_Macsource then
	   v_Macsource_aux:=v_Macsource;
	 	v_ChangeParameters := '1';
	 end if;
	 
	 if v_IPDest_aux /= v_IPDest then
	   v_IPDest_aux:=v_IPDest;
	 	v_ChangeParameters := '1';
	 end if;
	 
	 if v_IPSource_aux /= v_IPSource then
		v_IPSource_aux:=v_IPSource;
	 	v_ChangeParameters := '1';
	 end if;
	 
	 if v_PortSource_aux /= v_PortSource then
	 	v_PortSource_aux:=v_PortSource;
		v_ChangeParameters := '1';
	 end if;
	 
	 if v_PortDest_aux /= v_PortDest then
		v_PortDest_aux:=v_PortDest;
	 	v_ChangeParameters := '1';
	 end if;
	 
	 
	 if v_ChangeParameters = '1' then
		 v_conta:=0;
	 end if;
	 
	 v_ttl_aux := v_TTL & v_Protocol;
	 v_ipSource_1 := v_IPSource(31 downto 16);
	 v_ipSource_2 := v_IPSource(15 downto 0);
	 v_ipDest_1 := v_IPDest(31 downto 16);
	 v_ipDest_2 := v_IPDest(15 downto 0);

	 var_total_length:=i_ts_PacketLength+28;
	 v_total_length := std_logic_vector(to_unsigned(var_total_length,16));
	
	--cálculo do ChecSum
	--agrupa de 2 em 2 bytes o cabeçalho IP, o campo o checksum deve ser x"0000" 
	--soma todos os bytes
	--o resultante é um vetor de 20 posições...deve fazer a soma do as 4 mais significativas com o resto do vetor e depois fazer uma NOT com o resultado para obter o CheckSum
	v_aux := "0100010100001000";
	v_aux1 := "0000111001110001";
	v_aux2 := "0100000000000000";
	v_CheckSum_aux1 := to_integer(unsigned(v_aux))+to_integer(unsigned(v_aux1));
	v_CheckSum_aux2 := v_CheckSum_aux1+to_integer(unsigned(v_aux2));
	
	
	v_CheckSum_aux := v_CheckSum_aux2+to_integer(unsigned(v_total_length));
	v_CheckSum_aux := v_CheckSum_aux+to_integer(unsigned(v_ttl_aux));
	v_CheckSum_aux := v_CheckSum_aux+to_integer(unsigned(v_ipSource_1));
	v_CheckSum_aux := v_CheckSum_aux+to_integer(unsigned(v_ipSource_2));
	v_CheckSum_aux := v_CheckSum_aux+to_integer(unsigned(v_ipDest_1));
	v_CheckSum_aux := v_CheckSum_aux+to_integer(unsigned(v_ipDest_2));
	v_CheckSum_aux3 := std_logic_vector(to_unsigned(v_CheckSum_aux,20));
	
	
	v_CheckSum_aux4 := (to_integer(unsigned(v_CheckSum_aux3(19 downto 16)))+to_integer(unsigned(v_CheckSum_aux3(15 downto 0))));
	v_CheckSum := not(std_logic_vector(to_unsigned(v_CheckSum_aux4,16)));
	
	--tx mac destino
	if v_conta = 0 then 	
		o_Data <= v_MacDest(47 downto 40);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
		o_Valid <= '1';
	elsif v_conta = 1 then 	
		o_Data <= v_MacDest(39 downto 32);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 2 then 	
		o_Data <= v_MacDest(31 downto 24);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 3 then 	
		o_Data <= v_MacDest(23 downto 16);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 4 then 	
		o_Data <= v_MacDest(15 downto 8);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 5 then 	
		o_Data <= v_MacDest(7 downto 0);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	--tx mac source
	elsif v_conta = 6 then 	
		o_Data <= v_MacSource(47 downto 40);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 7 then 	
		o_Data <= v_MacSource(39 downto 32);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 8 then 	
		o_Data <= v_MacSource(31 downto 24);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 9 then 	
		o_Data <= v_MacSource(23 downto 16);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 10 then 	
		o_Data <= v_MacSource(15 downto 8);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 11 then 	
		o_Data <= v_MacSource(7 downto 0);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	--type
	elsif v_conta = 12 then 	
		o_Data <= x"08";
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 13 then 	
		o_Data <= x"00";
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	--IP Header
	--version
	elsif v_conta = 14 then 	
		o_Data <= x"45";
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 15 then 	
		o_Data <= x"08";
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	--total length D8(188B) or E8(204B) para 1 pkt
	elsif v_conta = 16 then 	
		--o_Data <= x"00";
		o_Data <= v_total_length(15 downto 8);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 17 then
		o_Data <= v_total_length(7 downto 0);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 18 then 	
		o_Data <= x"0e";
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 19 then 	
		o_Data <= x"71";
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));	
	elsif v_conta = 20 then 	
		o_Data <= x"40";
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));	
	elsif v_conta = 21 then 	
		o_Data <= x"00";
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));	
	--TTL
	elsif v_conta = 22 then 	
		o_Data <= v_TTL;
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	--Protocol
	elsif v_conta = 23 then 	
		o_Data <= v_Protocol;
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	--checksum
	elsif v_conta = 24 then 
		o_Data <= v_CheckSum(15 downto 8);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 25 then 	
		o_Data <= v_CheckSum(7 downto 0);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	--IP Source 
	elsif v_conta = 26 then 	
		o_Data <= v_IPSource(31 downto 24);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 27 then 	
		o_Data <= v_IPSource(23 downto 16);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 28 then 	
		o_Data <= v_IPSource(15 downto 8);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 29 then 	
		o_Data <= v_IPSource(7 downto 0);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	--IP Destino 
	elsif v_conta = 30 then 	
		o_Data <= v_IPDest(31 downto 24);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 31 then 	
		o_Data <= v_IPDest(23 downto 16);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 32 then 	
		o_Data <= v_IPDest(15 downto 8);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 33 then 	
		o_Data <= v_IPDest(7 downto 0);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	--udp header
	--Source Port 
	--Destination Port
	elsif v_conta = 34 then 	
		o_Data <= v_PortSource(15 downto 8);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 35 then 	
		o_Data <= v_PortSource(7 downto 0);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 36 then 	
		o_Data <= v_PortDest(15 downto 8);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 37 then 	
		o_Data <= v_PortDest(7 downto 0);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 38 then 
	   var_total_length_aux:=i_ts_PacketLength+8;
		v_total_length_aux := std_logic_vector(to_unsigned(var_total_length_aux,16));
		o_Data <= v_total_length_aux(15 downto 8);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 39 then 	
	--		if i_BtsComp = '1' then --Length
	--			o_Data <= x"c4"; --188B
	--		else
	--			o_Data <= x"d4"; --204B
	--		end if;
		
		o_Data <= v_total_length_aux(7 downto 0);
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	--checksum 0x00 none
	elsif v_conta = 40 then 	
		o_Data <= x"00";
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	elsif v_conta = 41 then 	
		o_Data <= x"00";
		o_Add  <= std_logic_vector(to_unsigned(v_conta,6));
	end if;
	
	if v_conta /= 42 then 
		v_conta := v_conta + 1;
		o_HeaderReady <= '0';
	else
		o_Valid <= '0';
		o_HeaderReady <= '1';
	end if;	

end if;

--------------------------------------------------------------------------------
---}}} PROCESSING
End process;

end mac_header_arc;

