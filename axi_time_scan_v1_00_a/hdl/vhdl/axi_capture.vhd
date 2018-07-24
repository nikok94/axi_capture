------------------------------------------------------------------------------
-- axi_capture.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          axi_capture.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Sat Jul 21 11:39:26 2018 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

library axi_time_scan_v1_00_a;
use axi_time_scan_v1_00_a.async_fifo_128;

library axi_time_scan_v1_00_a;
use axi_time_scan_v1_00_a.psync;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity axi_capture is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    C_M_AXI_LITE_ADDR_WIDTH : INTEGER range 32 to 32 := 32;  
    C_M_AXI_LITE_DATA_WIDTH : INTEGER range 32 to 32 := 32;  
    
    C_CAPT_AXI_DATA_WIDTH             : integer              := 32;
    C_CAPT_AXI_ADDR_WIDTH             : integer              := 32;
    C_CAPT_AXI_ID_WIDTH               : integer              := 4;
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 3;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
  
    -- ADD USER PORTS BELOW THIS LINE ------------------
    CAPT_AXI_ACLK                     : in  std_logic;
    CAPT_AXI_ARESETN                  : in  std_logic;
    CAPT_AXI_AWADDR                   : in  std_logic_vector(C_CAPT_AXI_ADDR_WIDTH-1 downto 0);
    CAPT_AXI_AWVALID                  : in  std_logic;
    CAPT_AXI_AWREADY                  : in std_logic;

    CAPT_AXI_WDATA                    : in  std_logic_vector(C_CAPT_AXI_DATA_WIDTH-1 downto 0);
    CAPT_AXI_WSTRB                    : in  std_logic_vector((C_CAPT_AXI_DATA_WIDTH/8)-1 downto 0);
    CAPT_AXI_WVALID                   : in  std_logic;
    CAPT_AXI_BREADY                   : in  std_logic;
    CAPT_AXI_ARADDR                   : in  std_logic_vector(C_CAPT_AXI_ADDR_WIDTH-1 downto 0);
    CAPT_AXI_ARVALID                  : in  std_logic;
    CAPT_AXI_RREADY                   : in  std_logic;
    CAPT_AXI_ARREADY                  : in std_logic;
    CAPT_AXI_RDATA                    : in std_logic_vector(C_CAPT_AXI_DATA_WIDTH-1 downto 0);
    CAPT_AXI_RRESP                    : in std_logic_vector(1 downto 0);
    CAPT_AXI_RVALID                   : in std_logic;
    CAPT_AXI_WREADY                   : in std_logic;
    CAPT_AXI_BRESP                    : in std_logic_vector(1 downto 0);
    CAPT_AXI_BVALID                   : in std_logic;

    CAPT_AXI_AWID                     : in  std_logic_vector(C_CAPT_AXI_ID_WIDTH-1 downto 0);
    CAPT_AXI_AWLEN                    : in  std_logic_vector(7 downto 0);
    CAPT_AXI_AWSIZE                   : in  std_logic_vector(2 downto 0);
    CAPT_AXI_AWBURST                  : in  std_logic_vector(1 downto 0);
    CAPT_AXI_AWLOCK                   : in  std_logic;
    CAPT_AXI_AWCACHE                  : in  std_logic_vector(3 downto 0);
    CAPT_AXI_AWPROT                   : in  std_logic_vector(2 downto 0);
    CAPT_AXI_WLAST                    : in  std_logic;
    CAPT_AXI_BID                      : in std_logic_vector(C_CAPT_AXI_ID_WIDTH-1 downto 0);
    CAPT_AXI_ARID                     : in  std_logic_vector(C_CAPT_AXI_ID_WIDTH-1 downto 0);
    CAPT_AXI_ARLEN                    : in  std_logic_vector(7 downto 0);
    CAPT_AXI_ARSIZE                   : in  std_logic_vector(2 downto 0);
    CAPT_AXI_ARBURST                  : in  std_logic_vector(1 downto 0);
    CAPT_AXI_ARLOCK                   : in  std_logic;
    CAPT_AXI_ARCACHE                  : in  std_logic_vector(3 downto 0);
    CAPT_AXI_ARPROT                   : in  std_logic_vector(2 downto 0);
    CAPT_AXI_RID                      : in std_logic_vector(C_CAPT_AXI_ID_WIDTH-1 downto 0);
    CAPT_AXI_RLAST                    : in std_logic;
    
    TIME_AXIS_TLAST                   : in std_logic;
    TIME_AXIS_TDATA                   : in std_logic_vector(63 downto 0);
    TIME_AXIS_TVALID                  : in std_logic;
    time_axis_aclk                    : in std_logic;

    -- signal for AXI Lite master IPIF
