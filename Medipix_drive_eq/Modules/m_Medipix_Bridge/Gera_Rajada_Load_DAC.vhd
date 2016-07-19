-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Gera OMR
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Gera sinal da OMR para ser enviado ao medipix
--!
--! DETAILS:      
--!
--!- Project Name: Gera_OMR.v                       
--!- Module Name: Gera_OMR
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 17/2/2014     
--!- Version: 1.0.0 (Fev/2014) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2014
--------------------------------------------------------------------------------
--}}} Header*/

--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
entity Gera_Rajada_Load_DAC is
--------------------------------------------------------------------------------
--  >> Portas de acesso ao circuito
--------------------------------------------------------------------------------
port(
	-- Entradas Nios 
	In_Reset                    : in std_logic;
	In_Clk               		 : in std_logic;
	In_Send              		 : in std_logic;
	
   In_M                 		 : in std_logic_vector(2 downto 0);
	In_CRW_SRW           		 : in std_logic;
	In_POLARITY         	   	 : in std_logic;
	In_PS                       : in std_logic_vector(1 downto 0);
	In_DISC_CSM_SPM      		 : in std_logic;
	In_ENABLE_TP         		 : in std_logic;
	In_COUNT_L           		 : in std_logic_vector(1 downto 0);
	In_COLUMN_BLOCK      		 : in std_logic_vector(2 downto 0);
	In_COLUMN_BLOCKSEL   		 : in std_logic;
	In_ROW_BLOCK         		 : in std_logic_vector(2 downto 0);
	In_ROW_BLOCKSEL         	 : in std_logic;
	In_EQUALIZATION      		 : in std_logic;
	In_COLOUR_MODE       		 : in std_logic;
	In_CSM_SPM           		 : in std_logic;
	In_INFO_HEADER       		 : in std_logic;
	In_FUSE_SEL          		 : in std_logic_vector(4 downto 0);
	In_FUSE_PULSE_WD     		 : in std_logic_vector(6 downto 0);
	In_GAIN_MODE    		       : in std_logic_vector(1 downto 0);
	In_SENSE_DAC         		 : in std_logic_vector(4 downto 0);
	In_EXT_DAC                  : in std_logic_vector(4 downto 0);
	In_EXT_BG_SEL               : in std_logic;
	
	In_Threshold_0              : in std_logic_vector(8 downto 0);
	In_Threshold_1              : in std_logic_vector(8 downto 0);
	In_Threshold_2              : in std_logic_vector(8 downto 0);
	In_Threshold_3              : in std_logic_vector(8 downto 0);
	In_Threshold_4              : in std_logic_vector(8 downto 0);
	In_Threshold_5              : in std_logic_vector(8 downto 0);
	In_Threshold_6              : in std_logic_vector(8 downto 0);
	In_Threshold_7              : in std_logic_vector(8 downto 0);
	In_Preamp                   : in std_logic_vector(7 downto 0);
	In_Ikrum                    : in std_logic_vector(7 downto 0);
	In_Shaper                   : in std_logic_vector(7 downto 0);
	In_Disc                     : in std_logic_vector(7 downto 0);
	In_DiscLS                   : in std_logic_vector(7 downto 0);
	In_Shaper_Test              : in std_logic_vector(7 downto 0);
	In_DAC_DiscL                : in std_logic_vector(7 downto 0);
	In_DAC_Test                 : in std_logic_vector(7 downto 0);
	In_DAC_DiscH                : in std_logic_vector(7 downto 0);
	In_Delay                    : in std_logic_vector(7 downto 0);
	In_TP_Buffer_In             : in std_logic_vector(7 downto 0);
	In_TP_Buffer_Out            : in std_logic_vector(7 downto 0);
	In_Rpz                      : in std_logic_vector(7 downto 0);
	In_Gnd                      : in std_logic_vector(7 downto 0);
	In_TP_Ref                   : in std_logic_vector(7 downto 0);
	In_Fbk                      : in std_logic_vector(7 downto 0);
	In_Cas                      : in std_logic_vector(7 downto 0);
	In_TP_RefA                  : in std_logic_vector(8 downto 0);
	In_TP_RefB                  : in std_logic_vector(8 downto 0);
	
	
	-- Saidas
	Out_Clk_Medipix             : out std_logic :='0';
	Out_Reset_Mdpx              : out std_logic :='0';
	Out_Data_Mdpx               :	out std_logic :='0';
	Out_En_Mdpx                 : out std_logic :='1'

);

end Gera_Rajada_Load_DAC;

architecture Gera_Rajada_Load_DAC_arc of Gera_Rajada_Load_DAC is
--------------------------------------------------------------------------------
--  >> Declaração dos sinais do Processo
--------------------------------------------------------------------------------

type Pipe_48x1 is array (0 to 47) of std_logic;
type Pipe_10x9 is array (0 to 9) of std_logic_vector(8 downto 0);
type Pipe_16x8 is array (0 to 16) of std_logic_vector(7 downto 0);
signal X : Pipe_48x1;
signal THR : Pipe_10x9;
signal DAC : Pipe_16x8;

