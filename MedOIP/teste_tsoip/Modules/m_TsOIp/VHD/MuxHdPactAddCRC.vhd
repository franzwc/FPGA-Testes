--
--
--        Gera o sinal que e a soma do cabecalho gerado mais os pacotes TS
--
--
--
--
--
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
use work.pck_crc32_d4.all;


entity MuxHdPactAddCRC is

--{{{  >> PORTS
--------------------------------------------------------------------------------
port(
	-- Entradas
	i_Clk   				   : in std_logic;							--! Clock de 27 MHz
	i_nRst    				: in std_logic;							--! Reset Baixo Ativo
	
	i_Sync					: in std_logic;			
	i_End 					: in std_logic;	
	i_ValidHdEth			: in std_logic;							--! Nivel de escrita na fifo
	i_DataHd				   : in std_logic_Vector(7 downto 0);	 	--! Numero de pacotes a serem lidos 1 a 7
	i_DataPacket			: in std_logic_Vector(7 downto 0);	 	--! Numero de pacotes a serem lidos 1 a 7
	
	-- Saídas
	o_Sync					: out std_logic;						-- saída de READ
	o_End 					: out std_logic;	
	o_Valid				   : out std_logic;						-- Enable de saída de dados
	o_Data					: out std_logic_Vector(7 downto 0);
	o_ValidCRC				: out std_logic;
	o_ValidCRC32			: out std_logic

);

end MuxHdPactAddCRC;
--------------------------------------------------------------------------------
--}}} PORTS

--! @brief Architure definition
architecture MuxHdPactAddCRC_arc of MuxHdPactAddCRC is
--{{{  >> SIGNALS
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--}}} SIGNALS
begin
Process_MuxHdPactAddCRC:
process (i_Clk, i_nRst)
--{{{  >> Variables
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--}}} Variables
variable v_muxsel, v_Valid,v_LSBData	: std_logic;
variable v_data 						: std_logic_vector(7 downto 0);

--- variaveis para o calculo do CRC
variable v_calcularCRC : std_logic;
variable v_ContaByteCRC: integer range 0 to 15;
variable v_End         : std_logic;
begin

--{{{  >> RESET
--------------------------------------------------------------------------------
if (i_nRst = '0') THEN

--Reseting outputs
	o_Valid		   <= '0';	
	o_Sync			<= '0';	
	o_Data			<=(others=>'0');
	v_data         :=(others=>'0');
	v_muxsel       :='1';
	v_Valid        :='0';
	o_End          <='0';
	v_LSBData      :='1';
	v_End          :='0';
	v_calcularCRC  :='0';
	v_ContaByteCRC :=0;
	o_ValidCRC     <= '0';
	o_ValidCRC32   <= '0';
--------------------------------------------------------------------------------		
--}}} Reset
---{{{ >>PROCESSING
--------------------------------------------------------------------------------
elsif (rising_edge(i_Clk)) then

	o_Sync<=i_Sync;
	o_End<='0';


	if i_Sync='1' and i_ValidHdEth='1' then
		v_Valid:= '1';
		v_End:='0';
		--inicializa CRC
		 v_calcularCRC:='1';
		 v_LSBData:='1';
	--elsif i_End='1'  then
	--	v_Valid:= '0';
	end if;

	if v_muxsel='0'then
		--tx dados de pacotes
		if v_LSBData='1' then
			v_data:="0000" & i_DataPacket(3 downto 0);
			o_Data<=v_data;
			v_LSBData:='0';
		else
			v_data:="0000" & i_DataPacket(7 downto 4);
			o_Data<=v_data;
			v_LSBData:='1';
		end if;
		
		
	else
	--tx dados do header
		if v_LSBData='1' then
			v_data:="0000" & i_DataHd(3 downto 0);
			o_Data<=v_data;
			v_LSBData:='0';
		else	
			v_data:="0000" & i_DataHd(7 downto 4);
			o_Data<=v_data;
			v_LSBData:='1';
		end if;	
	end if;
	--armazena e atrasa
	v_muxsel:=i_ValidHdEth;

	v_Valid:='0';
	
	if v_calcularCRC='1' then		  
   v_Valid:='1';
      
   end if;
     
   o_Valid<=v_Valid;
     
	if v_End = '1' then
		 --processou todos os bytes... ja tem o valor da CRC
		 o_ValidCRC32 <= '0';
		 v_calcularCRC:='0';
		 v_Valid:='1';
		 --entregando valor do CRC à saida
		 if v_ContaByteCRC=0 then
				o_Data<="00001110" ;
				v_ContaByteCRC:=1;

		 elsif v_ContaByteCRC=1 then
				o_Data<="00000011" ;
				v_ContaByteCRC:=2;
														
		 elsif v_ContaByteCRC=2 then					  
				o_Data<="00000110" ;
				v_ContaByteCRC:=3;
							  
		 elsif v_ContaByteCRC=3 then
				o_Data<="00000010" ;
				v_ContaByteCRC:=4;
				
		 elsif v_ContaByteCRC=4 then
				o_Data<="00001010" ;
				v_ContaByteCRC:=5;
				
		 elsif v_ContaByteCRC=5 then
				o_Data<="00000011" ;
				v_ContaByteCRC:=6;
				
		 elsif v_ContaByteCRC=6 then					   
				o_Data<="00000110" ;
				v_ContaByteCRC:=7;
									
		 elsif v_ContaByteCRC=7 then					   
				o_Data<="00001001" ;
				v_End:= '0';
				v_ContaByteCRC:=0;
				o_End<='1';
				--v_Valid:= '0';
		 end if;
							  
		 v_Valid:= '1';
		 o_Valid<='1';
							  
	end if;
		
	if i_End='1' then
			v_End:='1';
			v_ContaByteCRC:=0;
	end if;
	
	o_ValidCRC <= v_calcularCRC;
	
end if;

--------------------------------------------------------------------------------
---}}} PROCESSING
End process;

end MuxHdPactAddCRC_arc;

