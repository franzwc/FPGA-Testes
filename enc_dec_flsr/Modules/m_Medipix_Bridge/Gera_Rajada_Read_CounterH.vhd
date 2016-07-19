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
entity Gera_Rajada_Read_CounterH is
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
	Out_En_Mdpx                 : out std_logic :='1';
	Out_Shutter_Mdpx            : out std_logic :='0';
	Out_Cont_sel_Mdpx           : out std_logic :='0';
   Out_MtxClr_Mdpx             : out std_logic :='0';
	Out_TPSWT_Mdpx              : out std_logic :='0'
	--Out_clkup                   : out std_logic :='0';
	--Out_clkdown                 : out std_logic :='0'

);

end Gera_Rajada_Read_CounterH;

architecture Gera_Rajada_Read_CounterH_arc of Gera_Rajada_Read_CounterH is
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
variable conta_byte		       : natural := 0;
variable CountL                : std_logic_vector(1 downto 0);
variable PS                    : std_logic_vector(1 downto 0);

begin

Out_Clk_Medipix<=(Mdpx_clk_up xor Mdpx_clk_down);
--Out_clkup<=Mdpx_clk_up;
--Out_clkdown<=Mdpx_clk_down;

--------------------------------------------------------------------------------
--  >> Etapa de Resete do circuito
--------------------------------------------------------------------------------
if (In_Reset = '1' ) then
	-- Inicializa��o das sa�das
	Out_Clk_Medipix     <='0';
	Out_Reset_Mdpx      <='0';
	Out_Data_Mdpx       <='0';
	Out_En_Mdpx         <='1';
	Out_Shutter_Mdpx    <='0';
	Out_Cont_sel_Mdpx   <='0';
   Out_MtxClr_Mdpx     <='0';
	Out_TPSWT_Mdpx      <='0';
	
	X 		              <=(others=>'0');
	
	conta_byte          :=0;

elsif (falling_edge(In_Clk))then
	---------------------------------------------------
	--clock 
	---------------------------------------------------
	case (CountL) is
	when b"00" =>--2x1bit
	               case (PS) is
						when b"00" =>--data out 0
											if conta_byte=0 then 
											--inicio sinc byte
											elsif conta_byte>=2 and conta_byte<=81 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											--inicio 10'b0
											elsif conta_byte>=83 and conta_byte<=96 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											--inicio execucao
											elsif conta_byte>=101 and conta_byte<=65652 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											elsif conta_byte>=65656 and conta_byte<=65671 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											elsif conta_byte>=65674 and conta_byte<=65683 then
											   Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											else
												Mdpx_clk_down<='0';
											end if;
						when b"10" =>--data out [3:0]
		                           if conta_byte=0 then 
											--inicio sinc byte
											elsif conta_byte>=2 and conta_byte<=81 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											--inicio 10'b0
											elsif conta_byte>=83 and conta_byte<=96 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											--inicio execucao
											elsif conta_byte>=101 and conta_byte<=16500 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											elsif conta_byte>=16504 and conta_byte<=16518 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											elsif conta_byte>=16521 and conta_byte<=16532 then
											   Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											else
												Mdpx_clk_down<='0';
											end if;
						when b"01" =>--data out [1:0]
							            if conta_byte=0 then 
											--inicio sinc byte
											elsif conta_byte>=2 and conta_byte<=81 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											--inicio 10'b0
											elsif conta_byte>=83 and conta_byte<=96 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											--inicio execucao
											elsif conta_byte>=101 and conta_byte<=32884 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											elsif conta_byte>=32888 and conta_byte<=32902 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											elsif conta_byte>=32905 and conta_byte<=32916 then
											   Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											else
												Mdpx_clk_down<='0';
											end if;
						when b"11" =>--data out [7:0]
							            if conta_byte=0 then 
											--inicio sinc byte
											elsif conta_byte>=2 and conta_byte<=81 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											--inicio 10'b0
											elsif conta_byte>=83 and conta_byte<=96 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											--inicio execucao
											elsif conta_byte>=101 and conta_byte<=8308 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											elsif conta_byte>=8312 and conta_byte<=8326 then
												Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											elsif conta_byte>=8329 and conta_byte<=8340 then
											   Mdpx_clk_down<=not(Mdpx_clk_down);
											------------------------------------------------
											else
												Mdpx_clk_down<='0';
											end if;
						when others =>
											Mdpx_clk_down<='0';
						end case;
	
	when b"01" =>--2x12bit
		-- Sequential Statement(s)
	when b"10" =>--2x6bit
		-- Sequential Statement(s)
	when b"11" =>--1x24bit
		-- Sequential Statement(s)
	when others =>
		            Mdpx_clk_down<='0';
	end case;
		