signal Mdpx_clk_up   : std_logic :='1';
signal Mdpx_clk_down : std_logic :='1';

begin
process (In_Clk, In_Reset, Mdpx_clk_up, Mdpx_clk_down)
--------------------------------------------------------------------------------
--  >> Declaração das variáveis do Processo
--------------------------------------------------------------------------------
variable conta_byte		       : integer range 0 to 511 := 0;

begin

Out_Clk_Medipix<=(Mdpx_clk_up xor Mdpx_clk_down);

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicialização das saídas
	Out_Clk_Medipix     <='0';
	Out_Reset_Mdpx      <='0';
	Out_Data_Mdpx       <='0';
	Out_En_Mdpx         <='1';
	
	X 		              <=(others=>'0');
	
	conta_byte          :=0;

elsif (falling_edge(In_Clk))then

   ---------------------------------------------------
	--clock 
	---------------------------------------------------
	if conta_byte=0 then 
	--inicio sinc byte
	elsif conta_byte>=2 and conta_byte<=81 then
	   Mdpx_clk_down<=not(Mdpx_clk_down);
	--inicio 10'b0
	elsif conta_byte>=83 and conta_byte<=96 then
	   Mdpx_clk_down<=not(Mdpx_clk_down);
	--inicio execucao
	elsif conta_byte>=101 and conta_byte<=389 then--389
	   Mdpx_clk_down<=not(Mdpx_clk_down);
	else
	   Mdpx_clk_down<='0';
	end if;
		
