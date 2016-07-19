-- VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief MuxHdPactAddCRC
--------------------------------------------------------------------------------
--! DESCRIPTION:
--!
--! MuxHdPactAddCRC
--!
--! DETAILS:      
--!
--!- Project Name:MuxHdPactAddCRC.vhdl                       
--!- Module Name: MuxHdPactAddCRC
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
use ieee.std_logic_1164.all;		   	-- Std_logic types and related functions;
use ieee.numeric_std.all;			   	-- X Not use with std_logic_arith
use work.pck_crc32_d4.all;

entity MuxHdPactAddCRC is
--------------------------------------------------------------------------------
--PORTS
--------------------------------------------------------------------------------
port(
	-- Entradas
	i_Clk   			   	: in std_logic;							--! Clock de 27 MHz
	i_nRst    				: in std_logic;							--! Reset Baixo Ativo
	
	i_Sync					: in std_logic;			
	i_End 					: in std_logic;	
	i_ValidHdEth			: in std_logic;							--! Nivel de escrita na fifo
	i_DataHd				   : in std_logic_Vector(7 downto 0);	 	--! Numero de pacotes a serem lidos 1 a 7
	i_ValidPact				: in std_logic;							--! Nivel de escrita na fifo
	i_DataPacket			: in std_logic_Vector(7 downto 0);	 	--! Numero de pacotes a serem lidos 1 a 7
	
	-- Saídas
	o_Sync					: out std_logic;						-- saída de READ
	o_End 					: out std_logic;	
	o_Valid				   : out std_logic;						-- Enable de saída de dados
	o_Data					: out std_logic_Vector(7 downto 0);
	o_ValidCRC				: out std_logic;
	o_ValidCRC32			: out std_logic;
	o_Check					: out std_logic_Vector(31 downto 0)

);

end MuxHdPactAddCRC;
--------------------------------------------------------------------------------
--! @brief Architure definition
architecture MuxHdPactAddCRC_arc of MuxHdPactAddCRC is
--SIGNALS

begin
Process_MuxHdPactAddCRC:
process (i_Clk, i_nRst)
--Variables
variable v_muxsel, v_Valid,v_LSBData	: std_logic;
variable v_data 						      : std_logic_vector(7 downto 0);

--- variaveis para o calculo do CRC
variable d				      : std_logic_vector(3 downto 0);
variable c				      : std_logic_vector(31 downto 0);
variable NewCRC		      : std_logic_vector(31 downto 0);
variable check			      : std_logic_vector(31 downto 0);
variable v_calcularCRC     : std_logic;
variable v_ContaByteCRC    : integer range 0 to 15;
variable v_End             : std_logic;
variable v_ContaData       : integer range 0 to 15;
begin

--RESET
--------------------------------------------------------------------------------
if (i_nRst = '0') THEN

--Reseting outputs
	o_Valid<='0';	
	o_Sync<='0';	
	o_Data<=(others=>'0');
	v_data:=(others=>'0');
	v_muxsel:='1';
	v_Valid:='0';
	o_End<='0';
	v_LSBData:='1';
	v_End:='0';
	NewCRC:=(others=>'1');
	v_calcularCRC:='0';
	v_ContaByteCRC:=0;
	v_ContaData:=0;
	o_ValidCRC<='0';
	o_ValidCRC32<='0';
	
	o_Check<=(others=>'0');
	check:=(others=>'1');
