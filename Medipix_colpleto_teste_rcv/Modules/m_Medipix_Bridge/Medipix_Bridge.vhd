-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Medipix Bridge
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Bridge de comunicacao com o chip medipix
--!
--! DETAILS:      
--!
--!- Project Name: Medipix_Bridge.v                       
--!- Module Name: Medipix_Bridge
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
entity Medipix_Bridge is
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
	Out_Reset_Mdpx              : out std_logic;
	Out_Clk_Mdpx                : out std_logic;
	Out_Data_Mdpx               :	out std_logic;
	Out_En_Mdpx                 : out std_logic;
	Out_Shutter_Mdpx            : out std_logic;
	Out_Cont_sel_Mdpx           : out std_logic;
   Out_MtxClr_Mdpx             : out std_logic;
	Out_TPSWT_Mdpx              : out std_logic;
	Out_valor                   : out integer range 0 to 188

);

end Medipix_Bridge;

architecture Medipix_Bridge_arc of Medipix_Bridge is
--------------------------------------------------------------------------------
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------
signal sig_valid               : std_logic;
signal sig_sinc   				 : std_logic;
signal sig_data   				 : std_logic_vector (7 downto 0);

begin
process (In_Clk_nios, In_Reset)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable conta_byte		       : integer range 0 to 188 := 0;
variable conta_byte_saida      : integer := 0;

-- REGISTROS DO CHIP 48 bits
variable var_M  		          : std_logic_vector(2 downto 0);
variable var_CRW_SRW	          : std_logic;
variable var_POLARITY          : std_logic;
variable var_PS                : std_logic_vector(1 downto 0);
variable var_DISC_CSM_SPM      : std_logic;
variable var_ENABLE_TP         : std_logic;
variable var_COUNT_L           : std_logic_vector(1 downto 0);
variable var_COLUMN_BLOCK      : std_logic_vector(2 downto 0);
variable var_COLUMN_BLOCKSEL   : std_logic;
variable var_ROW_BLOCK         : std_logic_vector(2 downto 0);
variable var_ROW_BLOCKSEL      : std_logic;
variable var_EQUALIZATION      : std_logic;
variable var_COLOUR_MODE       : std_logic;
variable var_CSM_SPM           : std_logic;
variable var_INFO_HEADER       : std_logic;
variable var_FUSE_SEL          : std_logic_vector(5 downto 0);
variable var_FUSE_PULSE_WD     : std_logic_vector(5 downto 0);
variable var_GAIN_MODE         : std_logic_vector(1 downto 0);
variable var_SENSE_DAC         : std_logic;
variable var_EXT_DAC           : std_logic;
variable var_EXT_BG_SEL        : std_logic;

begin
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_Reset_Mdpx      <='0';
	Out_Clk_Mdpx        <='0';
	Out_Data_Mdpx       <='0';
	Out_En_Mdpx         <='0';
	Out_Shutter_Mdpx    <='0';
	Out_Cont_sel_Mdpx   <='0';
   Out_MtxClr_Mdpx     <='0';
	Out_TPSWT_Mdpx      <='0';
	Out_valor           <=0;
	
	conta_byte          :=0;
	var_M  		        :=(others=>'0');
   var_CRW_SRW	        :='0';
	var_POLARITY        :='0';
	var_PS              :=(others=>'0');
	var_DISC_CSM_SPM    :='0';
	var_ENABLE_TP       :='0';
	var_COUNT_L         :=(others=>'0');
	var_COLUMN_BLOCK    :=(others=>'0');
	var_COLUMN_BLOCKSEL :='0';
	var_ROW_BLOCK       :=(others=>'0');
	var_ROW_BLOCKSEL    :='0';
	var_EQUALIZATION    :='0';
	var_COLOUR_MODE     :='0';
	var_CSM_SPM         :='0';
	var_INFO_HEADER     :='0';
	var_FUSE_SEL        :=(others=>'0');
	var_FUSE_PULSE_WD   :=(others=>'0');
	var_GAIN_MODE       :=(others=>'0');
	var_SENSE_DAC       :='0';
	var_EXT_DAC         :='0';
	var_EXT_BG_SEL      :='0';
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------
elsif (rising_edge(In_Clk_nios)) then

   Out_Clk_Mdpx<=In_Clk_nios;
   sig_valid<=In_En_nios;
	sig_sinc<=In_Sync_nios;
	sig_data<=In_Data_nios;
	
	if (sig_valid='1') then
	conta_byte:=conta_byte+1;
	if (sig_sinc='1' and sig_data=x"47") then
	conta_byte:=0;
	end if;
	-- Leitura dos dados do pacote
	if conta_byte=18 then
      var_M:=sig_data(2 downto 0);
	elsif conta_byte=19 then
      var_CRW_SRW:=sig_data(0);
	elsif conta_byte=20 then
      var_POLARITY:=sig_data(0);
	elsif conta_byte=21 then
      var_PS:=sig_data(1 downto 0);
	elsif conta_byte=22 then
      var_DISC_CSM_SPM:=sig_data(0);
	elsif conta_byte=23 then
      var_ENABLE_TP:=sig_data(0);
	elsif conta_byte=24 then
      var_COUNT_L:=sig_data(1 downto 0);
	elsif conta_byte=25 then
      var_COLUMN_BLOCK:=sig_data(2 downto 0);
	elsif conta_byte=26 then
      var_COLUMN_BLOCKSEL:=sig_data(0);
	elsif conta_byte=27 then
      var_ROW_BLOCK:=sig_data(2 downto 0);
	elsif conta_byte=28 then
      var_ROW_BLOCKSEL:=sig_data(0);
	elsif conta_byte=29 then
      var_EQUALIZATION:=sig_data(0);
	elsif conta_byte=30 then
      var_COLOUR_MODE:=sig_data(0);
	elsif conta_byte=31 then
      var_CSM_SPM:=sig_data(0);
	elsif conta_byte=32 then
      var_INFO_HEADER:=sig_data(0);
	elsif conta_byte=33 then
      var_GAIN_MODE:=sig_data(1 downto 0);
	elsif conta_byte=34 then
      var_SENSE_DAC:=sig_data(0);
	elsif conta_byte=35 then
      var_EXT_DAC:=sig_data(0);
	elsif conta_byte=36 then
      var_EXT_BG_SEL:=sig_data(0);
	--fim da leitura comea a mandar dados pro medipix
	
	elsif conta_byte=80 then
	   conta_byte_saida:=0;
	else
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	end if;
	end if;
	
	
	if conta_byte_saida=0 then
	   Out_Reset_Mdpx<='0';
	   Out_En_Mdpx<='1';
	elsif conta_byte_saida>=1 and conta_byte_saida<=3 then
	   Out_Reset_Mdpx<='1';
	   Out_En_Mdpx<='1';
	elsif conta_byte_saida=4 then
	   Out_Reset_Mdpx<='1';
	   Out_En_Mdpx<='0';
	
	-- OP CODE CARREGAR OU EXECUTAR	
	elsif conta_byte_saida=5 then
	   Out_Data_Mdpx<='1';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=6 then
	   Out_Data_Mdpx<='1';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=7 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=8 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida>=9 and conta_byte_saida<=20 then
	   Out_Data_Mdpx<='1';
	   Out_En_Mdpx<='0';
