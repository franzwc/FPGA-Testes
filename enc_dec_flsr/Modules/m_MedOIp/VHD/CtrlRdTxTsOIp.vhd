-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief CtrlRdTxTsOIp
--------------------------------------------------------------------------------
--! DESCRIPTION:
--!
--! CtrlRdTxTsOIp
--!
--! DETAILS:      
--!
--!- Project Name:CtrlRdTxTsOIp.vhdl                       
--!- Module Name: CtrlRdTxTsOIp
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 22/04/2014     
--!- Version: 1.0.0 (Abr/2014) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2014
--------------------------------------------------------------------------------
--}}} Header

-- Conversion
-- std => Integer  ->  int = to_integer( unsigned());                        
-- integer => Std  ->  std = std_logic_vector( to_unsigned (integer ,8));
-- integer => Unsigned -> to_unsigned(IntNumb, width);
-- UNSIGNED => STD_logic -> std_logic_vector(UnsignedNumb);
--------------------------------------------------------------------------------

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity CtrlRdTxTsOIp is

--PORTS
--------------------------------------------------------------------------------
port(
	-- Entradas
	i_Clk   			   	: in std_logic;							--! Clock de 27 MHz
	i_nRst    				: in std_logic;							--! Reset Baixo Ativo
	i_NivelRdFifo			: in std_logic_vector(10 downto 0);	--! Nivel de escrita na fifo
	
	i_BytespPact			: in integer range 0 to 1400;	 		--! Numero bytes por pacotes 
	i_Fifo_Full				: in std_logic;							--!Sinaliza estado da Fifo:'1'= Vazia, '0' caso contrario
	HeaderEthLength 		: in integer range 0 to 255;	 		--! Numero de bytes do cabeçalho Ethernet
	
	-- Saídas
	o_EnableRdPact			: out std_logic;						-- saída de READ
	o_EnableRdHdEth		: out std_logic;						-- saída de READ
	o_ValidOut				: out std_logic;						-- Enable de saída de dados
	o_Sync					: out std_logic;						-- Enable de saída de dados
	o_End					   : out std_logic;						-- Enable de saída de dados
	
	o_AddrHeader			: out integer range 0 to 1428;
	o_Fifo_Rst           : out std_logic

);

end CtrlRdTxTsOIp;
--! @brief Architure definition
architecture CtrlRdTxTsOIp_arc of CtrlRdTxTsOIp is
--SIGNALS
--------------------------------------------------------------------------------
signal sig_sync_out			: std_logic;
signal sig_OValid			   : std_logic;
signal sig_sync_out2			: std_logic;
signal sig_OValid2			: std_logic;
--------------------------------------------------------------------------------

begin
Process_CtrlRdTxTsOIp:
process (i_Clk, i_nRst)
--Variables
--------------------------------------------------------------------------------
variable v_NumBytes				: integer range 0 to 1428;
variable v_EnableRd				: std_logic;
variable v_StartRd				: std_logic;
variable v_EnableRdHeader		: std_logic;
variable v_OValid					: std_logic;
variable v_End					   : std_logic;
variable v_Standby            : integer range 0 to 30;

--Inicializa variaveis
variable v_AddrPct			   : integer range 0 to 1428;
variable v_AddrHeader 		   : integer range 0 to 1428;
variable v_LerPctbyte		   : std_logic;
variable v_LerHeaderbyte	   : std_logic;
variable v_Enablefase1		   : std_logic;
variable v_Enablefase0		   : std_logic;

begin

--RESET
--------------------------------------------------------------------------------
if (i_nRst = '0') THEN

--Reseting outputs
	o_EnableRdPact		<= '0';
	o_ValidOut			<= '0';	
	o_AddrHeader		<= 0;
