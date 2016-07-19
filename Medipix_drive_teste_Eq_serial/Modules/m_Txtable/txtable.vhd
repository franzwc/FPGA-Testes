-- Copyright (C) 1991-2008 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II"
-- VERSION		"Version 8.1 Build 163 10/28/2008 SJ Full Version"
-- CREATED ON		"Mon Sep 14 14:35:26 2009"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY txtable IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		chipselect :  IN  STD_LOGIC;
		write :  IN  STD_LOGIC;
		read :  IN  STD_LOGIC;
		rst_n :  IN  STD_LOGIC;
		in_Nreset :  IN  STD_LOGIC;
		clock_vhdl :  IN  STD_LOGIC;
		address :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		writedata :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		irq :  OUT  STD_LOGIC;
		out_sync :  OUT  STD_LOGIC;
		out_valid :  OUT  STD_LOGIC;
		info_out :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		out_data :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		readdata :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END txtable;

ARCHITECTURE bdf_type OF txtable IS 

COMPONENT avalon_wrdata
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 chipselect : IN STD_LOGIC;
		 write : IN STD_LOGIC;
		 read : IN STD_LOGIC;
		 valid_fram : IN STD_LOGIC;
		 REQ_RD_RDY : IN STD_LOGIC;
		 busy : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 irq : OUT STD_LOGIC;
		 new_table : OUT STD_LOGIC;
		 en_wr : OUT STD_LOGIC;
		 adr_wr : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		 data_wr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 info : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ip_ram_txtable
	PORT(wren : IN STD_LOGIC;
		 rden : IN STD_LOGIC;
		 wrclock : IN STD_LOGIC;
		 rdclock : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rdaddress : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		 wraddress : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT txdata_tovhdl
	PORT(IN_CLOCK : IN STD_LOGIC;
		 IN_nRESET : IN STD_LOGIC;
		 IN_NEWTABLE : IN STD_LOGIC;
		 OUT_EN_RD : OUT STD_LOGIC;
		 OUT_START_RD : OUT STD_LOGIC;
		 OUT_REQRDY : OUT STD_LOGIC;
		 OUT_BUSY : OUT STD_LOGIC;
		 OUT_ADR_RD : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	adr_rd :  STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL	adr_wr :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	busy :  STD_LOGIC;
SIGNAL	busy_clk :  STD_LOGIC;
SIGNAL	data_wr :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	data_wr_inv :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	en_rd :  STD_LOGIC;
SIGNAL	en_w :  STD_LOGIC;
SIGNAL	info :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	info_a :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	new_table :  STD_LOGIC;
SIGNAL	new_table_clkvhdl :  STD_LOGIC;
SIGNAL	reqrdy :  STD_LOGIC;
SIGNAL	reqrdy_clk :  STD_LOGIC;
SIGNAL	start_rd :  STD_LOGIC;
SIGNAL	valid_fram :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	DFF_inst10 :  STD_LOGIC;
SIGNAL	DFF_inst16 :  STD_LOGIC;
SIGNAL	DFF_inst6 :  STD_LOGIC;


BEGIN 



b2v_inst : avalon_wrdata
PORT MAP(clk => clk,
		 reset_n => rst_n,
		 chipselect => chipselect,
		 write => write,
		 read => read,
		 valid_fram => valid_fram,
		 REQ_RD_RDY => reqrdy_clk,
		 busy => busy_clk,
		 address => address,
		 writedata => writedata,
		 irq => irq,
		 new_table => new_table,
		 en_wr => en_w,
		 adr_wr => adr_wr,
		 data_wr => data_wr,
		 info => info,
		 readdata => readdata);


b2v_inst1 : ip_ram_txtable
PORT MAP(wren => en_w,
		 rden => en_rd,
		 wrclock => SYNTHESIZED_WIRE_0,
		 rdclock => SYNTHESIZED_WIRE_1,
		 data => data_wr_inv,
		 rdaddress => adr_rd,
		 wraddress => adr_wr,
		 q => out_data);


PROCESS(clock_vhdl)
BEGIN
IF (RISING_EDGE(clock_vhdl)) THEN
	DFF_inst10 <= new_table;
END IF;
END PROCESS;


PROCESS(clock_vhdl)
BEGIN
IF (RISING_EDGE(clock_vhdl)) THEN
	new_table_clkvhdl <= DFF_inst10;
END IF;
END PROCESS;

data_wr_inv(7 DOWNTO 0) <= data_wr(31 DOWNTO 24);


data_wr_inv(15 DOWNTO 8) <= data_wr(23 DOWNTO 16);


data_wr_inv(23 DOWNTO 16) <= data_wr(15 DOWNTO 8);


data_wr_inv(31 DOWNTO 24) <= data_wr(7 DOWNTO 0);



PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	DFF_inst16 <= busy;
END IF;
END PROCESS;


PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	busy_clk <= DFF_inst16;
END IF;
END PROCESS;


PROCESS(clock_vhdl)
BEGIN
IF (RISING_EDGE(clock_vhdl)) THEN
	info_a(7 DOWNTO 0) <= info(7 DOWNTO 0);
END IF;
END PROCESS;


PROCESS(clock_vhdl)
BEGIN
IF (RISING_EDGE(clock_vhdl)) THEN
	info_out(7 DOWNTO 0) <= info_a(7 DOWNTO 0);
END IF;
END PROCESS;


SYNTHESIZED_WIRE_0 <= NOT(clk);



PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	valid_fram <= en_w;
END IF;
END PROCESS;


b2v_inst4 : txdata_tovhdl
PORT MAP(IN_CLOCK => clock_vhdl,
		 IN_nRESET => in_Nreset,
		 IN_NEWTABLE => new_table_clkvhdl,
		 OUT_EN_RD => en_rd,
		 OUT_START_RD => start_rd,
		 OUT_REQRDY => reqrdy,
		 OUT_BUSY => busy,
		 OUT_ADR_RD => adr_rd);


SYNTHESIZED_WIRE_1 <= NOT(clock_vhdl);



PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	DFF_inst6 <= reqrdy;
END IF;
END PROCESS;


PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	reqrdy_clk <= DFF_inst6;
END IF;
END PROCESS;


PROCESS(clock_vhdl)
BEGIN
IF (RISING_EDGE(clock_vhdl)) THEN
	out_sync <= start_rd;
END IF;
END PROCESS;


PROCESS(clock_vhdl)
BEGIN
IF (RISING_EDGE(clock_vhdl)) THEN
	out_valid <= en_rd;
END IF;
END PROCESS;


END bdf_type;