--    m_axi_aclk                        : in std_logic;
--    ip2bus_mstwr_req                  : in std_logic;
--    bus2ip_mst_cmdack                 : in std_logic;
--    bus2ip_mst_cmplt                  : in std_logic;
--    ip2bus_mstwr_d                    : in std_logic_vector(C_M_AXI_LITE_DATA_WIDTH-1 downto 0);
--    ip2bus_mst_addr                   : in std_logic_vector(C_M_AXI_LITE_ADDR_WIDTH-1 downto 0);
    AXIS_CAPT2DMA_ACLK                : in std_logic;
    AXIS_CAPT2DMA_TREADY              : in std_logic;
    AXIS_CAPT2DMA_TDATA               : out std_logic_vector(31 downto 0);
    AXIS_CAPT2DMA_TKEEP               : out std_logic_vector(32/8-1 downto 0);
    AXIS_CAPT2DMA_TVALID              : out std_logic;
    AXIS_CAPT2DMA_TLAST               : out std_logic;
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                        : in  std_logic;
    Bus2IP_Resetn                     : in  std_logic;
    Bus2IP_Data                       : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                         : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                       : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                       : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                       : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                      : out std_logic;
    IP2Bus_WrAck                      : out std_logic;
    
    INTR_out                          : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity axi_capture;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of axi_capture is

  type capt_state_machine      is (capture_axi, send_rd_tr, send_wr_tr);
  signal state, next_state                    : capt_state_machine;

  signal capture_wr_tr                        : std_logic;
  signal capture_rd_tr                        : std_logic;
  
  signal data_wr_capt                   : std_logic_vector(127 downto 0);
  signal data_rd_capt                   : std_logic_vector(127 downto 0);

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal status_reg                  : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal number_axi_rd_wr               : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal cntrl_reg                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg_write_sel              : std_logic_vector(2 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(2 downto 0);
  signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;
  signal fifo_wr_en_o                   : std_logic;
  signal fifo_din                       : std_logic_vector(127 downto 0);
  signal fifo_din_o                     : std_logic_vector(127 downto 0);
  signal fifo_wr_en                     : std_logic;
  signal fifo_rd_en                     : std_logic;
  signal fifo_dout                      : std_logic_vector(31 downto 0);
  signal fifo_full                      : std_logic;
  signal fifo_empty                     : std_logic;
  signal fifo_valid                     : std_logic;
  signal wr_dbg_allow                   : std_logic;
  signal rd_dbg_allow                   : std_logic;
  signal fifo_rst                       : std_logic;
  signal rd_wr_tr_counter               : std_logic_vector(31 downto 0);
  signal start_bit_cntr_reg_d           : std_logic;
  signal start_bit_cntr_reg             : std_logic;
  signal start                          : std_logic;
  signal busy                           : std_logic;
  signal complete                       : std_logic;
  signal tr_counter_equally             : std_logic;
  signal tr_counter_equally_d           : std_logic;
  signal complete_i                     : std_logic;
  signal fifo_rst_d                     : std_logic;
  signal time_data_i                    : std_logic_vector(63 downto 0);
  signal time_data                      : std_logic_vector(63 downto 0);
  signal time_tvalid_i                  : std_logic;
  signal time_tvalid                    : std_logic;

begin
  label1: 
  for i in 0 to 63 generate
   begin
   sync_time_data : entity axi_time_scan_v1_00_a.psync
   generic map(
      -- true for synchronous reset type or false for asynchronous one
      i_sync_rst => false,                           -- master clock reset type
      o_sync_rst => false                            -- slave clock reset type
   )
   port map(
      ri => '0',                                       -- master reset input
      ro => '0',                                       -- slave reset input
      ci => time_axis_aclk,                            -- master clock input
      co => CAPT_AXI_ACLK,                             -- slave clock input
      i  => TIME_AXIS_TDATA(i),                        -- pulse input
      o  => time_data_i(i)                             -- pulse output
   );
  end generate;

  time_data <= time_data_i + 4;
  
  sync_time_valid : entity axi_time_scan_v1_00_a.psync
   generic map(
      -- true for synchronous reset type or false for asynchronous one
      i_sync_rst => false,                           -- master clock reset type
      o_sync_rst => false                            -- slave clock reset type
   )
   port map(
      ri => '0',                                       -- master reset input
      ro => '0',                                       -- slave reset input
      ci => time_axis_aclk,                            -- master clock input
      co => CAPT_AXI_ACLK,                             -- slave clock input
      i  => TIME_AXIS_TVALID,                        -- pulse input
      o  => time_tvalid_i                             -- pulse output
   );
  time_tvalid <= time_tvalid_i;
  
  wr_dbg_allow              <= cntrl_reg(0);
  rd_dbg_allow              <= cntrl_reg(1);
  start_bit_cntr_reg        <= cntrl_reg(2);
  fifo_rst                  <= cntrl_reg(3);

  status_reg(0)             <= fifo_empty;
  status_reg(1)             <= fifo_full;
  status_reg(2)             <= busy;
  status_reg(3)             <= complete;
  status_reg(31 downto 4)   <= (others => '0');
  
  INTR_out                  <= tr_counter_equally;
  
  complete_i                <= tr_counter_equally and busy;
  
  COUNTER_EQUALLYTY_PROCC   : process (CAPT_AXI_ACLK)
  begin
    if rising_edge(CAPT_AXI_ACLK) then
      if (rd_wr_tr_counter = number_axi_rd_wr) then
        tr_counter_equally <= '1';
      else
        tr_counter_equally <= '0';
      end if;
    end if;
  end process;

  fifo_rd_en <= AXIS_CAPT2DMA_TREADY;
  AXIS_CAPT2DMA_TDATA <= fifo_dout;
  AXIS_CAPT2DMA_TKEEP <= (others => '1');
  AXIS_CAPT2DMA_TVALID <= fifo_valid;
  AXIS_CAPT2DMA_TLAST <= '0';

  START_PROCC   : process (CAPT_AXI_ACLK)
  begin
    if rising_edge(CAPT_AXI_ACLK) then
      if (CAPT_AXI_ARESETN = '0' or time_tvalid = '0') then
        start_bit_cntr_reg_d <= '0';
        tr_counter_equally_d <= '0';
        fifo_rst_d           <= '0';
        else
        fifo_rst_d           <= fifo_rst;
        start_bit_cntr_reg_d <= start_bit_cntr_reg;
        tr_counter_equally_d <= tr_counter_equally;
        start   <= (not start_bit_cntr_reg_d) and start_bit_cntr_reg;
      end if;
    end if;
  end process START_PROCC;
  
  COMPLETE_PROCC    : process (CAPT_AXI_ACLK)
    begin 
    if rising_edge(CAPT_AXI_ACLK) then
      if (CAPT_AXI_ARESETN = '0') or (start = '1') then
        complete <= '0';
      elsif complete_i = '1' then
        complete <= '1';
      end if;
    end if;
  end process COMPLETE_PROCC;
  
  

  BUSY_PROCESS     : process (CAPT_AXI_ACLK)
  begin 
    if rising_edge(CAPT_AXI_ACLK) then
      if (CAPT_AXI_ARESETN = '0') or (tr_counter_equally = '1') then
        busy <= '0';
      elsif start = '1' then
        busy <= '1';
      end if;
    end if;
  end process BUSY_PROCESS;

  ASYNC_FIFO_INST  : entity axi_time_scan_v1_00_a.async_fifo_128
  port map(
    rst         => fifo_rst_d,
    wr_clk      => capt_axi_aclk,
    rd_clk      => AXIS_CAPT2DMA_ACLK,
    din         => fifo_din,
    wr_en       => fifo_wr_en,
    rd_en       => fifo_rd_en,
    dout        => fifo_dout ,
    full        => fifo_full ,
    empty       => fifo_empty,
    valid       => fifo_valid
  );

    capture_wr_tr <= '1' when ((CAPT_AXI_WVALID = '1') and (CAPT_AXI_WREADY = '1') and (wr_dbg_allow = '1')) else '0';
    capture_rd_tr <= '1' when ((CAPT_AXI_RVALID = '1') and (CAPT_AXI_RREADY = '1') and (rd_dbg_allow = '1')) else '0';
    
    
    
    COUNT_RD_WR_TR_PROCESS  : process (CAPT_AXI_ACLK)
    begin
      if rising_edge(CAPT_AXI_ACLK) then
        if (busy = '0') then 
           rd_wr_tr_counter <= (others => '0');
        elsif ((capture_wr_tr = '1') or (capture_rd_tr = '1')) then
           rd_wr_tr_counter <= rd_wr_tr_counter + 1;
        end if;
      end if;
    end process COUNT_RD_WR_TR_PROCESS;
    
    
    
    
    CAPTURE_WR_AXI_TR_PROC  : process(CAPT_AXI_ACLK)
    begin
      if rising_edge(CAPT_AXI_ACLK) then
        if (busy = '0') then 
           fifo_din_o <= (others => '0');
        elsif (capture_wr_tr = '1') then
           fifo_din_o(31 downto 0) <= x"0000_0001";
           fifo_din_o(63 downto 32) <= CAPT_AXI_AWADDR(31 downto 0);
           fifo_din_o(127 downto 64) <= time_data(63 downto 0);
        elsif (capture_rd_tr = '1') then
           fifo_din_o(31 downto 0) <= x"0000_0003";
           fifo_din_o(63 downto 32) <= CAPT_AXI_ARADDR(31 downto 0);
           fifo_din_o(127 downto 64) <= time_data(63 downto 0);
        end if;
      end if;
    end process CAPTURE_WR_AXI_TR_PROC;

    fifo_din <= fifo_din_o;

    FIFO_WR_EN_GEN_PROC : process (CAPT_AXI_ACLK)
    begin
      if rising_edge(CAPT_AXI_ACLK) then
        if ((capture_wr_tr = '1') or (capture_rd_tr = '1')) and (busy = '1') then
          fifo_wr_en_o <= '1';
        else 
          fifo_wr_en_o <= '0';
        end if;
      end if;
    end process;
    fifo_wr_en <= fifo_wr_en_o;

  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(2 downto 0);
  slv_reg_read_sel  <= Bus2IP_RdCE(2 downto 0);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin
  if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
  cntrl_reg(2) <= '0';
  cntrl_reg(3) <= '0';
    if Bus2IP_Resetn = '0' then
      cntrl_reg <= (0 => '1', 1 => '1',others => '0');
      number_axi_rd_wr <= (0 => '1',others => '0');
    else
      case slv_reg_write_sel is
        when "100" =>
          for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
            if ( Bus2IP_BE(byte_index) = '1' ) then
              number_axi_rd_wr(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
            end if;
          end loop;
        when "010" =>
          for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
            if ( Bus2IP_BE(byte_index) = '1' ) then
              cntrl_reg(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
            end if;
          end loop;
        when others => null;
      end case;
    end if;
  end if;
  end process SLAVE_REG_WRITE_PROC;
  
  

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, status_reg, number_axi_rd_wr, cntrl_reg ) is
  begin

    case slv_reg_read_sel is
      when "100" => slv_ip2bus_data <= number_axi_rd_wr;
      when "010" => slv_ip2bus_data <= cntrl_reg;
      when "001" => slv_ip2bus_data <= status_reg;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack;
  IP2Bus_RdAck <= slv_read_ack;
  

end IMP;