--Reseting Signals and variables
	v_NumBytes			:=0;
	v_EnableRd			:= '0';
	o_Sync				<= '0';
	sig_sync_out		<= '0';
 
	o_EnableRdHdEth 	<= '0';
	v_StartRd			:= '0';

	v_EnableRdHeader 	:='0';

	v_OValid			   :='0';
	sig_OValid 			<='0';
	sig_OValid2 		<='0';
	o_End 				<='0'; 
	v_End             :='0';
	v_Standby         :=0;
	o_AddrHeader      <=0;
	
	
	--Inicializa variaveis
	v_AddrPct         :=0;
	v_AddrHeader      := 0;
	v_LerPctbyte      :='1';
	v_LerHeaderbyte   :='1';
	v_Enablefase1     :='0';	
	v_Enablefase0     :='1';	
--------------------------------------------------------------------------------		
--PROCESSING
--------------------------------------------------------------------------------
elsif (rising_edge(i_Clk)) then


	if i_Fifo_Full = '1' then
	   o_Fifo_Rst<='1';
	else
	   o_Fifo_Rst<='0';
	end if;
	
	o_End<=v_End;
	v_End:='0';		
		
	if v_StartRd='0' then
		v_OValid:='0';
	--desabilitada a leitura
		v_EnableRd:='0';	
		sig_sync_out<='0';
		v_EnableRdHeader:='0';
	end if;
	
	
	if v_StartRd='1' and v_Enablefase0='1' then
	--lendo cabeçalho eternet
		v_OValid:='1';
		sig_sync_out<='0';
		v_EnableRdHeader:='1';
		if v_LerHeaderbyte='1' then 
		--le um byte a cada 2 pulsos de clk
			o_AddrHeader<=v_AddrHeader;
			v_LerHeaderbyte:='0';
			if v_AddrHeader=0 then
				sig_sync_out<='1';
			end if;
		else
			v_LerHeaderbyte:='1';
			if v_AddrHeader=(HeaderEthLength) then
				--termino de leitura do Header
				v_Enablefase0 := '0';		
				v_EnableRdHeader:='0';
				v_Enablefase1:='1';	
			end if;	
			v_AddrHeader := v_AddrHeader+1;
		end if;
	end if;
	
	
	if v_StartRd='1' and v_Enablefase1='1' then
	--lendo Dados/pcts
		v_OValid:='1';
		v_EnableRd:='1';
		if v_LerPctbyte='1' then 
		--le um byte a cada 2 pulsos de clk
			v_LerPctbyte:='0';
		else
			v_EnableRd:='0';
			v_AddrPct:=v_AddrPct+1;
			v_LerPctbyte:='1';
			if v_AddrPct=(v_NumBytes) then
			--termino de leitura dos pacotes
				v_StartRd:='0';
				v_AddrPct:=0;
				v_End:='1';
				v_Standby:=1;
				v_OValid:='0';
				v_Enablefase1:='0';
			end if;	
		end if;	
	end if;		
	

	if v_StartRd='0' and v_Standby =0 then
	--Numero de bytes a cada leitura
	v_NumBytes:=i_BytespPact;
	-- Modo packet
	-- Se ha pacote para serem lidos, habilita leitura
		if (to_integer( unsigned(i_NivelRdFifo)) >= v_NumBytes) then
			--habilita leitura de um frame eth
			v_StartRd:='1';
			--Inicializa variaveis
			v_AddrPct:=0;
			v_AddrHeader := 0;
			v_LerPctbyte:='1';
			v_LerHeaderbyte:='1';
			v_Enablefase1:='0';
			v_Enablefase0:='1';
		end if;
	end if;
	
	if v_Standby>0 and v_Standby< 15 then
		--tempo de styandby entre dois apcotes consecutivos
		--para dar tempo de terminar a entrega de 1 pacote ethernet
		v_Standby:=v_Standby+1;
	else
		v_Standby:=0;
	end if;
	
	o_EnableRdHdEth<=v_EnableRdHeader;
	o_EnableRdPact<=v_EnableRd;
	--atrazo enable de dado valido na saida da fifo, para sair alinhada com dado
	sig_OValid2<=sig_OValid;
	sig_OValid<=v_OValid;
	sig_sync_out2<=sig_sync_out;
	o_Sync<=sig_sync_out2;
	o_ValidOut<=sig_OValid2;
	
end if;
--------------------------------------------------------------------------------
--PROCESSING
End process;

end CtrlRdTxTsOIp_arc;

