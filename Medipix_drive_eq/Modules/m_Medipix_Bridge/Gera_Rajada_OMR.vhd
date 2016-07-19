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
entity Gera_Rajada_OMR is
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
	
	-- Saidas
	Out_Clk_Medipix             : out std_logic :='0';
	Out_Reset_Mdpx              : out std_logic :='0';
	Out_Data_Mdpx               :	out std_logic :='0';
	Out_En_Mdpx                 : out std_logic :='1'

);

end Gera_Rajada_OMR;

architecture Gera_Rajada_OMR_arc of Gera_Rajada_OMR is
--------------------------------------------------------------------------------
--  >> Declara��o dos sinais do Processo
--------------------------------------------------------------------------------

type Pipe_48x1 is array (0 to 47) of std_logic;
signal X : Pipe_48x1;

signal Mdpx_clk_up   : std_logic :='1';
signal Mdpx_clk_down : std_logic :='1';

begin
process (In_Clk, In_Reset, Mdpx_clk_up, Mdpx_clk_down)
--------------------------------------------------------------------------------
--  >> Declara��o das vari�veis do Processo
--------------------------------------------------------------------------------
variable conta_byte		       : integer range 0 to 511 := 0;

begin

Out_Clk_Medipix<=(Mdpx_clk_up xor Mdpx_clk_down);

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicializa��o das sa�das
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
--  >> Implementa��o do circuito - funcionamento em fun��o da transi��o de clock
--------------------------------------------------------------------------------	
elsif (rising_edge(In_Clk)) then

   X(0)<=In_M(0);
	X(1)<=In_M(1);
	X(2)<=In_M(2);
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
	-- comeco da OMR
	elsif conta_byte=17 then
		Out_Data_Mdpx<='1';--> load omr
	elsif conta_byte=18 then
		Out_Data_Mdpx<='1';--> load omr
	elsif conta_byte=19 then
		Out_Data_Mdpx<='1';--> load omr
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
	--8'b10	
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
	------------------------
	--10'b0
	elsif conta_byte>=81 and conta_byte<=94 then
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='0';
   elsif conta_byte>=95 and conta_byte<=99 then
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='1';
		
	-- 1010 12'b0   
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
		
	elsif conta_byte>=116 and conta_byte<=388 then--388
	
	elsif conta_byte = 389 then
	   Out_En_Mdpx<='1';
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
end Gera_Rajada_OMR_arc;