--------------------------------------------------------------------------------
--  >> Implementação do circuito - funcionamento em função da transição de clock
--------------------------------------------------------------------------------	
elsif (rising_edge(In_Clk)) then

   X(0)<=In_M(2);
	X(1)<=In_M(1);
	X(2)<=In_M(0);
	X(3)<=In_CRW_SRW;
	X(4)<=In_POLARITY;
	X(5)<=In_PS(0);
	X(6)<=In_PS(1);
	X(7)<=In_DISC_CSM_SPM;
	X(8)<=In_ENABLE_TP;  
	X(9)<=In_COUNT_L(0);
	X(10)<=In_COUNT_L(1);
	X(11)<=In_COLUMN_BLOCK(0);
	X(12)<=In_COLUMN_BLOCK(1);
	X(13)<=In_COLUMN_BLOCK(2);
	X(14)<=In_COLUMN_BLOCKSEL;
	X(15)<=In_ROW_BLOCK(0);
	X(16)<=In_ROW_BLOCK(1);
	X(17)<=In_ROW_BLOCK(2);
	X(18)<=In_ROW_BLOCKSEL;
	X(19)<=In_EQUALIZATION;
	X(20)<=In_COLOUR_MODE;
	X(21)<=In_CSM_SPM;
	X(22)<=In_INFO_HEADER;
	X(23)<=In_FUSE_SEL(0);
	X(24)<=In_FUSE_SEL(1);
	X(25)<=In_FUSE_SEL(2);
	X(26)<=In_FUSE_SEL(3);
	X(27)<=In_FUSE_SEL(4);
	X(28)<=In_FUSE_PULSE_WD(0);
	X(29)<=In_FUSE_PULSE_WD(1);
	X(30)<=In_FUSE_PULSE_WD(2);
	X(31)<=In_FUSE_PULSE_WD(3);
	X(32)<=In_FUSE_PULSE_WD(4);
	X(33)<=In_FUSE_PULSE_WD(5);
	X(34)<=In_FUSE_PULSE_WD(6);
	X(35)<=In_GAIN_MODE(1);
	X(36)<=In_GAIN_MODE(0);
	X(37)<=In_SENSE_DAC(0);
	X(38)<=In_SENSE_DAC(1);
	X(39)<=In_SENSE_DAC(2);
	X(40)<=In_SENSE_DAC(3);
	X(41)<=In_SENSE_DAC(4);
	X(42)<=In_EXT_DAC(0);
	X(43)<=In_EXT_DAC(1);
	X(44)<=In_EXT_DAC(2);
	X(45)<=In_EXT_DAC(3);
	X(46)<=In_EXT_DAC(4);
	X(47)<=In_EXT_BG_SEL;
	
	THR(0)<=In_Threshold_0;
	THR(1)<=In_Threshold_1;
	THR(2)<=In_Threshold_2;
	THR(3)<=In_Threshold_3;
	THR(4)<=In_Threshold_4;
	THR(5)<=In_Threshold_5;
	THR(6)<=In_Threshold_6;
	THR(7)<=In_Threshold_7;
	DAC(0)<=In_Preamp;
	DAC(1)<=In_Ikrum;
	DAC(2)<=In_Shaper;
	DAC(3)<=In_Disc;
	DAC(4)<=In_DiscLS;
	DAC(5)<=In_Shaper_Test;
	DAC(6)<=In_DAC_DiscL;
	DAC(7)<=In_DAC_Test;
	DAC(8)<=In_DAC_DiscH;
	DAC(9)<=In_Delay;
	DAC(10)<=In_TP_Buffer_In;
	DAC(11)<=In_TP_Buffer_Out;
	DAC(12)<=In_Rpz;
	DAC(13)<=In_Gnd;
	DAC(14)<=In_TP_Ref;
	DAC(15)<=In_Fbk;
	DAC(16)<=In_Cas;
	THR(8)<=In_TP_RefA;
	THR(9)<=In_TP_RefB;
	
	if In_Send = '1' then
	conta_byte:=0;
	Out_En_Mdpx<='1';
	else

	Out_Reset_Mdpx<='1';
	
	---------------------------------------------------
	--clock 
	---------------------------------------------------
	if conta_byte=0 then
	--inicio sinc byte
	elsif conta_byte>=1 and conta_byte<=80 then
	   Mdpx_clk_up<=not(Mdpx_clk_up);
	--inicio 10'b0
	elsif conta_byte>=83 and conta_byte<=96 then
	   Mdpx_clk_up<=not(Mdpx_clk_up);
	--inicio execucao
	elsif conta_byte>=100 and conta_byte<=388 then--388
	   Mdpx_clk_up<=not(Mdpx_clk_up);
	else
	   Mdpx_clk_up<='0';
	end if;
	
	------------------------------------------------
	--envio de dados
	------------------------------------------------
	if conta_byte=0 then
   -- 0011 12'b0   
	elsif conta_byte=1 then
      Out_En_Mdpx<='0';
		Out_Data_Mdpx<='0';
	elsif conta_byte=2 then
		Out_Data_Mdpx<='0';
	elsif conta_byte=3 then
		Out_Data_Mdpx<='1';
	elsif conta_byte=4 then
		Out_Data_Mdpx<='1';
		
	elsif conta_byte>=5 and conta_byte<=16 then
		Out_Data_Mdpx<='0';
	
	---------------------------------------
	-- comeco da OMR load dac
	elsif conta_byte=17 then
		Out_Data_Mdpx<='1';-->load dac
	elsif conta_byte=18 then
		Out_Data_Mdpx<='0';-->load dac
	elsif conta_byte=19 then
		Out_Data_Mdpx<='0';-->load dac
	elsif conta_byte=20 then
	   Out_Data_Mdpx<=X(3);
	elsif conta_byte=21 then
	   Out_Data_Mdpx<=X(4);
	elsif conta_byte=22 then
	   Out_Data_Mdpx<=X(6);
	elsif conta_byte=23 then
	   Out_Data_Mdpx<=X(5);
	elsif conta_byte=24 then
	   Out_Data_Mdpx<=X(7);
	elsif conta_byte=25 then
	   Out_Data_Mdpx<=X(8);
	elsif conta_byte=26 then
	   Out_Data_Mdpx<=X(10);
	elsif conta_byte=27 then
	   Out_Data_Mdpx<=X(9);
	elsif conta_byte=28 then
	   Out_Data_Mdpx<=X(13);
	elsif conta_byte=29 then
	   Out_Data_Mdpx<=X(12);
	elsif conta_byte=30 then
	   Out_Data_Mdpx<=X(11);
	elsif conta_byte=31 then
	   Out_Data_Mdpx<=X(14);
	elsif conta_byte=32 then
	   Out_Data_Mdpx<=X(17);
	elsif conta_byte=33 then
	   Out_Data_Mdpx<=X(16);
	elsif conta_byte=34 then
	   Out_Data_Mdpx<=X(15);
	elsif conta_byte=35 then
	   Out_Data_Mdpx<=X(18);
	elsif conta_byte=36 then
	   Out_Data_Mdpx<=X(19);
	elsif conta_byte=37 then
	   Out_Data_Mdpx<=X(20);
	elsif conta_byte=38 then
	   Out_Data_Mdpx<=X(21);
	elsif conta_byte=39 then
	   Out_Data_Mdpx<=X(22);
	elsif conta_byte=40 then
	   Out_Data_Mdpx<=X(23);
	elsif conta_byte=41 then
	   Out_Data_Mdpx<=X(24);
	elsif conta_byte=42 then
	   Out_Data_Mdpx<=X(25);
	elsif conta_byte=43 then
	   Out_Data_Mdpx<=X(26);
	elsif conta_byte=44 then
	   Out_Data_Mdpx<=X(27);
	elsif conta_byte=45 then
	   Out_Data_Mdpx<=X(28);
	elsif conta_byte=46 then
	   Out_Data_Mdpx<=X(29);
	elsif conta_byte=47 then
	   Out_Data_Mdpx<=X(30);
	elsif conta_byte=48 then
	   Out_Data_Mdpx<=X(31);
	elsif conta_byte=49 then
	   Out_Data_Mdpx<=X(32);
	elsif conta_byte=50 then
	   Out_Data_Mdpx<=X(33);
	elsif conta_byte=51 then
	   Out_Data_Mdpx<=X(34);
	elsif conta_byte=52 then
	   Out_Data_Mdpx<=X(35);
	elsif conta_byte=53 then
	   Out_Data_Mdpx<=X(36);
	elsif conta_byte=54 then
	   Out_Data_Mdpx<=X(37);
	elsif conta_byte=55 then
	   Out_Data_Mdpx<=X(38);
	elsif conta_byte=56 then
	   Out_Data_Mdpx<=X(39);
	elsif conta_byte=57 then
	   Out_Data_Mdpx<=X(40);
	elsif conta_byte=58 then
	   Out_Data_Mdpx<=X(41);
   elsif conta_byte=59 then
	   Out_Data_Mdpx<=X(42);
	elsif conta_byte=60 then
	   Out_Data_Mdpx<=X(43);
	elsif conta_byte=61 then
	   Out_Data_Mdpx<=X(44);
	elsif conta_byte=62 then
	   Out_Data_Mdpx<=X(45);
	elsif conta_byte=63 then
	   Out_Data_Mdpx<=X(46);
	elsif conta_byte=64 then
	   Out_Data_Mdpx<=X(47);
	-- fim da OMR
	--------------------------------
	-- Post Sync 8'b10	
	--------------------------------
	elsif conta_byte=65 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=66 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=67 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=68 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=69 then
	   Out_Data_Mdpx<='1';
   elsif conta_byte=70 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=71 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=72 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=73 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=74 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=75 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=76 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=77 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=78 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=79 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=80 then
	   Out_Data_Mdpx<='0';
	--------------------------------
	-- 10'b0
	--------------------------------
	elsif conta_byte>=81 and conta_byte<=94 then
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='0';
   elsif conta_byte>=95 and conta_byte<=99 then
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='1';
	--------------------------------	
	-- Comeco envio das DACS
   --	0101 12'b0
	--------------------------------
	elsif conta_byte=100 then
      Out_En_Mdpx<='0';
		Out_Data_Mdpx<='0';
	elsif conta_byte=101 then
		Out_Data_Mdpx<='1';
	elsif conta_byte=102 then
		Out_Data_Mdpx<='0';
	elsif conta_byte=103 then
		Out_Data_Mdpx<='1';
		
	elsif conta_byte>=104 and conta_byte<=115 then
		Out_Data_Mdpx<='0';
	-------------------------------
	--Comeco das DACS
	-------------------------------
	--tp ref b
	elsif conta_byte=116 then
	   Out_Data_Mdpx<=THR(9) (8);
	elsif conta_byte=117 then
	   Out_Data_Mdpx<=THR(9) (7);
	elsif conta_byte=118 then
	   Out_Data_Mdpx<=THR(9) (6);
	elsif conta_byte=119 then
	   Out_Data_Mdpx<=THR(9) (5);
	elsif conta_byte=120 then
	   Out_Data_Mdpx<=THR(9) (4);
	elsif conta_byte=121 then
	   Out_Data_Mdpx<=THR(9) (3);
	elsif conta_byte=122 then
	   Out_Data_Mdpx<=THR(9) (2);
	elsif conta_byte=123 then
	   Out_Data_Mdpx<=THR(9) (1);
	elsif conta_byte=124 then
	   Out_Data_Mdpx<=THR(9) (0);
	-- tp ref a 
	elsif conta_byte=125 then
	   Out_Data_Mdpx<=THR(8) (8);
	elsif conta_byte=126 then
	   Out_Data_Mdpx<=THR(8) (7);
	elsif conta_byte=127 then
	   Out_Data_Mdpx<=THR(8) (6);
	elsif conta_byte=128 then
	   Out_Data_Mdpx<=THR(8) (5);
	elsif conta_byte=129 then
	   Out_Data_Mdpx<=THR(8) (4);
	elsif conta_byte=130 then
	   Out_Data_Mdpx<=THR(8) (3);
	elsif conta_byte=131 then
	   Out_Data_Mdpx<=THR(8) (2);
	elsif conta_byte=132 then
	   Out_Data_Mdpx<=THR(8) (1);
	elsif conta_byte=133 then
	   Out_Data_Mdpx<=THR(8) (0);
	-- cas 
	elsif conta_byte=134 then
	   Out_Data_Mdpx<=DAC(16) (7);
	elsif conta_byte=135 then
	   Out_Data_Mdpx<=DAC(16) (6);
	elsif conta_byte=136 then
	   Out_Data_Mdpx<=DAC(16) (5);
	elsif conta_byte=137 then
	   Out_Data_Mdpx<=DAC(16) (4);
	elsif conta_byte=138 then
	   Out_Data_Mdpx<=DAC(16) (3);
	elsif conta_byte=139 then
	   Out_Data_Mdpx<=DAC(16) (2);
	elsif conta_byte=140 then
	   Out_Data_Mdpx<=DAC(16) (1);
	elsif conta_byte=141 then
	   Out_Data_Mdpx<=DAC(16) (0);
	-- FBK 
	elsif conta_byte=142 then
	   Out_Data_Mdpx<=DAC(15) (7);
	elsif conta_byte=143 then
	   Out_Data_Mdpx<=DAC(15) (6);
	elsif conta_byte=144 then
	   Out_Data_Mdpx<=DAC(15) (5);
	elsif conta_byte=145 then
	   Out_Data_Mdpx<=DAC(15) (4);
	elsif conta_byte=146 then
	   Out_Data_Mdpx<=DAC(15) (3);
	elsif conta_byte=147 then
	   Out_Data_Mdpx<=DAC(15) (2);
	elsif conta_byte=148 then
	   Out_Data_Mdpx<=DAC(15) (1);
	elsif conta_byte=149 then
	   Out_Data_Mdpx<=DAC(15) (0);
	-- tp ref
	elsif conta_byte=150 then
	   Out_Data_Mdpx<=DAC(14) (7);
	elsif conta_byte=151 then
	   Out_Data_Mdpx<=DAC(14) (6);
	elsif conta_byte=152 then
	   Out_Data_Mdpx<=DAC(14) (5);
	elsif conta_byte=153 then
	   Out_Data_Mdpx<=DAC(14) (4);
	elsif conta_byte=154 then
	   Out_Data_Mdpx<=DAC(14) (3);
	elsif conta_byte=155 then
	   Out_Data_Mdpx<=DAC(14) (2);
	elsif conta_byte=156 then
	   Out_Data_Mdpx<=DAC(14) (1);
	elsif conta_byte=157 then
	   Out_Data_Mdpx<=DAC(14) (0);
	-- gnd
	elsif conta_byte=158 then
	   Out_Data_Mdpx<=DAC(13) (7);
	elsif conta_byte=159 then
	   Out_Data_Mdpx<=DAC(13) (6);
	elsif conta_byte=160 then
	   Out_Data_Mdpx<=DAC(13) (5);
	elsif conta_byte=161 then
	   Out_Data_Mdpx<=DAC(13) (4);
	elsif conta_byte=162 then
	   Out_Data_Mdpx<=DAC(13) (3);
	elsif conta_byte=163 then
	   Out_Data_Mdpx<=DAC(13) (2);
	elsif conta_byte=164 then
	   Out_Data_Mdpx<=DAC(13) (1);
	elsif conta_byte=165 then
	   Out_Data_Mdpx<=DAC(13) (0);
	-- rpz
	elsif conta_byte=166 then
	   Out_Data_Mdpx<=DAC(12) (7);
	elsif conta_byte=167 then
	   Out_Data_Mdpx<=DAC(12) (6);
	elsif conta_byte=168 then
	   Out_Data_Mdpx<=DAC(12) (5);
	elsif conta_byte=169 then
	   Out_Data_Mdpx<=DAC(12) (4);
	elsif conta_byte=170 then
	   Out_Data_Mdpx<=DAC(12) (3);
	elsif conta_byte=171 then
	   Out_Data_Mdpx<=DAC(12) (2);
	elsif conta_byte=172 then
	   Out_Data_Mdpx<=DAC(12) (1);
	elsif conta_byte=173 then
	   Out_Data_Mdpx<=DAC(12) (0);
	-- tp buffer out
	elsif conta_byte=174 then
	   Out_Data_Mdpx<=DAC(11) (7);
	elsif conta_byte=175 then
	   Out_Data_Mdpx<=DAC(11) (6);
	elsif conta_byte=176 then
	   Out_Data_Mdpx<=DAC(11) (5);
	elsif conta_byte=177 then
	   Out_Data_Mdpx<=DAC(11) (4);
	elsif conta_byte=178 then
	   Out_Data_Mdpx<=DAC(11) (3);
	elsif conta_byte=179 then
	   Out_Data_Mdpx<=DAC(11) (2);
	elsif conta_byte=180 then
	   Out_Data_Mdpx<=DAC(11) (1);
	elsif conta_byte=181 then
	   Out_Data_Mdpx<=DAC(11) (0);
	-- tp buffer in
	elsif conta_byte=182 then
	   Out_Data_Mdpx<=DAC(10) (7);
	elsif conta_byte=183 then
	   Out_Data_Mdpx<=DAC(10) (6);
	elsif conta_byte=184 then
	   Out_Data_Mdpx<=DAC(10) (5);
	elsif conta_byte=185 then
	   Out_Data_Mdpx<=DAC(10) (4);
	elsif conta_byte=186 then
	   Out_Data_Mdpx<=DAC(10) (3);
	elsif conta_byte=187 then
	   Out_Data_Mdpx<=DAC(10) (2);
	elsif conta_byte=188 then
	   Out_Data_Mdpx<=DAC(10) (1);
	elsif conta_byte=189 then
	   Out_Data_Mdpx<=DAC(10) (0);
	-- delay
	elsif conta_byte=190 then
	   Out_Data_Mdpx<=DAC(9) (7);
	elsif conta_byte=191 then
	   Out_Data_Mdpx<=DAC(9) (6);
	elsif conta_byte=192 then
	   Out_Data_Mdpx<=DAC(9) (5);
	elsif conta_byte=193 then
	   Out_Data_Mdpx<=DAC(9) (4);
	elsif conta_byte=194 then
	   Out_Data_Mdpx<=DAC(9) (3);
	elsif conta_byte=195 then
	   Out_Data_Mdpx<=DAC(9) (2);
	elsif conta_byte=196 then
	   Out_Data_Mdpx<=DAC(9) (1);
	elsif conta_byte=197 then
	   Out_Data_Mdpx<=DAC(9) (0);
	-- dac disc h
	elsif conta_byte=198 then
	   Out_Data_Mdpx<=DAC(8) (7);
	elsif conta_byte=199 then
	   Out_Data_Mdpx<=DAC(8) (6);
	elsif conta_byte=200 then
	   Out_Data_Mdpx<=DAC(8) (5);
	elsif conta_byte=201 then
	   Out_Data_Mdpx<=DAC(8) (4);
	elsif conta_byte=202 then
	   Out_Data_Mdpx<=DAC(8) (3);
	elsif conta_byte=203 then
	   Out_Data_Mdpx<=DAC(8) (2);
	elsif conta_byte=204 then
	   Out_Data_Mdpx<=DAC(8) (1);
	elsif conta_byte=205 then
	   Out_Data_Mdpx<=DAC(8) (0);
	-- dac test
	elsif conta_byte=206 then
	   Out_Data_Mdpx<=DAC(7) (7);
	elsif conta_byte=207 then
	   Out_Data_Mdpx<=DAC(7) (6);
	elsif conta_byte=208 then
	   Out_Data_Mdpx<=DAC(7) (5);
	elsif conta_byte=209 then
	   Out_Data_Mdpx<=DAC(7) (4);
	elsif conta_byte=210 then
	   Out_Data_Mdpx<=DAC(7) (3);
	elsif conta_byte=211 then
	   Out_Data_Mdpx<=DAC(7) (2);
	elsif conta_byte=212 then
	   Out_Data_Mdpx<=DAC(7) (1);
	elsif conta_byte=213 then
	   Out_Data_Mdpx<=DAC(7) (0);
	-- dac discl
	elsif conta_byte=214 then
	   Out_Data_Mdpx<=DAC(6) (7);
	elsif conta_byte=215 then
	   Out_Data_Mdpx<=DAC(6) (6);
	elsif conta_byte=216 then
	   Out_Data_Mdpx<=DAC(6) (5);
	elsif conta_byte=217 then
	   Out_Data_Mdpx<=DAC(6) (4);
	elsif conta_byte=218 then
	   Out_Data_Mdpx<=DAC(6) (3);
	elsif conta_byte=219 then
	   Out_Data_Mdpx<=DAC(6) (2);
	elsif conta_byte=220 then
	   Out_Data_Mdpx<=DAC(6) (1);
	elsif conta_byte=221 then
	   Out_Data_Mdpx<=DAC(6) (0);
	-- shaper test
	elsif conta_byte=222 then
	   Out_Data_Mdpx<=DAC(5) (7);
	elsif conta_byte=223 then
	   Out_Data_Mdpx<=DAC(5) (6);
	elsif conta_byte=224 then
	   Out_Data_Mdpx<=DAC(5) (5);
	elsif conta_byte=225 then
	   Out_Data_Mdpx<=DAC(5) (4);
	elsif conta_byte=226 then
	   Out_Data_Mdpx<=DAC(5) (3);
	elsif conta_byte=227 then
	   Out_Data_Mdpx<=DAC(5) (2);
	elsif conta_byte=228 then
	   Out_Data_Mdpx<=DAC(5) (1);
	elsif conta_byte=229 then
	   Out_Data_Mdpx<=DAC(5) (0);
	-- discls
	elsif conta_byte=230 then
	   Out_Data_Mdpx<=DAC(4) (7);
	elsif conta_byte=231 then
	   Out_Data_Mdpx<=DAC(4) (6);
	elsif conta_byte=232 then
	   Out_Data_Mdpx<=DAC(4) (5);
	elsif conta_byte=233 then
	   Out_Data_Mdpx<=DAC(4) (4);
	elsif conta_byte=234 then
	   Out_Data_Mdpx<=DAC(4) (3);
	elsif conta_byte=235 then
	   Out_Data_Mdpx<=DAC(4) (2);
	elsif conta_byte=236 then
	   Out_Data_Mdpx<=DAC(4) (1);
	elsif conta_byte=237 then
	   Out_Data_Mdpx<=DAC(4) (0);
	-- disc
	elsif conta_byte=238 then
	   Out_Data_Mdpx<=DAC(3) (7);
	elsif conta_byte=239 then
	   Out_Data_Mdpx<=DAC(3) (6);
	elsif conta_byte=240 then
	   Out_Data_Mdpx<=DAC(3) (5);
	elsif conta_byte=241 then
	   Out_Data_Mdpx<=DAC(3) (4);
	elsif conta_byte=242 then
	   Out_Data_Mdpx<=DAC(3) (3);
	elsif conta_byte=243 then
	   Out_Data_Mdpx<=DAC(3) (2);
	elsif conta_byte=244 then
	   Out_Data_Mdpx<=DAC(3) (1);
	elsif conta_byte=245 then
	   Out_Data_Mdpx<=DAC(3) (0);
	-- shaper
	elsif conta_byte=246 then
	   Out_Data_Mdpx<=DAC(2) (7);
	elsif conta_byte=247 then
	   Out_Data_Mdpx<=DAC(2) (6);
	elsif conta_byte=248 then
	   Out_Data_Mdpx<=DAC(2) (5);
	elsif conta_byte=249 then
	   Out_Data_Mdpx<=DAC(2) (4);
	elsif conta_byte=250 then
	   Out_Data_Mdpx<=DAC(2) (3);
	elsif conta_byte=251 then
	   Out_Data_Mdpx<=DAC(2) (2);
	elsif conta_byte=252 then
	   Out_Data_Mdpx<=DAC(2) (1);
	elsif conta_byte=253 then
	   Out_Data_Mdpx<=DAC(2) (0);
	-- ikrum
	elsif conta_byte=254 then
	   Out_Data_Mdpx<=DAC(1) (7);
	elsif conta_byte=255 then
	   Out_Data_Mdpx<=DAC(1) (6);
	elsif conta_byte=256 then
	   Out_Data_Mdpx<=DAC(1) (5);
	elsif conta_byte=257 then
	   Out_Data_Mdpx<=DAC(1) (4);
	elsif conta_byte=258 then
	   Out_Data_Mdpx<=DAC(1) (3);
	elsif conta_byte=259 then
	   Out_Data_Mdpx<=DAC(1) (2);
	elsif conta_byte=260 then
	   Out_Data_Mdpx<=DAC(1) (1);
	elsif conta_byte=261 then
	   Out_Data_Mdpx<=DAC(1) (0);
	-- preamp
	elsif conta_byte=262 then
	   Out_Data_Mdpx<=DAC(0) (7);
	elsif conta_byte=263 then
	   Out_Data_Mdpx<=DAC(0) (6);
	elsif conta_byte=264 then
	   Out_Data_Mdpx<=DAC(0) (5);
	elsif conta_byte=265 then
	   Out_Data_Mdpx<=DAC(0) (4);
	elsif conta_byte=266 then
	   Out_Data_Mdpx<=DAC(0) (3);
	elsif conta_byte=267 then
	   Out_Data_Mdpx<=DAC(0) (2);
	elsif conta_byte=268 then
	   Out_Data_Mdpx<=DAC(0) (1);
	elsif conta_byte=269 then
	   Out_Data_Mdpx<=DAC(0) (0);
	-- threshold 7
	elsif conta_byte=270 then
	   Out_Data_Mdpx<=THR(7) (8);
	elsif conta_byte=271 then
	   Out_Data_Mdpx<=THR(7) (7);
	elsif conta_byte=272 then
	   Out_Data_Mdpx<=THR(7) (6);
	elsif conta_byte=273 then
	   Out_Data_Mdpx<=THR(7) (5);
	elsif conta_byte=274 then
	   Out_Data_Mdpx<=THR(7) (4);
	elsif conta_byte=275 then
	   Out_Data_Mdpx<=THR(7) (3);
	elsif conta_byte=276 then
	   Out_Data_Mdpx<=THR(7) (2);
	elsif conta_byte=277 then
	   Out_Data_Mdpx<=THR(7) (1);
	elsif conta_byte=278 then
	   Out_Data_Mdpx<=THR(7) (0);
	-- threshold 6
	elsif conta_byte=279 then
	   Out_Data_Mdpx<=THR(6) (8);
	elsif conta_byte=280 then
	   Out_Data_Mdpx<=THR(6) (7);
	elsif conta_byte=281 then
	   Out_Data_Mdpx<=THR(6) (6);
	elsif conta_byte=282 then
	   Out_Data_Mdpx<=THR(6) (5);
	elsif conta_byte=283 then
	   Out_Data_Mdpx<=THR(6) (4);
	elsif conta_byte=284 then
	   Out_Data_Mdpx<=THR(6) (3);
	elsif conta_byte=285 then
	   Out_Data_Mdpx<=THR(6) (2);
	elsif conta_byte=286 then
	   Out_Data_Mdpx<=THR(6) (1);
	elsif conta_byte=287 then
	   Out_Data_Mdpx<=THR(6) (0);
	-- threshold 5
	elsif conta_byte=288 then
	   Out_Data_Mdpx<=THR(5) (8);
	elsif conta_byte=289 then
	   Out_Data_Mdpx<=THR(5) (7);
	elsif conta_byte=290 then
	   Out_Data_Mdpx<=THR(5) (6);
	elsif conta_byte=291 then
	   Out_Data_Mdpx<=THR(5) (5);
	elsif conta_byte=292 then
	   Out_Data_Mdpx<=THR(5) (4);
	elsif conta_byte=293 then
	   Out_Data_Mdpx<=THR(5) (3);
	elsif conta_byte=294 then
	   Out_Data_Mdpx<=THR(5) (2);
	elsif conta_byte=295 then
	   Out_Data_Mdpx<=THR(5) (1);
	elsif conta_byte=296 then
	   Out_Data_Mdpx<=THR(5) (0);
	-- threshold 4
	elsif conta_byte=297 then
	   Out_Data_Mdpx<=THR(4) (8);
	elsif conta_byte=298 then
	   Out_Data_Mdpx<=THR(4) (7);
	elsif conta_byte=299 then
	   Out_Data_Mdpx<=THR(4) (6);
	elsif conta_byte=300 then
	   Out_Data_Mdpx<=THR(4) (5);
	elsif conta_byte=301 then
	   Out_Data_Mdpx<=THR(4) (4);
	elsif conta_byte=302 then
	   Out_Data_Mdpx<=THR(4) (3);
	elsif conta_byte=303 then
	   Out_Data_Mdpx<=THR(4) (2);
	elsif conta_byte=304 then
	   Out_Data_Mdpx<=THR(4) (1);
	elsif conta_byte=305 then
	   Out_Data_Mdpx<=THR(4) (0);
	-- threshold 3
	elsif conta_byte=306 then
	   Out_Data_Mdpx<=THR(3) (8);
	elsif conta_byte=307 then
	   Out_Data_Mdpx<=THR(3) (7);
	elsif conta_byte=308 then
	   Out_Data_Mdpx<=THR(3) (6);
	elsif conta_byte=309 then
	   Out_Data_Mdpx<=THR(3) (5);
	elsif conta_byte=310 then
	   Out_Data_Mdpx<=THR(3) (4);
	elsif conta_byte=311 then
	   Out_Data_Mdpx<=THR(3) (3);
	elsif conta_byte=312 then
	   Out_Data_Mdpx<=THR(3) (2);
	elsif conta_byte=313 then
	   Out_Data_Mdpx<=THR(3) (1);
	elsif conta_byte=314 then
	   Out_Data_Mdpx<=THR(3) (0);
	-- threshold 2
	elsif conta_byte=315 then
	   Out_Data_Mdpx<=THR(2) (8);
	elsif conta_byte=316 then
	   Out_Data_Mdpx<=THR(2) (7);
	elsif conta_byte=317 then
	   Out_Data_Mdpx<=THR(2) (6);
	elsif conta_byte=318 then
	   Out_Data_Mdpx<=THR(2) (5);
	elsif conta_byte=319 then
	   Out_Data_Mdpx<=THR(2) (4);
	elsif conta_byte=320 then
	   Out_Data_Mdpx<=THR(2) (3);
	elsif conta_byte=321 then
	   Out_Data_Mdpx<=THR(2) (2);
	elsif conta_byte=322 then
	   Out_Data_Mdpx<=THR(2) (1);
	elsif conta_byte=323 then
	   Out_Data_Mdpx<=THR(2) (0);
	-- threshold 1
	elsif conta_byte=324 then
	   Out_Data_Mdpx<=THR(1) (8);
	elsif conta_byte=325 then
	   Out_Data_Mdpx<=THR(1) (7);
	elsif conta_byte=326 then
	   Out_Data_Mdpx<=THR(1) (6);
	elsif conta_byte=327 then
	   Out_Data_Mdpx<=THR(1) (5);
	elsif conta_byte=328 then
	   Out_Data_Mdpx<=THR(1) (4);
	elsif conta_byte=329 then
	   Out_Data_Mdpx<=THR(1) (3);
	elsif conta_byte=330 then
	   Out_Data_Mdpx<=THR(1) (2);
	elsif conta_byte=331 then
	   Out_Data_Mdpx<=THR(1) (1);
	elsif conta_byte=332 then
	   Out_Data_Mdpx<=THR(1) (0);
	-- threshold 0
	elsif conta_byte=333 then
	   Out_Data_Mdpx<=THR(0) (8);
	elsif conta_byte=334 then
	   Out_Data_Mdpx<=THR(0) (7);
	elsif conta_byte=335 then
	   Out_Data_Mdpx<=THR(0) (6);
	elsif conta_byte=336 then
	   Out_Data_Mdpx<=THR(0) (5);
	elsif conta_byte=337 then
	   Out_Data_Mdpx<=THR(0) (4);
	elsif conta_byte=338 then
	   Out_Data_Mdpx<=THR(0) (3);
	elsif conta_byte=339 then
	   Out_Data_Mdpx<=THR(0) (2);
	elsif conta_byte=340 then
	   Out_Data_Mdpx<=THR(0) (1);
	elsif conta_byte=341 then
	   Out_Data_Mdpx<=THR(0) (0);
		
	elsif conta_byte>=342 and conta_byte<=372 then
	   Out_Data_Mdpx<='0';
	-------------------------------	
	-- post sync byte
   --	8'b10
	-------------------------------
	elsif conta_byte=373 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=374 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=375 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=376 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=377 then
	   Out_Data_Mdpx<='1';
   elsif conta_byte=378 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=379 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=380 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=381 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=382 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=383 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=384 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=385 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=386 then
	   Out_Data_Mdpx<='0';
	elsif conta_byte=387 then
	   Out_Data_Mdpx<='1';
	elsif conta_byte=388 then
	   Out_Data_Mdpx<='0';
	-------------------------------
	elsif conta_byte = 389 then
	   Out_En_Mdpx<='1';
		Out_Data_Mdpx<='0';
	else
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='1';
		conta_byte:=510;
	end if;
	
   if conta_byte< 510 then
		conta_byte:=conta_byte+1;
	else
	   conta_byte:=511;
	end if;
	
	end if;
end if;
End process;
end Gera_Rajada_Load_DAC_arc;
