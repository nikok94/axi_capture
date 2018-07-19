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

library axi_capture_v1_00_a;
use axi_capture_v1_00_a.user_logic;

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
    --USER generics added here
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
    CAPT_AXI_WDATA                    : in  std_logic_vector(C_CAPT_AXI_DATA_WIDTH-1 downto 0);
    CAPT_AXI_WSTRB                    : in  std_logic_vector((C_CAPT_AXI_DATA_WIDTH/8)-1 downto 0);
    CAPT_AXI_WVALID                   : in  std_logic;
    CAPT_AXI_BREADY                   : in  std_logic;
    CAPT_AXI_ARADDR                   : in  std_logic_vector(C_CAPT_AXI_ADDR_WIDTH-1 downto 0);
    CAPT_AXI_ARVALID                  : in  std_logic;
    CAPT_AXI_RREADY                   : in  std_logic;
    CAPT_AXI_ARREADY                  : out std_logic;
    CAPT_AXI_RDATA                    : out std_logic_vector(C_CAPT_AXI_DATA_WIDTH-1 downto 0);
    CAPT_AXI_RRESP                    : out std_logic_vector(1 downto 0);
    CAPT_AXI_RVALID                   : out std_logic;
    CAPT_AXI_WREADY                   : out std_logic;
    CAPT_AXI_BRESP                    : out std_logic_vector(1 downto 0);
    CAPT_AXI_BVALID                   : out std_logic;
    CAPT_AXI_AWREADY                  : out std_logic;
    CAPT_AXI_AWID                     : in  std_logic_vector(C_CAPT_AXI_ID_WIDTH-1 downto 0);
    CAPT_AXI_AWLEN                    : in  std_logic_vector(7 downto 0);
    CAPT_AXI_AWSIZE                   : in  std_logic_vector(2 downto 0);
    CAPT_AXI_AWBURST                  : in  std_logic_vector(1 downto 0);
    CAPT_AXI_AWLOCK                   : in  std_logic;
    CAPT_AXI_AWCACHE                  : in  std_logic_vector(3 downto 0);
    CAPT_AXI_AWPROT                   : in  std_logic_vector(2 downto 0);
    CAPT_AXI_WLAST                    : in  std_logic;
    CAPT_AXI_BID                      : out std_logic_vector(C_CAPT_AXI_ID_WIDTH-1 downto 0);
    CAPT_AXI_ARID                     : in  std_logic_vector(C_CAPT_AXI_ID_WIDTH-1 downto 0);
    CAPT_AXI_ARLEN                    : in  std_logic_vector(7 downto 0);
    CAPT_AXI_ARSIZE                   : in  std_logic_vector(2 downto 0);
    CAPT_AXI_ARBURST                  : in  std_logic_vector(1 downto 0);
    CAPT_AXI_ARLOCK                   : in  std_logic;
    CAPT_AXI_ARCACHE                  : in  std_logic_vector(3 downto 0);
    CAPT_AXI_ARPROT                   : in  std_logic_vector(2 downto 0);
    CAPT_AXI_RID                      : out std_logic_vector(C_CAPT_AXI_ID_WIDTH-1 downto 0);
    CAPT_AXI_RLAST                    : out std_logic;
    
    AXIS_DMA_TDATA                    : out std_logic_vector(C_AXIS_DMA_TDATA_WIDTH-1 downto 0);
    AXIS_DMA_TKEEP                    : out std_logic_vector((C_AXIS_DMA_TDATA_WIDTH/8)-1 downto 0);
    AXIS_DMA_TLAST                    : out std_logic;
    AXIS_DMA_TUSER                    : out std_logic_vector(3 downto 0);
    AXIS_DMA_TVALID                   : out std_logic;
    AXIS_DMA_TREADY                   : in  std_logic;
    AXIS_DMA_TID                      : out std_logic_vector(4 downto 0);
    AXIS_DMA_TDEST                    : out std_logic_vector(4 downto 0);
    
    TIME_AXIS_TLAST                   : out std_logic;
    TIME_AXIS_TDATA                   : out std_logic_vector(63 downto 0);
    TIME_AXIS_TVALID                  : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;
  attribute MAX_FANOUT of CAPT_AXI_ACLK       : signal is "10000";
  attribute MAX_FANOUT of CAPT_AXI_ARESETN       : signal is "10000";
  attribute SIGIS of CAPT_AXI_ACLK       : signal is "Clk";
  attribute SIGIS of CAPT_AXI_ARESETN       : signal is "Rst";
end entity axi_capture;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of axi_capture is


begin


end IMP;
