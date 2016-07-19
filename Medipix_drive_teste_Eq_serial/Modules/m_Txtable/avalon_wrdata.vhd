--------------------------------------------------------------------------------
-- avalon_wrdata.vhd
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity avalon_wrdata is
	port
	(
		-- AVALON SLAVE INTERFACE
      clk   			: in	std_logic;	      									-- avalon clock
		reset_n			: in	std_logic;				   							-- avalon reset_n
		chipselect    	: in	std_logic;						   					-- avalon chip select
		write       	: in  std_logic;                         				-- avalon write signal
		address			: in 	std_logic_vector(1 downto 0);						-- avalon address signal
		writedata     	: in  std_logic_vector(31 downto 0);      			-- avalon MOSI
		read	       	: in  std_logic;                         				-- avalon read signal
		readdata     	: out std_logic_vector(31 downto 0);      			-- avalon MISO
		irq				: out	std_logic;	

		-- CUSTOM INTERFACE
		
		valid_fram		: in std_logic;
		REQ_RD_RDY		: in std_logic;
		busy		      : in std_logic;
		
		new_table		: out  std_logic;
		en_wr			   : out std_logic;
		adr_wr			: out std_logic_vector(8 downto 0);
		data_wr  		: out std_logic_vector(31 downto 0);
		info			   : out std_logic_vector(7 downto 0)
		
	);
	end avalon_wrdata;

architecture avalon_wrdata_arc of avalon_wrdata is

--------------------------------------------------------------------------------
-- COMPONENTE 

--------------------------------------------------------------------------------
signal sig_new_table		: std_logic;
signal sig_busy			: std_logic;
begin
--------------------------------------------------------------------------------
-- INSTÂNCIA 


--PROCESS
process(clk)

-- Registros Avalon
variable rxdata		: std_logic_vector(31 downto 0);
variable txdata		: std_logic_vector(31 downto 0);
variable status		: std_logic_vector(31 downto 0);
variable control	   : std_logic_vector(31 downto 0);
variable var_busy 	: std_logic;

begin
	if rising_edge(clk) then
		if (reset_n='0') then
			
			-- Registros Avalon 
			rxdata	:= (others=>'0');
			txdata	:= (others=>'0');
			status	:= (others=>'0');
			control  := (others=>'0');
			
			readdata<=(others=>'0');
			irq	<= '0';
			adr_wr<=(others=>'0');
			data_wr<=(others=>'0');
			sig_new_table<='0';
			new_table<='0';
			en_wr<='0';
			sig_busy<='0';
			var_busy:='0';
			info<=(others=>'0');
		else
		
		--------------------------------------------------------------------------------
		-- Acesso aos registros
		--------------------------------------------------------------------------------	
			if (chipselect='1') then
				if (write='1') then												-- Escrita
					case address is
						when "00" =>	rxdata	:= writedata;
						when "01" =>	txdata	:= writedata;
						when "10" =>	status	:= writedata;
						when "11" =>	control	:= writedata;
					end case;
				end if;
				if (read='1') then												-- Leitura
					case address is
						when "00" =>	readdata	<= rxdata;
						when "01" =>	readdata	<= txdata;
						when "10" =>	readdata	<= status;
						when "11" =>	readdata	<= control;
					end case;
				end if;
			end if;
		--------------------------------------------------------------------------------		
					
		--------------------------------------------------------------------------------
		-- RECEBE IRQ => Caso haja nova tabela no Buffer
		--------------------------------------------------------------------------------	
	
			-- Se recebeu nova tabela
			sig_new_table	<= status(31);
			if ( status(31)='1' and sig_new_table='0') then
				status(31)			:= '0';										-- Seta o registro Exception
				--control(23 downto 16):=id_table;
				new_table<='1';
				var_busy:='1';
				
				info<= control(23 downto 16);
				
			end if;

			if REQ_RD_RDY='1' then
				-- Se o pedido de leitura foi atendido
				new_table<='0';
			end if;
			
			
			status(30):=var_busy; --- BUSY... memoria sendo lida
			
			sig_busy<=busy;
			-- se terminou a leitura da tabela
			if (busy='0' and sig_busy='1') and  var_busy='1' then
				var_busy:='0';
			end if;
			
		-- Geração da interrupção
		--	if status(31)='1' then
		--		irq	<= '1';
		--	else
		--		irq	<= '0';
		--	end if;
		--------------------------------------------------------------------------------

		--------------------------------------------------------------------------------
		-- Escreve na RAM
		--------------------------------------------------------------------------------	

			-- Requisição de escrita na RAM
			if (control(29)='1') then --WREN = '1' 
				
				control(29):='0';
				en_wr<='1';
				adr_wr<=control(8 downto 0);
				data_wr<=txdata;
			else
				en_wr<='0';		
			end if;
			
			
			-- Escreveu dado na RAM
			if valid_fram='1' then
			
				--escreve dado no registro
				--rxdata := data_fram;
				control(28):='1'; --WRRDY = já escreveu
				
			end if;

		end if;
	end if;
end process;

end avalon_wrdata_arc;