--------------------------------------------------------------------------------
--  >> Implementa��o do circuito - funcionamento em fun��o da transi��o de clock
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
	
	CountL(0):=X(9);
	CountL(1):=X(10);
	
	PS(0):=X(6);
	PS(1):=X(5);
	
	if In_Send = '1' then
	conta_byte:=0;
	Out_En_Mdpx<='1';
	else

	Out_Reset_Mdpx<='1';
	Out_Shutter_Mdpx<='0';
	Out_Cont_sel_Mdpx<='0';
	Out_MtxClr_Mdpx<='1';
	Out_TPSWT_Mdpx<='0';
	
	---------------------------------------------------
	--clock 
	---------------------------------------------------
   case (CountL) is
	when b"00" =>--2x1bit
	            case (PS) is
						when b"00" =>--data out 0
											if conta_byte=0 then
											--inicio sinc byte
											elsif conta_byte>=1 and conta_byte<=80 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											--inicio 10'b0
											elsif conta_byte>=83 and conta_byte<=96 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											--inicio execucao
											elsif conta_byte>=100 and conta_byte<=65651 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											elsif conta_byte>=65656 and conta_byte<=65671 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											elsif conta_byte>=65674 and conta_byte<=65683 then
											   Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											else
												Mdpx_clk_up<='0';
											end if;
						when b"10" =>--data out [3:0]
						               if conta_byte=0 then
											--inicio sinc byte
											elsif conta_byte>=1 and conta_byte<=80 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											--inicio 10'b0
											elsif conta_byte>=83 and conta_byte<=96 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											--inicio execucao
											elsif conta_byte>=100 and conta_byte<=16499 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											elsif conta_byte>=16504 and conta_byte<=16518 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											elsif conta_byte>=16521 and conta_byte<=16532 then
											   Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											else
												Mdpx_clk_up<='0';
											end if;
						when b"01" =>--data out [1:0]
							            if conta_byte=0 then
											--inicio sinc byte
											elsif conta_byte>=1 and conta_byte<=80 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											--inicio 10'b0
											elsif conta_byte>=83 and conta_byte<=96 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											--inicio execucao
											elsif conta_byte>=100 and conta_byte<=32883 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											elsif conta_byte>=32887 and conta_byte<=32902 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											elsif conta_byte>=32905 and conta_byte<=32916 then
											   Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											else
												Mdpx_clk_up<='0';
											end if;
						when b"11" =>--data out [7:0]
							            if conta_byte=0 then
											--inicio sinc byte
											elsif conta_byte>=1 and conta_byte<=80 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											--inicio 10'b0
											elsif conta_byte>=83 and conta_byte<=96 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											--inicio execucao
											elsif conta_byte>=100 and conta_byte<=8307 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											elsif conta_byte>=8311 and conta_byte<=8326 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											elsif conta_byte>=8329 and conta_byte<=8340 then
												Mdpx_clk_up<=not(Mdpx_clk_up);
											------------------------------------------------
											else
												Mdpx_clk_up<='0';
											end if;
						when others =>
											Mdpx_clk_down<='0';
						end case;
	
	when b"01" =>--2x12bit
		-- Sequential Statement(s)
	when b"10" =>--2x6bit
		-- Sequential Statement(s)
	when b"11" =>--1x24bit
		-- Sequential Statement(s)
	when others =>
	           Mdpx_clk_up<='0';
	end case;
	
	------------------------------------------------
	--envio de dados
	------------------------------------------------
	if conta_byte=0 then
	------------------------------------------------
	-- inicio manda omr
   -- cabecalho 0011 12'b0   
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
	--fim cabecalho
	---------------------------------------
	-- comeco da OMR
	elsif conta_byte=17 then
		Out_Data_Mdpx<='0';--> read counter h
	elsif conta_byte=18 then
		Out_Data_Mdpx<='0';--> read counter h
	elsif conta_byte=19 then
		Out_Data_Mdpx<='1';--> read counter h
	elsif conta_byte=20 then
	   Out_Data_Mdpx<=X(3);-->crw srw
	elsif conta_byte=21 then
	   Out_Data_Mdpx<=X(4);-->polarity
	elsif conta_byte=22 then
	   Out_Data_Mdpx<=PS(0);-->ps 0
	elsif conta_byte=23 then
	   Out_Data_Mdpx<=PS(1);-->ps 1
	elsif conta_byte=24 then
	   Out_Data_Mdpx<=X(7);
	elsif conta_byte=25 then
	   Out_Data_Mdpx<=X(8);
	elsif conta_byte=26 then
	   Out_Data_Mdpx<=X(9);
	elsif conta_byte=27 then
	   Out_Data_Mdpx<=X(10);
	elsif conta_byte=28 then
	   Out_Data_Mdpx<=X(11);
	elsif conta_byte=29 then
	   Out_Data_Mdpx<=X(12);
	elsif conta_byte=30 then
	   Out_Data_Mdpx<=X(13);
	elsif conta_byte=31 then
	   Out_Data_Mdpx<=X(14);
	elsif conta_byte=32 then
	   Out_Data_Mdpx<=X(15);
	elsif conta_byte=33 then
	   Out_Data_Mdpx<=X(16);
	elsif conta_byte=34 then
	   Out_Data_Mdpx<=X(17);
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
	-- inicio post sync 8'b10	
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
	-- fim post sync
	---------------------------------
	--10'b0
	elsif conta_byte>=81 and conta_byte<=94 then
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='0';
   elsif conta_byte>=95 and conta_byte<=99 then
	   Out_Data_Mdpx<='0';
		Out_En_Mdpx<='1';
	---------------------------------
	-- inicio execucao 
	-- cabecalho 0101 12'b0   
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
	--fim cabecalho
	-------------------------------
	elsif conta_byte>=116 then
	
			case (CountL) is
			when b"00" => --2x1bit
			         case (PS) is
						when b"00" =>--data out 0
											-------------------------------
											--inicio pacote 1
											if conta_byte>=116 and conta_byte<=65652 then
											--------------------------------
											elsif conta_byte>=65653 and conta_byte<=65655 then
											--8'b10
											elsif conta_byte=65656 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=65657 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=65658 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=65659 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=65660 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=65661 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=65662 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=65663 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=65664 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=65665 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=65666 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=65667 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=65668 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=65669 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=65670 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=65671 then
													Out_Data_Mdpx<='0';
											------------------------------------
											--10'b0
											elsif (conta_byte>=65672 and conta_byte<=65684) then
											      Out_En_Mdpx<='1';
													Out_Data_Mdpx<='0';
											--levanta o enable
											elsif (conta_byte<=65685) then
													Out_En_Mdpx<='1';
													Out_Data_Mdpx<='0';
											--fim de pacote 1
											--------------------------------
											else
													--Mdpx_clk_up<='0';
													Out_Data_Mdpx<='0';
													Out_En_Mdpx<='1';
											end if;
						when b"10" =>--data out [3:0]
		                           -------------------------------
											--inicio pacote 1
											if conta_byte>=116 and conta_byte<=16500 then
											--------------------------------
											elsif conta_byte>=15501 and conta_byte<=16502 then
											--8'b10
											elsif conta_byte=16503 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=16504 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=16505 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=16506 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=16507 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=16508 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=16509 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=16510 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=16511 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=16512 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=16513 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=16514 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=16515 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=16516 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=16517 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=16518 then
													Out_Data_Mdpx<='0';
											------------------------------------
											--10'b0
											elsif conta_byte>=16519 and conta_byte<=16531 then
													Out_En_Mdpx<='1';
													Out_Data_Mdpx<='0';
											--levanta o enable
											elsif conta_byte= 16532 then
													Out_En_Mdpx<='1';
													Out_Data_Mdpx<='0';
											--fim de pacote 1
											--------------------------------
											else
													Mdpx_clk_up<='0';
													Out_Data_Mdpx<='0';
													Out_En_Mdpx<='1';
											end if;
						when b"01" =>--data out [1:0]
							            -------------------------------
											--inicio pacote 1
											if conta_byte>=116 and conta_byte<=32884 then
											--------------------------------
											elsif conta_byte>=32885 and conta_byte<=32886 then
											--8'b10
											elsif conta_byte=32887 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=32888 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=32889 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=32890 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=32891 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=32892 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=32893 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=32894 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=32895 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=32896 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=32897 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=32898 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=32899 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=32900 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=32901 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=32902 then
													Out_Data_Mdpx<='0';
											------------------------------------
											--10'b0
											elsif conta_byte>=32903 and conta_byte<=32915 then
													Out_En_Mdpx<='1';
													Out_Data_Mdpx<='0';
											--levanta o enable
											elsif conta_byte= 32916 then
													Out_En_Mdpx<='1';
													Out_Data_Mdpx<='0';
											--fim de pacote 1
											--------------------------------
											else
													Mdpx_clk_up<='0';
													Out_Data_Mdpx<='0';
													Out_En_Mdpx<='1';
											end if;
						when b"11" =>--data out [7:0]
							            -------------------------------
											--inicio pacote 1
											if conta_byte>=116 and conta_byte<=8308 then
											--------------------------------
											elsif conta_byte>=8309 and conta_byte<=8310 then
											--8'b10
											elsif conta_byte=8311 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=8312 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=8313 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=8314 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=8315 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=8316 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=8317 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=8318 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=8319 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=8320 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=8321 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=8322 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=8323 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=8324 then
													Out_Data_Mdpx<='0';
											elsif conta_byte=8325 then
													Out_Data_Mdpx<='1';
											elsif conta_byte=8326 then
													Out_Data_Mdpx<='0';
											------------------------------------
											--10'b0
											elsif conta_byte>=8327 and conta_byte<=8339 then
													Out_En_Mdpx<='1';
													Out_Data_Mdpx<='0';
											--levanta o enable
											elsif conta_byte= 8340 then
													Out_En_Mdpx<='1';
													Out_Data_Mdpx<='0';
											--fim de pacote 1
											--------------------------------
											else
													Mdpx_clk_up<='0';
													Out_Data_Mdpx<='0';
													Out_En_Mdpx<='1';
											end if;
						when others =>
											Mdpx_clk_up<='0';
											Out_Data_Mdpx<='0';
											Out_En_Mdpx<='1';
											conta_byte:=666665;
						end case;
	
			when b"01" =>--2x12bit
				-- Sequential Statement(s)
			when b"10" =>--2x6bit
				-- Sequential Statement(s)
			when b"11" =>--1x24bit
				-- Sequential Statement(s)
			when others =>
			        Mdpx_clk_up<='0';
				     Out_Data_Mdpx<='0';
					  Out_En_Mdpx<='1';
					  conta_byte:=666665;
			end case;
			
	else
	   Mdpx_clk_up<='0';
		Out_Data_Mdpx<='0';
		Out_En_Mdpx<='1';
		conta_byte:=666665;
	end if;
	
   conta_byte:=conta_byte+1;
	
	end if;
end if;
End process;
end Gera_Rajada_Read_CounterH_arc;
