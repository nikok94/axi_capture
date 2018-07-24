------------------------------------------------------------------------------
-- axi_capture.vhd - entity/architecture pair
------------------------------------------------------------------------------
-- IMPORTANT:
-- DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
--
-- SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
--
-- TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
-- PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
-- OF THE USER_LOGIC ENTITY.
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
-- Description:       Top level design, instantiates library components and user logic.
-- Date:              Thu Jul 19 15:54:53 2018 (by Create and Import Peripheral Wizard)
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.ipif_pkg.all;

library axi_slave_burst_v1_00_a;
use axi_slave_burst_v1_00_a.axi_slave_burst;



------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_CAPT_AXI_DATA_WIDTH           -- AXI4 slave: Data Width
--   C_CAPT_AXI_ADDR_WIDTH           -- AXI4 slave: Address Width
--   C_CAPT_AXI_ID_WIDTH             -- AXI4 slave: ID Width
--   C_RDATA_FIFO_DEPTH           -- AXI4 slave: FIFO Depth
--   C_INCLUDE_TIMEOUT_CNT        -- AXI4 slave: Data Timeout Count
--   C_TIMEOUT_CNTR_VAL           -- AXI4 slave: Timeout Counter Value
--   C_ALIGN_BE_RDADDR            -- AXI4 slave: Align Byte Enable read Data Address
--   C_CAPT_AXI_SUPPORTS_WRITE       -- AXI4 slave: Support Write
--   C_CAPT_AXI_SUPPORTS_READ        -- AXI4 slave: Support Read
--   C_FAMILY                     -- FPGA Family
--   C_CAPT_AXI_MEM0_BASEADDR        -- User memory space 0 base address
--   C_CAPT_AXI_MEM0_HIGHADDR        -- User memory space 0 high address
--
-- Definition of Ports:
--   CAPT_AXI_ACLK                   -- AXI4 slave: Clock
--   CAPT_AXI_ARESETN                -- AXI4 slave: Reset
--   CAPT_AXI_AWADDR                 -- AXI4 slave: Write address
--   CAPT_AXI_AWVALID                -- AXI4 slave: Write address valid
--   CAPT_AXI_WDATA                  -- AXI4 slave: Write data
--   CAPT_AXI_WSTRB                  -- AXI4 slave: Write strobe
--   CAPT_AXI_WVALID                 -- AXI4 slave: Write data valid
--   CAPT_AXI_BREADY                 -- AXI4 slave: read response ready
--   CAPT_AXI_ARADDR                 -- AXI4 slave: read address
--   CAPT_AXI_ARVALID                -- AXI4 slave: read address valid
--   CAPT_AXI_RREADY                 -- AXI4 slave: read data ready
--   CAPT_AXI_ARREADY                -- AXI4 slave: read address ready
--   CAPT_AXI_RDATA                  -- AXI4 slave: read data
--   CAPT_AXI_RRESP                  -- AXI4 slave: read data response
--   CAPT_AXI_RVALID                 -- AXI4 slave: read data valid
--   CAPT_AXI_WREADY                 -- AXI4 slave: write data ready
--   CAPT_AXI_BRESP                  -- AXI4 slave: read response
--   CAPT_AXI_BVALID                 -- AXI4 slave: read response valid
--   CAPT_AXI_AWREADY                -- AXI4 slave: write address ready
--   CAPT_AXI_AWID                   -- AXI4 slave: write address ID
--   CAPT_AXI_AWLEN                  -- AXI4 slave: write address Length
--   CAPT_AXI_AWSIZE                 -- AXI4 slave: write address size
--   CAPT_AXI_AWBURST                -- AXI4 slave: write address burst
--   CAPT_AXI_AWLOCK                 -- AXI4 slave: write address lock
--   CAPT_AXI_AWCACHE                -- AXI4 slave: write address cache
--   CAPT_AXI_AWPROT                 -- AXI4 slave: write address protection
--   CAPT_AXI_WLAST                  -- AXI4 slave: write data last
--   CAPT_AXI_BID                    -- AXI4 slave: read response ID
--   CAPT_AXI_ARID                   -- AXI4 slave: read address ID
--   CAPT_AXI_ARLEN                  -- AXI4 slave: read address Length
--   CAPT_AXI_ARSIZE                 -- AXI4 slave: read address size
--   CAPT_AXI_ARBURST                -- AXI4 slave: read address burst
--   CAPT_AXI_ARLOCK                 -- AXI4 slave: read address lock
--   CAPT_AXI_ARCACHE                -- AXI4 slave: read address cache
--   CAPT_AXI_ARPROT                 -- AXI4 slave: read address protection
--   CAPT_AXI_RID                    -- AXI4 slave: read data ID
--   CAPT_AXI_RLAST                  -- AXI4 slave: read data last
------------------------------------------------------------------------------

