-- VHDL FILE
--{{{ HEADER
--!@file
--!IEEE Libraries 
Library ieee;
use ieee.std_logic_1164.all;			-- Std_logic types and related functions;
use ieee.numeric_std.all;				-- X Not use with std_logic_arith
--use ieee.std_logic_arith.all;			-- Arithmetic functions X Not use whith numeric_std
--use ieee.std_logic_unsigned.all;		-- Std_logic unsigned functions;

--------------------------------------------------------------------------------
--!@brief Control Read ASI Out Mode
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! - Controla a leitura de dados da FIFO/Buffer.
--! - Inicia a leitura dos dados somente apos atingido nivel minimo da Fifo (1 pacote armazenado) dados somente a partir do inicio do pacote MPEG.
--! - Configuravel: g_PacketLengthAsiMode => Tamanho em bytes dos pacotes a serem armazenados (188 ou 204)
--! - OBs. Cabecalho preparado para documentacao via Doxygen (somente depois de --! aparece).
--!
--! DETAILS:      
--!
--!- Project Name: MUX ISDB-T                       
--!- Module Name: ASI Out Mode       
--!- Tools: Quartus II 8.1, jEdit, Doxygen  
--!- Author: Getulio Emilio Oliveira Pereira
--!- Company: Inatel - Inatel Competence Center - ICC-HW 
--!- Create Date: Sep/2011    
--   Version: Versao.funcionalidade.correcao                        
--!- Version: 1.0.0 (Sep/2010) > Criado    
--!  
--------------------------------------------------------------------------------
-- Inatel - Inatel Competence Center - ICC-HW - 2010
--------------------------------------------------------------------------------
--
-- Conversion
-- std => Integer  ->  int = to_integer( unsigned());                        
-- integer => Std  ->  std = std_logic_vector( to_unsigned (integer ,8));
-- integer => Unsigned -> to_unsigned(IntNumb, width);
-- UNSIGNED => STD_logic -> std_logic_vector(UnsignedNumb);
--------------------------------------------------------------------------------
--}}} Header






entity teste_crc is
--{{{  >> GENERIC
--------------------------------------------------------------------------------
--generic(
--g_PacketLengthAsiMode	: integer range 0 to 255:=204 	--! Tamanho do pacote (188/204)
--);
--------------------------------------------------------------------------------
--}}} Generic

--{{{  >> PORTS
--------------------------------------------------------------------------------
port(
	-- Entradas
	i_Clk   				: in std_logic;							--! Clock de 27 MHz
	i_nRst    				: in std_logic;							--! Reset Baixo Ativo
	
	i_Sync					: in std_logic;			
	i_Valid					: in std_logic;							--! Nivel de escrita na fifo
	i_Data					: in std_logic_Vector(3 downto 0);	 	--! Numero de pacotes a serem lidos 1 a 7
	i_ValidCRC				: in std_logic;	
	--i_ValidCRC_teste		: in std_logic;	
	
	
	-- Saídas
	o_Data					: out std_logic_Vector(7 downto 0);
	o_Clr					: out std_logic;
	o_Valid					: out std_logic


);

end teste_crc;
--------------------------------------------------------------------------------
--}}} PORTS

--! @brief Architure definition
architecture teste_crc_arc of teste_crc is
--{{{  >> SIGNALS
--------------------------------------------------------------------------------
--signal v_conta						: integer range 0 to 2;

--------------------------------------------------------------------------------
--}}} SIGNALS
begin
Process_Main:
process (i_Clk, i_nRst)
--{{{  >> Variables
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--}}} Variables
variable v_data_aux						: std_logic_vector(3 downto 0);
--variable v_data 						: std_logic_vector(7 downto 0);
variable v_conta						: integer range 0 to 2;
variable v_start						: std_logic;
variable v_ctrl							: std_logic;

begin

--{{{  >> RESET
--------------------------------------------------------------------------------
if (i_nRst = '0') THEN

--Reseting outputs
	o_Data <= (others=>'0');
	v_conta := 0;
	v_ctrl := '0';
	o_Clr <= '0';
	o_Valid <= '0';
--------------------------------------------------------------------------------		
--}}} Reset
---{{{ >>PROCESSING
--------------------------------------------------------------------------------
elsif rising_edge(i_Clk) then
	
	o_Clr <= '0';
	o_Valid <= '0';
	if i_Sync = '1' and i_Valid = '1' then 
		if i_ValidCRC = '1' then
			v_conta := 1;
			v_start := '1';
			v_ctrl := '0';
		else
			v_conta := 0;
			v_start := '0';
		end if;
	end if;
	

	
	
	
	if v_start = '1' then --and i_ValidCRC_teste ='1' then
		case v_conta is
			when 1 =>
				if v_ctrl = '0' then
					o_Clr <= '1';
					v_ctrl := '1';
				end if;
				v_data_aux := i_Data;
--				v_conta := v_conta+1;
--				o_Data <=  i_Data & v_data_aux;
--				o_Valid <= '1';
--				v_conta := v_conta+1;
			when 2 =>
				o_Data <=  i_Data & v_data_aux;
				o_Valid <= '1';
--				v_conta := v_conta-1;
--				v_data_aux := i_Data;
--				v_conta := v_conta-1;
			when others =>
				null;
		end case;
		
		if v_conta = 1 then 
			v_conta := 2;
		elsif v_conta = 2 then 
			v_conta := 1;
		end if;
	else
		o_Valid <= '0';
	end if;
	
	if i_ValidCRC = '0' then
		v_conta := 0;
		v_start := '0';
		v_ctrl := '0';
		--o_Valid <= '0';
	end if;
	
end if;

--------------------------------------------------------------------------------
---}}} PROCESSING
End process;

end teste_crc_arc;

