---------------------------------------------------------------------------------------------------------------
--												ReaderTableConfigIP												       
---------------------------------------------------------------------------------------------------------------
--																								               
-- >> Descrição do projeto 																				       
--																											   
-- Analisa o PID 03h para encontrar as configurações de taxa de saída e se haverá
-- correção do pcr no compressor, ainda se habilitará a filtragem de pid no decompressor e por fim, 
-- se há troca de canal virtual 
---------------------------------------------------------------------------------------------------------------
--																											   
-- >> Descrição dos pinos do projeto 																		   
--																											   
-- >> Entradas																				    			   
--												   
-- 												   
-- 												   
-- 												   
--																											   
-- >> Saídas																								   
--																											   
--								   
--																											   
---------------------------------------------------------------------------------------------------------------
-- >> Autor																								       
-- >> Getúlio Emílio Oliveira Pereira 																		   
---------------------------------------------------------------------------------------------------------------
-- Criado em : 02/05/2011																					   
-- Empresa : Linear Equipamentos Eletrônicos																   
-- Última modificação : 																					   
--  																										   
---------------------------------------------------------------------------------------------------------------
                                                                                                               
---------------------------------------------------------------------------------------------------------------
-- Definição das bibliotecas 																				   

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------------------------------------------------- 
                                                                                                               
---------------------------------------------------------------------------------------------------------------
-- Definição do componente 																					   	
entity ReaderTableConfigIP is --{{{
port (
		--Entradas
		iClock		 		: in std_logic;
		iReset		 		: in std_logic;
		iData				: in std_logic_vector(7 downto 0);
		iSync				: in std_logic;
		iValid				: in std_logic;
	
		
		--Saídas	
				out_EnableOutIP           : out std_logic;
		out_Protocol              : out std_logic_vector(7 downto 0);
		out_TimeToLive            : out std_logic_vector(7 downto 0);
		out_NumberTSPackets       : out std_logic_vector(7 downto 0);
		out_IPSource              : out std_logic_vector(31 downto 0);
		out_MacSource             : out std_logic_vector(47 downto 0);
		out_PortSource            : out std_logic_vector(15 downto 0);
		out_IPDest                : out std_logic_vector(31 downto 0);
		out_MacDest               : out std_logic_vector(47 downto 0);
		out_PortDest              : out std_logic_vector(15 downto 0)
		
		
	);

END ReaderTableConfigIP; 
---------------------------------------------------------------------------------------------------------------}}}

---------------------------------------------------------------------------------------------------------------
-- Descrição do comportamento do circuito																	   
---------------------------------------------------------------------------------------------------------------
architecture ReaderTableConfigIP_behavior of ReaderTableConfigIP is --{{{

--definição dos sinais


begin 

	Main: process(iClock, iReset)
	
	--definição das variáveis
	variable var_pid 		 		: std_logic_vector(12 downto 0);
	variable var_tableid	 		: std_logic_vector(7 downto 0);
	variable var_pid_03		 		: std_logic;
	variable var_config		 		: std_logic;
	variable var_count				: integer range 0 to 203;
--
variable	var_EnableOutIP           : std_logic;
variable	var_Protocol              : std_logic_vector(7 downto 0);
variable	var_TimeToLive            : std_logic_vector(7 downto 0);
variable	var_NumberTSPackets       : std_logic_vector(7 downto 0);
variable	var_IPSource              : std_logic_vector(31 downto 0);
variable	var_MacSource             : std_logic_vector(47 downto 0);
variable	var_PortSource            : std_logic_vector(15 downto 0);
variable	var_IPDest                : std_logic_vector(31 downto 0);
variable	var_MacDest               : std_logic_vector(47 downto 0);
variable	var_PortDest              : std_logic_vector(15 downto 0);
	
	
	
	begin --}}}
	
		--reseta o circuito
		if iReset = '0' then --{{{
		
		--inicializa os sinais		
		out_EnableOutIP                  <='0'              ;
		out_Protocol                     <= (others=>'0')    ;
		out_TimeToLive                   <= (others=>'0')    ;
		out_NumberTSPackets              <= (others=>'0')    ;
		out_IPSource                     <= (others=>'0')    ;
		out_MacSource                    <= (others=>'0')    ;
		out_PortSource                   <= (others=>'0')    ;
		out_IPDest                       <= (others=>'0')    ;
		out_MacDest                      <= (others=>'0')    ;
		out_PortDest                     <= (others=>'0')    ;
					
			
			
		--inicializa as variáveis
	var_EnableOutIP                  :='0'              ;
	var_Protocol                     := (others=>'0')    ;
	var_TimeToLive                   := (others=>'0')    ;
	var_NumberTSPackets              := (others=>'0')    ;
	var_IPSource                     := (others=>'0')    ;
	var_MacSource                    := (others=>'0')    ;
	var_PortSource                   := (others=>'0')    ;
	var_IPDest                       := (others=>'0')    ;
	var_MacDest                      := (others=>'0')    ;
	var_PortDest                     := (others=>'0')    ;
	var_count:=0;

			 --}}}
			
		elsif rising_edge(iClock) then
		