--------------------------------------------------------------------------------		
--PROCESSING
--------------------------------------------------------------------------------
elsif (i_Clk'event and i_Clk='1') then

	o_Sync<=i_Sync;
	o_End<='0';


	if i_Sync='1' and i_ValidHdEth='1' then
		v_Valid:= '1';
		v_End:='0';
		--inicializa CRC
		 NewCRC:=(others=>'0');--x"46AF6449";--PAra Ethernet sem alteracao nos dadas: 46AF6449
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
     
      
    if v_ContaData<4 then
		v_ContaData:=v_ContaData + 1;
		--NIBLE a ser processado 
		d:=not(v_data(3 downto 0));
		--d:=(others=>'0');
   else
     	--NIBLE a ser processado 
		d:=v_data(3 downto 0);
		o_ValidCRC32 <= '1';
		check := nextCRC32_D4(v_data(3 downto 0),check);
		
		
   end if;
   
   o_Check <= check;
   
   --crc anterior
   c := NewCRC;
      
    NewCRC(0) := d(0) xor c(28);
    NewCRC(1) := d(1) xor d(0) xor c(28) xor c(29);
    NewCRC(2) := d(2) xor d(1) xor d(0) xor c(28) xor c(29) xor c(30);
    NewCRC(3) := d(3) xor d(2) xor d(1) xor c(29) xor c(30) xor c(31);
    NewCRC(4) := d(3) xor d(2) xor d(0) xor c(0) xor c(28) xor c(30) xor c(31);
    NewCRC(5) := d(3) xor d(1) xor d(0) xor c(1) xor c(28) xor c(29) xor c(31);
    NewCRC(6) := d(2) xor d(1) xor c(2) xor c(29) xor c(30);
    NewCRC(7) := d(3) xor d(2) xor d(0) xor c(3) xor c(28) xor c(30) xor c(31);
    NewCRC(8) := d(3) xor d(1) xor d(0) xor c(4) xor c(28) xor c(29) xor c(31);
    NewCRC(9) := d(2) xor d(1) xor c(5) xor c(29) xor c(30);
    NewCRC(10) := d(3) xor d(2) xor d(0) xor c(6) xor c(28) xor c(30) xor c(31);
    NewCRC(11) := d(3) xor d(1) xor d(0) xor c(7) xor c(28) xor c(29) xor c(31);
    NewCRC(12) := d(2) xor d(1) xor d(0) xor c(8) xor c(28) xor c(29) xor c(30);
    NewCRC(13) := d(3) xor d(2) xor d(1) xor c(9) xor c(29) xor c(30) xor c(31);
    NewCRC(14) := d(3) xor d(2) xor c(10) xor c(30) xor c(31);
    NewCRC(15) := d(3) xor c(11) xor c(31);
    NewCRC(16) := d(0) xor c(12) xor c(28);
    NewCRC(17) := d(1) xor c(13) xor c(29);
    NewCRC(18) := d(2) xor c(14) xor c(30);
    NewCRC(19) := d(3) xor c(15) xor c(31);
    NewCRC(20) := c(16);
    NewCRC(21) := c(17);
    NewCRC(22) := d(0) xor c(18) xor c(28);
    NewCRC(23) := d(1) xor d(0) xor c(19) xor c(28) xor c(29);
    NewCRC(24) := d(2) xor d(1) xor c(20) xor c(29) xor c(30);
    NewCRC(25) := d(3) xor d(2) xor c(21) xor c(30) xor c(31);
    NewCRC(26) := d(3) xor d(0) xor c(22) xor c(28) xor c(31);
    NewCRC(27) := d(1) xor c(23) xor c(29);
    NewCRC(28) := d(2) xor c(24) xor c(30);
    NewCRC(29) := d(3) xor c(25) xor c(31);
    NewCRC(30) := c(26);
    NewCRC(31) := c(27);

     end if;
     
     o_Valid<=v_Valid;
     
	if v_End = '1' then
						  --processou todos os bytes... ja tem o valor da CRC
							o_ValidCRC32 <= '0';
							v_calcularCRC:='0';
							v_Valid:='1';
						  --entregando valor do CRC à saida
								if v_ContaByteCRC=0 then
--									o_Data<="0000" & NewCRC(31 downto 28);
									o_Data<="00001110" ;
									v_ContaByteCRC:=1;
								
								elsif v_ContaByteCRC=1 then
									--o_Data<="0000" & NewCRC(27 downto 24);
									o_Data<="00000011" ;
									v_ContaByteCRC:=2;
									
									
							  elsif v_ContaByteCRC=2 then
							  
							  --o_Data<="0000" & NewCRC(23 downto 20);
							  o_Data<="00000110" ;
							  v_ContaByteCRC:=3;
							  
							  elsif v_ContaByteCRC=3 then
									--o_Data<="0000" & NewCRC(19 downto 16);
									o_Data<="00000010" ;
									v_ContaByteCRC:=4;
							   elsif v_ContaByteCRC=4 then
									--o_Data<="0000" & NewCRC(15 downto 12);
									o_Data<="00001010" ;
									v_ContaByteCRC:=5;
								elsif v_ContaByteCRC=5 then
									--o_Data<="0000" & NewCRC(11 downto 8);
									o_Data<="00000011" ;
									v_ContaByteCRC:=6;
								elsif v_ContaByteCRC=6 then
							   
									--o_Data<="0000" & NewCRC(7 downto 4);
									o_Data<="00000110" ;
									v_ContaByteCRC:=7;
									
								elsif v_ContaByteCRC=7 then
							   
									--o_Data<="0000" & NewCRC(3 downto 0);
									o_Data<="00001001" ;
									v_End:= '0';
									v_ContaByteCRC:=0;
									o_End<='1';
									--v_Valid:= '0';
							  end if;
							  
							  v_Valid:= '1';
							  o_Valid<='1';
							  

		end if;
	
	
	--CRC
	
		if i_End='1' then
			v_End:='1';
			v_ContaByteCRC:=0;
			v_ContaData:=0;
		end if;
	
		o_ValidCRC <= v_calcularCRC;
	
end if;
--------------------------------------------------------------------------------
--PROCESSING
End process;

end MuxHdPactAddCRC_arc;
