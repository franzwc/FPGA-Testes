-- tx_table.vhd

-- This file was auto-generated as part of a SOPC Builder generate operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tx_table is
	port (
		clk        : in  std_logic                     := '0';             --       clock_reset.clk
		rst_n      : in  std_logic                     := '0';             -- clock_reset_reset.reset_n
		chipselect : in  std_logic                     := '0';             --    avalon_slave_0.chipselect
		write      : in  std_logic                     := '0';             --                  .write
		read       : in  std_logic                     := '0';             --                  .read
		address    : in  std_logic_vector(1 downto 0)  := (others => '0'); --                  .address
		writedata  : in  std_logic_vector(31 downto 0) := (others => '0'); --                  .writedata
		readdata   : out std_logic_vector(31 downto 0);                    --                  .readdata
		out_sync   : out std_logic;                                        --       conduit_end.export
		out_valid  : out std_logic;                                        --                  .export
		out_data   : out std_logic_vector(7 downto 0);                     --                  .export
		in_Nreset  : in  std_logic                     := '0';             --                  .export
		clock_vhdl : in  std_logic                     := '0';             --                  .export
		irq        : out std_logic;                                        --                  .export
		info_out   : out std_logic_vector(7 downto 0)                      --                  .export
	);
end entity tx_table;

architecture rtl of tx_table is
	component txtable is
		port (
			clk        : in  std_logic                     := 'X';             -- clk
			rst_n      : in  std_logic                     := 'X';             -- reset_n
			chipselect : in  std_logic                     := 'X';             -- chipselect
			write      : in  std_logic                     := 'X';             -- write
			read       : in  std_logic                     := 'X';             -- read
			address    : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- address
			writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			readdata   : out std_logic_vector(31 downto 0);                    -- readdata
			out_sync   : out std_logic;                                        -- export
			out_valid  : out std_logic;                                        -- export
			out_data   : out std_logic_vector(7 downto 0);                     -- export
			in_Nreset  : in  std_logic                     := 'X';             -- export
			clock_vhdl : in  std_logic                     := 'X';             -- export
			irq        : out std_logic;                                        -- export
			info_out   : out std_logic_vector(7 downto 0)                      -- export
		);
	end component txtable;

begin

	tx_table : component txtable
		port map (
			clk        => clk,        --       clock_reset.clk
			rst_n      => rst_n,      -- clock_reset_reset.reset_n
			chipselect => chipselect, --    avalon_slave_0.chipselect
			write      => write,      --                  .write
			read       => read,       --                  .read
			address    => address,    --                  .address
			writedata  => writedata,  --                  .writedata
			readdata   => readdata,   --                  .readdata
			out_sync   => out_sync,   --       conduit_end.export
			out_valid  => out_valid,  --                  .export
			out_data   => out_data,   --                  .export
			in_Nreset  => in_Nreset,  --                  .export
			clock_vhdl => clock_vhdl, --                  .export
			irq        => irq,        --                  .export
			info_out   => info_out    --                  .export
		);

end architecture rtl; -- of tx_table