------------------------------------		
	elsif conta_byte_saida=21 then
	   Out_Data_Mdpx<=var_M(0);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=22 then
	   Out_Data_Mdpx<=var_M(1);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=23 then
	   Out_Data_Mdpx<=var_M(2);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=24 then
	   Out_Data_Mdpx<=var_CRW_SRW;
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=25 then
	   Out_Data_Mdpx<=var_POLARITY;
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=26 then
	   Out_Data_Mdpx<=var_PS(0);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=27 then
	   Out_Data_Mdpx<=var_PS(1);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=28 then
	   Out_Data_Mdpx<=var_DISC_CSM_SPM;
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=29 then
	   Out_Data_Mdpx<=var_ENABLE_TP;
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=30 then
	   Out_Data_Mdpx<=var_COUNT_L(0);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=31 then
	   Out_Data_Mdpx<=var_COUNT_L(1);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=32 then
	   Out_Data_Mdpx<=var_COLUMN_BLOCK(0);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=33 then
	   Out_Data_Mdpx<=var_COLUMN_BLOCK(1);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=34 then
	   Out_Data_Mdpx<=var_COLUMN_BLOCK(2);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=35 then
	   Out_Data_Mdpx<=var_COLUMN_BLOCKSEL;
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=36 then
	   Out_Data_Mdpx<=var_ROW_BLOCK(0);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=37 then
	   Out_Data_Mdpx<=var_ROW_BLOCK(1);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=38 then
	   Out_Data_Mdpx<=var_ROW_BLOCK(2);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=39 then
	   Out_Data_Mdpx<=var_ROW_BLOCKSEL;
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=40 then
	   Out_Data_Mdpx<=var_EQUALIZATION;
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=41 then
	   Out_Data_Mdpx<=var_COLOUR_MODE;
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=42 then
	   Out_Data_Mdpx<=var_CSM_SPM;
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=43 then
	   Out_Data_Mdpx<=var_INFO_HEADER;
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=44 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=45 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=46 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=47 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=48 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=49 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=50 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=51 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=52 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=53 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=54 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=55 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=57 then
	   Out_Data_Mdpx<=var_GAIN_MODE(0);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=58 then
	   Out_Data_Mdpx<=var_GAIN_MODE(1);
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=59 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=60 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=61 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=62 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=63 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
   elsif conta_byte_saida=64 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=65 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=66 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=67 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=68 then
	   Out_Data_Mdpx<='0';
	   Out_En_Mdpx<='0';
	elsif conta_byte_saida=69 then
	   Out_Data_Mdpx<=var_EXT_BG_SEL;
	   Out_En_Mdpx<='0';
	--------------------------------
	elsif conta_byte_saida>=70 and conta_byte_saida<=85 then
	   Out_Data_Mdpx<='1';
	   Out_En_Mdpx<='0';
	else
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='0';
	end if;
	
   conta_byte_saida:=conta_byte_saida+1;
	
end if;
End process;
end Medipix_Bridge_arc;