entity axi_capture is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    C_NUM_REG                      : integer              := 6;
    C_SLV_DWIDTH                   : integer              := 32
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_AXIS_DMA_TDATA_WIDTH            : integer              := 32;
    C_CAPT_AXI_DATA_WIDTH             : integer              := 32;
    C_CAPT_AXI_ADDR_WIDTH             : integer              := 32;
    C_CAPT_AXI_ID_WIDTH               : integer              := 4;
    C_RDATA_FIFO_DEPTH                : integer              := 0;
    C_INCLUDE_TIMEOUT_CNT             : integer              := 1;
    C_TIMEOUT_CNTR_VAL                : integer              := 8;
    C_ALIGN_BE_RDADDR                 : integer              := 0;
    C_CAPT_AXI_SUPPORTS_WRITE         : integer              := 1;
    C_CAPT_AXI_SUPPORTS_READ          : integer              := 1;
    C_FAMILY                          : string               := "virtex6";
    C_CAPT_AXI_MEM0_BASEADDR          : std_logic_vector     := X"FFFFFFFF";
    C_CAPT_AXI_MEM0_HIGHADDR          : std_logic_vector     := X"00000000"
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
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
    
    AXIS_DMA_TDATA                    : out std_logic_vector(C_AXIS_DMA_TDATA_WIDTH-1 downto 0);
    AXIS_DMA_TKEEP                    : out std_logic_vector((C_AXIS_DMA_TDATA_WIDTH/8)-1 downto 0);
    AXIS_DMA_TLAST                    : out std_logic;
    AXIS_DMA_TUSER                    : out std_logic_vector(3 downto 0);
    AXIS_DMA_TVALID                   : out std_logic;
    AXIS_DMA_TREADY                   : in  std_logic;
    AXIS_DMA_TID                      : out std_logic_vector(4 downto 0);
    AXIS_DMA_TDEST                    : out std_logic_vector(4 downto 0);
    
    TIME_AXIS_TLAST                   : in std_logic;
    TIME_AXIS_TDATA                   : in std_logic_vector(63 downto 0);
    TIME_AXIS_TVALID                  : in std_logic;
    
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
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
    signal DDR_base_addr                 : std_logic_vector(C_SLV_DWIDTH-1 downto 0):= (others=>'0');
    signal init_time_63_32                : std_logic_vector(C_SLV_DWIDTH-1 downto 0):= (others=>'0');
    signal contr_reg                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    signal slv_reg3                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    signal slv_reg4                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    signal slv_reg5                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    signal slv_reg_write_sel              : std_logic_vector(5 downto 0);
    signal slv_reg_read_sel               : std_logic_vector(5 downto 0);
    signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    signal slv_read_ack                   : std_logic;
    signal slv_write_ack                  : std_logic;
    
    
    type capt_state_machine is (capture_axi, send_wr_tr_dma, send_wr_rd_dma);
    signal state, next_state    : capt_state_machine;

    signal capture_wr_tr                        : std_logic;
    signal capture_rd_tr                        : std_logic;
    
    signal DMA_data_wr_capt                  : std_logic_vector(C_AXIS_DMA_TDATA_WIDTH-1 downto 0);
    signal DMA_data_rd_capt                  : std_logic_vector(C_AXIS_DMA_TDATA_WIDTH-1 downto 0);
    
    signal axis_dma_tdata_o                    : std_logic_vector(C_AXIS_DMA_TDATA_WIDTH-1 downto 0);
    signal axis_dma_tkeep_o                    : std_logic_vector((C_AXIS_DMA_TDATA_WIDTH/8)-1 downto 0);
    signal axis_dma_tlast_o                    : std_logic;
    signal axis_dma_tuser_o                    : std_logic_vector(3 downto 0);
    signal axis_dma_tvalid_o                   : std_logic;
    signal axis_dma_tid_o                      : std_logic_vector(4 downto 0);
    signal axis_dma_tdest_o                    : std_logic_vector(4 downto 0);


begin

    capture_wr_tr <= '1' when ((CAPT_AXI_WVALID = '1') and (CAPT_AXI_WREADY = '1')) else '0';
    capture_rd_tr <= '1' when ((CAPT_AXI_RVALID = '1') and (CAPT_AXI_RREADY = '1')) else '0';
    
    CAPTURE_WR_AXI_TR_PROC  : process(CAPT_AXI_ACLK)
    begin
      if rising_edge(CAPT_AXI_ACLK) then
        if (TIME_AXIS_TVALID = '0') then 
           DMA_data_wr_capt <= (others => '0');
        elsif (capture_wr_tr = '1') then
           DMA_data_wr_capt(63 downto 0) <= TIME_AXIS_TDATA;
           DMA_data_wr_capt(95 downto 64) <= CAPT_AXI_AWADDR;
           DMA_data_wr_capt(127 dowto 96) <= x"0000_0001";
        elsif (capture_rd_tr = '1') then
           DMA_data_rd_capt(63 downto 0) <= TIME_AXIS_TDATA;
           DMA_data_rd_capt(95 downto 64) <= CAPT_AXI_ARADDR;
           DMA_data_rd_capt(127 dowto 96) <= x"0000_0003";
        else 
           DMA_data_wr_capt <= DMA_data_wr_capt;
           DMA_data_rd_capt <= DMA_data_rd_capt;
        end if;
      end if;
    end process CAPTURE_WR_AXI_TR_PROC;
