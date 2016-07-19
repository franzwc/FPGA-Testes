-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Decoder de parametros passados do Nios
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Decoder de parametros passados do Nios
--!
--! DETAILS:      
--!
--!- Project Name: Decoder_Parametros.vhd                       
--!- Module Name: Decoder_Parametros
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
entity Decoder_Parametros is
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
	Out_M                       : out std_logic_vector(2 downto 0) :=(others=>'0');
	Out_CRW_SRW                 : out std_logic :='0';
	Out_POLARITY                :	out std_logic :='0';
	Out_PS                      : out std_logic_vector(1 downto 0) :=(others=>'0');
	Out_DISC_CSM_SPM            : out std_logic :='0';
	Out_ENABLE_TP               : out std_logic :='0';
	Out_COUNT_L                 : out std_logic_vector(1 downto 0) :=(others=>'0');
   Out_COLUMN_BLOCK            : out std_logic_vector(2 downto 0) :=(others=>'0');
	Out_COLUMN_BLOCKSEL         : out std_logic :='0';
	Out_ROW_BLOCK               : out std_logic_vector(2 downto 0) :=(others=>'0');
	Out_ROW_BLOCKSEL            : out std_logic :='0';
	Out_EQUALIZATION            : out std_logic :='0';
	Out_COLOUR_MODE             : out std_logic :='0';
	Out_CSM_SPM                 : out std_logic :='0';
	Out_INFO_HEADER             :	out std_logic :='0';
	Out_FUSE_SEL                : out std_logic_vector(4 downto 0) :=(others=>'0');
	Out_FUSE_PULSE_WD           : out std_logic_vector(6 downto 0) :=(others=>'0');
	Out_GAIN_MODE               : out std_logic_vector(1 downto 0) :=(others=>'0');
   Out_SENSE_DAC               : out std_logic_vector(4 downto 0) :=(others=>'0');
	Out_EXT_DAC                 : out std_logic_vector(4 downto 0) :=(others=>'0');
	Out_EXT_BG_SEL              : out std_logic :='0';
	Out_Send_OMR                : out std_logic :='0';
	Out_Send_LDac               : out std_logic :='0';
	Out_Send_RDac               : out std_logic :='0';
	Out_Send_LCtpr              : out std_logic :='0';
	Out_Send_LCH                : out std_logic :='0';
	Out_Send_RCH                : out std_logic :='0';
	Out_tipo                    : out std_logic_vector(7 downto 0) :=(others=>'0');
	Out_tipo2                   : out std_logic_vector(7 downto 0) :=(others=>'0')

);

end Decoder_Parametros;

architecture Decoder_Parametros_arc of Decoder_Parametros is
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
variable conta_byte		       : integer range 0 to 200 := 0;
variable var_M                 : std_logic_vector(2 downto 0) :=(others=>'0');
variable var_tipo              : std_logic_vector(7 downto 0) :=(others=>'0');
variable var_tipo2             : std_logic_vector(7 downto 0) :=(others=>'0');