------------corpo do projeto-----------------------------------------------------------------------------------{{{
--			if iRateASI1 = '1' then --ajuste de taxa habilitado
--				if iRateASI1_enable = '1' then --enable de leitura do ajuste de taxa
--					if var_countDelayPkt /= 188 then
--						var_countDelayPkt := var_countDelayPkt + 1;
--						var_ctrlDelay := '0';
--					else 
--						var_countDelayPkt := var_countDelayPkt;
--						var_ctrlDelay := '1';
--					end if;
--				end if;
				
--				if var_ctrlChP = '0' then --detecta mudança configuração da taxa de saída  
--					var_aux_rate		:= var_rate_asi1;
--					var_ctrlChP := '1';
--				else
--					if var_aux_rate /= var_rate_asi1 then --mudou taxa
--						var_ctrlChP := '0';
--						var_DelayPkt := 0;
--						var_ctrlDelay := '0';
--						var_countDelayPkt := 0;
--						oAuxDelay <= 0;
--					else
--						var_ctrlChP := '1';
--					end if;
--				end if;
--				if var_ctrlDelay = '0' then
--					var_DelayPkt := var_DelayPkt + 1; --número de pulsos de clk necessários para gerar um pkt para diferentes configurações de taxa
--				else
--					var_DelayPkt := var_DelayPkt;
--					oAuxDelay	 <= var_DelayPkt;
--				end if;
--			else
--				oAuxDelay <= 0;
--				var_DelayPkt := 0;
--				var_ctrlDelay := '0';
--				var_countDelayPkt := 0;
--			end if;

			if iValid = '1' then
				if iSync = '1' then --and iData =x"47" then --sync found
					var_count := 1; 
				end if;
				
				if var_count = 2 then 
					var_pid(12 downto 8) := iData(4 downto 0);
				elsif var_count = 3 then
					var_pid(7 downto 0) := iData;
					if var_pid = "0000000000011" then --pid 03h found
						var_pid_03 := '1';
					else
						var_pid_03 := '0';
					end if;
				end if;
				
				if var_count = 6 and var_pid_03 = '1' then 
					var_tableid := iData;
					if var_tableid ="10110101" then --TABLE CONFIG IP found "B5"
						var_config := '1';
					else 
						var_config := '0';
					end if;
				end if;
				
				--TXIpEnabled
				if var_count = 14 and var_config = '1' then 
					var_EnableOutIP	:= idata(0);
				
				end if;
				
				--Protocol
				if var_count = 15 and var_config = '1' then 
					var_Protocol	:= iData;
				end if;
				
				--TimeToLive
				if var_count = 16 and var_config = '1' then 
					var_TimeToLive		:= iData;
				end if;
				
				--NumberTSPackets
				if var_count = 17 and var_config = '1' then 
					var_NumberTSPackets	:= iData;
				end if;
				
				---SOURCE--------------------------------------------

				--IP_Source(MSB)
				if var_count = 18 and var_config = '1' then 
					var_IPSource(31 downto 24)	:= idata;

				end if;
				--IP_Source
				if var_count = 19 and var_config = '1' then 
					var_IPSource(23 downto 16)	:= idata;
				end if;
				--IP_Source
				if var_count = 20 and var_config = '1' then 
					var_IPSource(15 downto 8)	:= idata;
				end if;
				--IP_Source
				if var_count = 21 and var_config = '1' then 
					var_IPSource(7 downto 0)	:= idata;
				end if; 
				
				--Mac_Source (MSB)
				if var_count = 22 and var_config = '1' then 
					var_MacSource(47 downto 40)	:= idata;
				end if;
				--Mac_Source 
				if var_count = 23 and var_config = '1' then 
					var_MacSource(39 downto 32)	:= idata;
				end if;
				
				--Mac_Source 
				if var_count = 24 and var_config = '1' then 
					var_MacSource(31 downto 24)	:= idata;
				end if;
				--Mac_Source 
				if var_count = 25 and var_config = '1' then 
					var_MacSource(23 downto 16)	:= idata;
				end if;
				--Mac_Source 
				if var_count = 26 and var_config = '1' then
					var_MacSource(15 downto 8)	:= idata;
				end if;
				--Mac_Source 
				if var_count = 27 and var_config = '1' then
					var_MacSource(7 downto 0)	:= idata;
				end if;
				
				--Port_Source(MSB)
				if var_count = 28 and var_config = '1' then
					var_PortSource(15 downto 8)	:= idata;
				end if;
				
				--Port_Source
				if var_count = 29 and var_config = '1' then
					var_PortSource(7 downto 0)	:= idata;
				end if;
				
				
				
	---DEST--------------------------------------------

				--IP_Dest(MSB)
				if var_count = 30 and var_config = '1' then 
					var_IPDest(31 downto 24)	:= idata;

				end if;
				--IP_Dest
				if var_count = 31 and var_config = '1' then 
					var_IPDest(23 downto 16)	:= idata;
				end if;
				--IP_Dest
				if var_count = 32 and var_config = '1' then 
					var_IPDest(15 downto 8)	:= idata;
				end if;
				--IP_Dest
				if var_count = 33 and var_config = '1' then 
					var_IPDest(7 downto 0)	:= idata;
				end if; 
				
				--Mac_DEST (MSB)
				if var_count = 34 and var_config = '1' then 
					var_MacDest(47 downto 40)	:= idata;
				end if;
				--Mac_Source 
				if var_count = 35 and var_config = '1' then 
					var_MacDest(39 downto 32)	:= idata;
				end if;
				
				--Mac_Source 
				if var_count = 36 and var_config = '1' then 
					var_MacDest(31 downto 24)	:= idata;
				end if;
				--Mac_Source 
				if var_count = 37 and var_config = '1' then 
					var_MacDest(23 downto 16)	:= idata;
				end if;
				--Mac_Source 
				if var_count = 38 and var_config = '1' then
					var_MacDest(15 downto 8)	:= idata;
				end if;
				--Mac_Source 
				if var_count = 39 and var_config = '1' then
					var_MacDest(7 downto 0)	:= idata;
				end if;
				
				--Port_Dest(MSB)
				if var_count = 40 and var_config = '1' then
					var_PortDest(15 downto 8)	:= idata;
				end if;
				
				--Port_Dest
				if var_count = 41 and var_config = '1' then
					var_PortDest(7 downto 0)	:= idata;
				end if;
								
				
				
				
				

				
				--Extraiu todos os parametros
				if var_count = 100 and var_config = '1' then 
				
				out_Protocol                     <=var_Protocol                 ;
				out_TimeToLive                   <=var_TimeToLive               ;
				out_NumberTSPackets              <=var_NumberTSPackets          ;
				out_IPSource                     <=var_IPSource                 ;
				out_MacSource                    <=var_MacSource                ;
				out_PortSource                   <=var_PortSource               ;
				out_IPDest                       <=var_IPDest                   ;
				out_MacDest                      <=var_MacDest                  ;
				out_PortDest                     <=var_PortDest                 ;
				
				elsif var_count = 101 and var_config = '1' then 
					out_EnableOutIP                  <=var_EnableOutIP              ;	
				end if;
				
				
				
				
				--inc count
				if var_count /= 204 then
					var_count := var_count + 1;
				end if;
			end if;
			      
-------------------------------------------------------------------------------------------------------------}}}						
			
		end if;
	end process Main;

end ReaderTableConfigIP_behavior;
---------------------------------------------------------------------------------------------------------------
-- Termino do programa 																						   
--------------------------------------------------------------------------------------------------------------- 