-------------------------------------------------
--  FSM 
-------------------------------------------------
  SYNC_ST_MCHN_PROC   :   process (CAPT_AXI_ACLK)
    begin
      if rising_edge(CAPT_AXI_ACLK) then
        if TIME_AXIS_TVALID = '0' then
          AXIS_DMA_TDATA    <= (others => '0');
          AXIS_DMA_TKEEP    <= (others => '0');
          AXIS_DMA_TLAST    <= '0';
          AXIS_DMA_TUSER    <= (others => '0');
          AXIS_DMA_TVALID   <= '0';
          AXIS_DMA_TID      <= (others => '0');
          AXIS_DMA_TDEST    <= (others => '0');
        else 
          state <= next_state;
          AXIS_DMA_TDATA <= axis_dma_tdata_o ;
          AXIS_DMA_TKEEP <= axis_dma_tkeep_o ;
          AXIS_DMA_TLAST <= axis_dma_tlast_o ;
          AXIS_DMA_TUSER <= axis_dma_tuser_o ;
          AXIS_DMA_TVALID<= axis_dma_tvalid_o;
          AXIS_DMA_TID   <= axis_dma_tid_o   ;
          AXIS_DMA_TDEST <= axis_dma_tdest_o ;
        end if;
      end if;
    end process SYNC_ST_MCHN_PROC;
    
  OUTPUT_DECODE     : process (state)
    begin
    axis_dma_tdata_o  <= (others => '0');
    axis_dma_tvalid_o <= '0';
    axis_dma_tlast_o  <= '0';
    axis_dma_tkeep_o  <= (others => '0');
    axis_dma_tuser_o  <= (others => '0');
    axis_dma_tid_o    <= (others => '0');
    axis_dma_tdest_o  <= (others => '0');
     case state is
        when send_wr_tr_dma => 
         axis_dma_tdata_o  <= DMA_data_wr_capt;
         axis_dma_tvalid_o <= '1';
         axis_dma_tkeep_o  <= (others => '1');
        when send_rd_tr_dma => 
         axis_dma_tdata_o  <= DMA_data_rd_capt;
         axis_dma_tvalid_o <= '1';
         axis_dma_tkeep_o  <= (others => '1');
        when others =>
         axis_dma_tvalid_o <= '0';
     end case;
    end process OUTPUT_DECODE;
    
  NEXT_STATE_DECODE : process (state, TIME_AXIS_TVALID, capture_wr_tr, capture_rd_tr)
    begin
     next_state <= state;
       case state is
          when capture_axi =>
          if ((TIME_AXIS_TVALID = '1') and (capture_wr_tr = '1')) then
          next_state <= send_wr_tr_dma;
          elsif ((TIME_AXIS_TVALID = '1') and (capture_rd_tr = '1')) then
          next_state <= send_rd_tr_dma;
          end if;
          when send_wr_tr_dma =>
          if capture_wr_tr = '1' then
          next_state <= capture_axi;
          end if;
          when send_rd_tr_dma =>
          if capture_rd_tr = '1' then
          next_state <= capture_axi;
          end if;
          when others => 
          next_state <= capture_wr_tr;
          end case;
    end process NEXT_STATE_DECODE;

     slv_reg_write_sel <= Bus2IP_WrCE(5 downto 0);
  slv_reg_read_sel  <= Bus2IP_RdCE(5 downto 0);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Resetn = '0' then
        DDR_base_addr <= (others => '0');
        init_time_63_32 <= (others => '0');
        contr_reg <= (others => '0');
        slv_reg3 <= (others => '0');
        slv_reg4 <= (others => '0');
        slv_reg5 <= (others => '0');
      else
        case slv_reg_write_sel is
          when "100000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                DDR_base_addr(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "010000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                init_time_63_32(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "001000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                contr_reg(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000100" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg3(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000010" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg4(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000001" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg5(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, DDR_base_addr, init_time_63_32, contr_reg, slv_reg3, slv_reg4, slv_reg5 ) is
  begin

    case slv_reg_read_sel is
      when "100000" => slv_ip2bus_data <= DDR_base_addr;
      when "010000" => slv_ip2bus_data <= init_time_63_32;
      when "001000" => slv_ip2bus_data <= contr_reg;
      when "000100" => slv_ip2bus_data <= slv_reg3;
      when "000010" => slv_ip2bus_data <= slv_reg4;
      when "000001" => slv_ip2bus_data <= slv_reg5;
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
  IP2Bus_Error <= '0';

end IMP;