begin
--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_M               <=(others=>'0');
	Out_CRW_SRW         <='0';
	Out_POLARITY        <='0';
	Out_PS              <=(others=>'0');
	Out_DISC_CSM_SPM    <='0';
	Out_ENABLE_TP       <='0';
	Out_COUNT_L         <=(others=>'0');
   Out_COLUMN_BLOCK    <=(others=>'0');
	Out_COLUMN_BLOCKSEL <='0';
	Out_ROW_BLOCK       <=(others=>'0');
	Out_ROW_BLOCKSEL    <='0';
	Out_EQUALIZATION    <='0';
	Out_COLOUR_MODE     <='0';
	Out_CSM_SPM         <='0';
	Out_INFO_HEADER     <='0';
	Out_FUSE_SEL        <=(others=>'0');
	Out_FUSE_PULSE_WD   <=(others=>'0');
	Out_GAIN_MODE       <=(others=>'0');
   Out_SENSE_DAC       <=(others=>'0');
	Out_EXT_DAC         <=(others=>'0');
	Out_EXT_BG_SEL      <='0';
	Out_Send_OMR        <='0';
	Out_Send_LDac       <='0';
	Out_Send_RDac       <='0';
	Out_Send_LCtpr      <='0';
	Out_Send_LCH        <='0';
	Out_Send_RCH        <='0';
	
	conta_byte          :=0;
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------
elsif (rising_edge(In_Clk_nios)) then

   sig_valid<=In_En_nios;
	sig_sinc<=In_Sync_nios;
	sig_data<=In_Data_nios;
	
	Out_FUSE_SEL<=(others=>'0');
	Out_FUSE_PULSE_WD<=(others=>'0');
	
	if (sig_valid='1') then
		
		conta_byte:=conta_byte+1;

		if (sig_sinc='1' and sig_data=x"47") then
			conta_byte:=0;
		end if;

	   if conta_byte=4 then
			var_tipo:=sig_data(7 downto 0);
			Out_tipo<=var_tipo;
		elsif conta_byte=5 then
			var_tipo2:=sig_data(7 downto 0);
			Out_tipo2<=var_tipo2;
		end if;
		
		if (conta_byte>16 and (var_tipo=x"4F" and var_tipo2=x"4D")) then
		
			if conta_byte=18 then
				var_M:=sig_data(2 downto 0);
				Out_M<=var_M(2 downto 0);
			elsif conta_byte=19 then
				Out_CRW_SRW<=sig_data(0);
			elsif conta_byte=20 then
				Out_POLARITY<=sig_data(0);
			elsif conta_byte=21 then
				Out_PS<=sig_data(1 downto 0);
			elsif conta_byte=22 then
				Out_DISC_CSM_SPM<=sig_data(0);
			elsif conta_byte=23 then
				Out_ENABLE_TP<=sig_data(0);
			elsif conta_byte=24 then
				Out_COUNT_L<=sig_data(1 downto 0);
			elsif conta_byte=25 then
				Out_COLUMN_BLOCK<=sig_data(2 downto 0);
			elsif conta_byte=26 then
				Out_COLUMN_BLOCKSEL<=sig_data(0);
			elsif conta_byte=27 then
				Out_ROW_BLOCK<=sig_data(2 downto 0);
			elsif conta_byte=28 then
				Out_ROW_BLOCKSEL<=sig_data(0);
			elsif conta_byte=29 then
				Out_EQUALIZATION<=sig_data(0);
			elsif conta_byte=30 then
				Out_COLOUR_MODE<=sig_data(0);
			elsif conta_byte=31 then
				Out_CSM_SPM<=sig_data(0);
			elsif conta_byte=32 then
				Out_INFO_HEADER<=sig_data(0);
			elsif conta_byte=33 then
				Out_GAIN_MODE<=sig_data(1 downto 0);
			elsif conta_byte=34 then
				Out_SENSE_DAC<=sig_data(4 downto 0);
			elsif conta_byte=35 then
				Out_EXT_DAC<=sig_data(4 downto 0);
			elsif conta_byte=36 then
				Out_EXT_BG_SEL<=sig_data(0);
				
			--fim da leitura comea a mandar dados pro medipix
			elsif conta_byte=40 then
	
					case var_M is
							when b"000" =>
							-- Sequential Statement(s)
							when b"001" =>
								Out_Send_RCH<='1';
							when b"010" =>
							-- Sequential Statement(s)
							when b"011" =>
								Out_Send_LCH<='1';
							when b"100" =>
								Out_Send_LDac<='1';
							when b"101" =>
								Out_Send_LCtpr<='1';
							when b"110" =>
								Out_Send_RDac<='1';
							when b"111" =>
								Out_Send_OMR<='1';
							when others =>
								Out_Send_OMR<='0';
								Out_Send_LDac<='0';
								Out_Send_RDac<='0';
								Out_Send_LCtpr<='0';
								Out_Send_LCH<='0';
								Out_Send_RCH<='0';
					end case;
	
			else
			
				Out_Send_OMR<='0';
				Out_Send_LDac<='0';
				Out_Send_RDac<='0';
				Out_Send_LCtpr<='0';
				Out_Send_LCH<='0';
				Out_Send_RCH<='0';
			end if;
   end if;
	end if;
	
end if;
End process;
end Decoder_Parametros_arc;
