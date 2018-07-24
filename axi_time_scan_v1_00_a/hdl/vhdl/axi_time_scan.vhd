------------------------------------------------------------------------------
-- axi_time_scan.vhd - entity/architecture pair
------------------------------------------------------------------------------
-- IMPORTANT:
-- DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
--
-- SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
--
-- TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
-- PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
-- OF THE axi_capture ENTITY.
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
-- Filename:          axi_time_scan.vhd
-- Version:           1.00.a
-- Description:       Top level design, instantiates library components and user logic.
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.ipif_pkg.all;

library axi_lite_ipif_v1_01_a;
use axi_lite_ipif_v1_01_a.axi_lite_ipif;

library axi_time_scan_v1_00_a;
use axi_time_scan_v1_00_a.axi_capture;


------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_S_AXI_DATA_WIDTH           -- AXI4LITE slave: Data width
--   C_S_AXI_ADDR_WIDTH           -- AXI4LITE slave: Address Width
--   C_S_AXI_MIN_SIZE             -- AXI4LITE slave: Min Size
--   C_USE_WSTRB                  -- AXI4LITE slave: Write Strobe
--   C_DPHASE_TIMEOUT             -- AXI4LITE slave: Data Phase Timeout
--   C_BASEADDR                   -- AXI4LITE slave: base address
--   C_HIGHADDR                   -- AXI4LITE slave: high address
--   C_FAMILY                     -- FPGA Family
--   C_NUM_REG                    -- Number of software accessible registers
--   C_NUM_MEM                    -- Number of address-ranges
--   C_SLV_AWIDTH                 -- Slave interface address bus width
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   S_AXI_ACLK                   -- AXI4LITE slave: Clock 
--   S_AXI_ARESETN                -- AXI4LITE slave: Reset
--   S_AXI_AWADDR                 -- AXI4LITE slave: Write address
--   S_AXI_AWVALID                -- AXI4LITE slave: Write address valid
--   S_AXI_WDATA                  -- AXI4LITE slave: Write data
--   S_AXI_WSTRB                  -- AXI4LITE slave: Write strobe
--   S_AXI_WVALID                 -- AXI4LITE slave: Write data valid
--   S_AXI_BREADY                 -- AXI4LITE slave: Response ready
--   S_AXI_ARADDR                 -- AXI4LITE slave: Read address
--   S_AXI_ARVALID                -- AXI4LITE slave: Read address valid
--   S_AXI_RREADY                 -- AXI4LITE slave: Read data ready
--   S_AXI_ARREADY                -- AXI4LITE slave: read addres ready
--   S_AXI_RDATA                  -- AXI4LITE slave: Read data
--   S_AXI_RRESP                  -- AXI4LITE slave: Read data response
--   S_AXI_RVALID                 -- AXI4LITE slave: Read data valid
--   S_AXI_WREADY                 -- AXI4LITE slave: Write data ready
--   S_AXI_BRESP                  -- AXI4LITE slave: Response
--   S_AXI_BVALID                 -- AXI4LITE slave: Resonse valid
--   S_AXI_AWREADY                -- AXI4LITE slave: Wrte address ready
------------------------------------------------------------------------------

entity axi_time_scan is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
   C_M_AXI_LITE_ADDR_WIDTH : INTEGER range 32 to 32 := 32;  
   C_M_AXI_LITE_DATA_WIDTH : INTEGER range 32 to 32 := 32;  
   C_FAMILY                : String := "virtex6";
   C_CAPT_AXI_DATA_WIDTH             : integer              := 32;
   C_CAPT_AXI_ADDR_WIDTH             : integer              := 32;
   C_CAPT_AXI_ID_WIDTH               : integer              := 4;
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_MIN_SIZE               : std_logic_vector     := X"000001FF";
    C_USE_WSTRB                    : integer              := 0;
    C_DPHASE_TIMEOUT               : integer              := 8;
    C_BASEADDR                     : std_logic_vector     := X"FFFFFFFF";
    C_HIGHADDR                     : std_logic_vector     := X"00000000";
    C_NUM_REG                      : integer              := 1;
    C_NUM_MEM                      : integer              := 1;
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
--    M_AXI_LITE_ACLK                     : in  std_logic;
--    M_AXI_LITE_ARESETN                  : in  std_logic;
--    M_AXI_LITE_ARREADY             : in  std_logic;
--    M_AXI_LITE_ARVALID             : out std_logic;
--    M_AXI_LITE_ARADDR              : out std_logic_vector(C_M_AXI_LITE_ADDR_WIDTH-1 downto 0);
--    M_AXI_LITE_ARPROT              : out std_logic_vector(2 downto 0);
--    M_AXI_LITE_RREADY              : out std_logic;
--    M_AXI_LITE_RVALID              : in  std_logic;
--    M_AXI_LITE_RDATA               : in  std_logic_vector(C_M_AXI_LITE_DATA_WIDTH-1 downto 0);
--    M_AXI_LITE_RRESP               : in  std_logic_vector(1 downto 0);
--    M_AXI_LITE_AWREADY             : in  std_logic;
--    M_AXI_LITE_AWVALID             : out std_logic;
--    M_AXI_LITE_AWADDR              : out std_logic_vector(C_M_AXI_LITE_ADDR_WIDTH-1 downto 0);
--    M_AXI_LITE_AWPROT              : out std_logic_vector(2 downto 0);
--    M_AXI_LITE_WREADY              : in  std_logic;
--    M_AXI_LITE_WVALID              : out std_logic;
--    M_AXI_LITE_WDATA               : out std_logic_vector(C_M_AXI_LITE_DATA_WIDTH-1 downto 0);
--    M_AXI_LITE_WSTRB               : out std_logic_vector((C_M_AXI_LITE_DATA_WIDTH/8)-1 downto 0);
--    M_AXI_LITE_BREADY              : out std_logic;
--    M_AXI_LITE_BVALID              : in  std_logic;
--    M_AXI_LITE_BRESP               : in  std_logic_vector(1 downto 0);
    AXIS_CAPT2DMA_ACLK                : in std_logic;
    AXIS_CAPT2DMA_TREADY              : in std_logic;
    AXIS_CAPT2DMA_TDATA               : out std_logic_vector(31 downto 0);
    AXIS_CAPT2DMA_TKEEP               : out std_logic_vector(32/8-1 downto 0);
    AXIS_CAPT2DMA_TVALID              : out std_logic;
    AXIS_CAPT2DMA_TLAST               : out std_logic;
    -- ADD USER PORTS ABOVE THIS LINE ------------------
    
--    CAPT_AXI_ACLK                     : in  std_logic;
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
    
    INTR_out                          : out std_logic;
    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    S_AXI_ACLK                     : in  std_logic;
    S_AXI_ARESETN                  : in  std_logic;
    S_AXI_AWADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID                  : in  std_logic;
    S_AXI_WDATA                    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB                    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID                   : in  std_logic;
    S_AXI_BREADY                   : in  std_logic;
    S_AXI_ARADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID                  : in  std_logic;
    S_AXI_RREADY                   : in  std_logic;
    S_AXI_ARREADY                  : out std_logic;
    S_AXI_RDATA                    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                   : out std_logic;
    S_AXI_WREADY                   : out std_logic;
    S_AXI_BRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                   : out std_logic;
    S_AXI_AWREADY                  : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;
  attribute MAX_FANOUT of S_AXI_ACLK       : signal is "10000";
  attribute MAX_FANOUT of S_AXI_ARESETN       : signal is "10000";
  attribute SIGIS of S_AXI_ACLK       : signal is "Clk";
  attribute SIGIS of S_AXI_ARESETN       : signal is "Rst";
end entity axi_time_scan;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of axi_time_scan is

  constant USER_SLV_DWIDTH                : integer              := C_S_AXI_DATA_WIDTH;

  constant IPIF_SLV_DWIDTH                : integer              := C_S_AXI_DATA_WIDTH;

  constant ZERO_ADDR_PAD                  : std_logic_vector(0 to 31) := (others => '0');
  constant USER_SLV_BASEADDR              : std_logic_vector     := C_BASEADDR;
  constant USER_SLV_HIGHADDR              : std_logic_vector     := C_HIGHADDR;

  constant IPIF_ARD_ADDR_RANGE_ARRAY      : SLV64_ARRAY_TYPE     := 
    (
      ZERO_ADDR_PAD & USER_SLV_BASEADDR,  -- user logic slave space base address
      ZERO_ADDR_PAD & USER_SLV_HIGHADDR   -- user logic slave space high address
    );

  constant USER_SLV_NUM_REG               : integer              := 3;
  constant USER_NUM_REG                   : integer              := USER_SLV_NUM_REG;
  constant TOTAL_IPIF_CE                  : integer              := USER_NUM_REG;

  constant IPIF_ARD_NUM_CE_ARRAY          : INTEGER_ARRAY_TYPE   := 
    (
      0  => (USER_SLV_NUM_REG)            -- number of ce for user logic slave space
    );

  ------------------------------------------
  -- Index for CS/CE
  ------------------------------------------
  constant USER_SLV_CS_INDEX              : integer              := 0;
  constant USER_SLV_CE_INDEX              : integer              := calc_start_ce_index(IPIF_ARD_NUM_CE_ARRAY, USER_SLV_CS_INDEX);

  constant USER_CE_INDEX                  : integer              := USER_SLV_CE_INDEX;

  ------------------------------------------
  -- IP Interconnect (IPIC) signal declarations
  ------------------------------------------
  signal ipif_Bus2IP_Clk                : std_logic;
  signal ipif_Bus2IP_Resetn             : std_logic;
  signal ipif_Bus2IP_Addr               : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal ipif_Bus2IP_RNW                : std_logic;
  signal ipif_Bus2IP_BE                 : std_logic_vector(IPIF_SLV_DWIDTH/8-1 downto 0);
  signal ipif_Bus2IP_CS                 : std_logic_vector((IPIF_ARD_ADDR_RANGE_ARRAY'LENGTH)/2-1 downto 0);
  signal ipif_Bus2IP_RdCE               : std_logic_vector(calc_num_ce(IPIF_ARD_NUM_CE_ARRAY)-1 downto 0);
  signal ipif_Bus2IP_WrCE               : std_logic_vector(calc_num_ce(IPIF_ARD_NUM_CE_ARRAY)-1 downto 0);
  signal ipif_Bus2IP_Data               : std_logic_vector(IPIF_SLV_DWIDTH-1 downto 0);
  signal ipif_IP2Bus_WrAck              : std_logic;
  signal ipif_IP2Bus_RdAck              : std_logic;
  signal ipif_IP2Bus_Error              : std_logic;
  signal ipif_IP2Bus_Data               : std_logic_vector(IPIF_SLV_DWIDTH-1 downto 0);
  signal user_Bus2IP_RdCE               : std_logic_vector(USER_NUM_REG-1 downto 0);
  signal user_Bus2IP_WrCE               : std_logic_vector(USER_NUM_REG-1 downto 0);
  signal user_IP2Bus_Data               : std_logic_vector(USER_SLV_DWIDTH-1 downto 0);
  signal user_IP2Bus_RdAck              : std_logic;
  signal user_IP2Bus_WrAck              : std_logic;
  signal user_IP2Bus_Error              : std_logic;
  
  signal m_axi_reset                    : std_logic;
  signal ip2bus_mstwr_req               : std_logic;
  signal bus2ip_mst_cmdack              : std_logic;
  signal bus2ip_mst_cmplt               : std_logic;
  signal ip2bus_mstwr_d                 : std_logic_vector(C_M_AXI_LITE_DATA_WIDTH-1 downto 0);
  signal ip2bus_mst_addr                : std_logic_vector(C_M_AXI_LITE_ADDR_WIDTH-1 downto 0);
  
  
begin

  ------------------------------------------
  -- instantiate axi_lite_ipif
  ------------------------------------------
  AXI_LITE_IPIF_I : entity axi_lite_ipif_v1_01_a.axi_lite_ipif
    generic map
    (
      C_S_AXI_DATA_WIDTH             => IPIF_SLV_DWIDTH,
      C_S_AXI_ADDR_WIDTH             => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_MIN_SIZE               => C_S_AXI_MIN_SIZE,
      C_USE_WSTRB                    => C_USE_WSTRB,
      C_DPHASE_TIMEOUT               => C_DPHASE_TIMEOUT,
      C_ARD_ADDR_RANGE_ARRAY         => IPIF_ARD_ADDR_RANGE_ARRAY,
      C_ARD_NUM_CE_ARRAY             => IPIF_ARD_NUM_CE_ARRAY,
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      S_AXI_ACLK                     => S_AXI_ACLK,
      S_AXI_ARESETN                  => S_AXI_ARESETN,
      S_AXI_AWADDR                   => S_AXI_AWADDR,
      S_AXI_AWVALID                  => S_AXI_AWVALID,
      S_AXI_WDATA                    => S_AXI_WDATA,
      S_AXI_WSTRB                    => S_AXI_WSTRB,
      S_AXI_WVALID                   => S_AXI_WVALID,
      S_AXI_BREADY                   => S_AXI_BREADY,
      S_AXI_ARADDR                   => S_AXI_ARADDR,
      S_AXI_ARVALID                  => S_AXI_ARVALID,
      S_AXI_RREADY                   => S_AXI_RREADY,
      S_AXI_ARREADY                  => S_AXI_ARREADY,
      S_AXI_RDATA                    => S_AXI_RDATA,
      S_AXI_RRESP                    => S_AXI_RRESP,
      S_AXI_RVALID                   => S_AXI_RVALID,
      S_AXI_WREADY                   => S_AXI_WREADY,
      S_AXI_BRESP                    => S_AXI_BRESP,
      S_AXI_BVALID                   => S_AXI_BVALID,
      S_AXI_AWREADY                  => S_AXI_AWREADY,
      Bus2IP_Clk                     => ipif_Bus2IP_Clk,
      Bus2IP_Resetn                  => ipif_Bus2IP_Resetn,
      Bus2IP_Addr                    => ipif_Bus2IP_Addr,
      Bus2IP_RNW                     => ipif_Bus2IP_RNW,
      Bus2IP_BE                      => ipif_Bus2IP_BE,
      Bus2IP_CS                      => ipif_Bus2IP_CS,
      Bus2IP_RdCE                    => ipif_Bus2IP_RdCE,
      Bus2IP_WrCE                    => ipif_Bus2IP_WrCE,
      Bus2IP_Data                    => ipif_Bus2IP_Data,
      IP2Bus_WrAck                   => ipif_IP2Bus_WrAck,
      IP2Bus_RdAck                   => ipif_IP2Bus_RdAck,
      IP2Bus_Error                   => ipif_IP2Bus_Error,
      IP2Bus_Data                    => ipif_IP2Bus_Data
    );
    
    
    
    
--    m_axi_reset <= not M_AXI_LITE_ARESETN;
    
    
    
--  I_RD_WR_CNTLR : entity axi_time_scan_v1_00_a.axi_master_lite_cntlr
--  generic map (
--   
--    C_M_AXI_LITE_ADDR_WIDTH => C_M_AXI_LITE_ADDR_WIDTH,   
--    C_M_AXI_LITE_DATA_WIDTH => C_M_AXI_LITE_DATA_WIDTH,  
--    C_FAMILY                => C_FAMILY
--    
--    )
--  port map (
--    axi_aclk                => M_AXI_LITE_ACLK ,
--    axi_reset               => m_axi_reset,
--    md_error                => open,
--    m_axi_arready           => m_axi_lite_arready ,
--    m_axi_arvalid           => m_axi_lite_arvalid ,
--    m_axi_araddr            => m_axi_lite_araddr  ,
--    m_axi_arprot            => m_axi_lite_arprot  ,
--    m_axi_rready            => m_axi_lite_rready  ,
--    m_axi_rvalid            => m_axi_lite_rvalid  ,
--    m_axi_rdata             => m_axi_lite_rdata   ,
--    m_axi_rresp             => m_axi_lite_rresp   ,
--    m_axi_awready           => m_axi_lite_awready ,
--    m_axi_awvalid           => m_axi_lite_awvalid ,
--    m_axi_awaddr            => m_axi_lite_awaddr  ,
--    m_axi_awprot            => m_axi_lite_awprot  ,
--    m_axi_wready            => m_axi_lite_wready  ,
--    m_axi_wvalid            => m_axi_lite_wvalid  ,
--    m_axi_wdata             => m_axi_lite_wdata   ,
--    m_axi_wstrb             => m_axi_lite_wstrb   ,
--    m_axi_bready            => m_axi_lite_bready  ,
--    m_axi_bvalid            => m_axi_lite_bvalid  ,
--    m_axi_bresp             => m_axi_lite_bresp   ,
--    -----------------------------------
--    -- IP Master Request/Qualifers
--    -----------------------------------
--    ip2bus_mstrd_req        => '0',
--    ip2bus_mstwr_req        => ip2bus_mstwr_req,
--    ip2bus_mst_addr         => ip2bus_mst_addr,
--    ip2bus_mst_be           => b"1111",
--    ip2bus_mst_lock         => '0',
--    -----------------------------------
--    -- IP Request Status Reply                  
--    -----------------------------------
--    bus2ip_mst_cmdack       => bus2ip_mst_cmdack,
--    bus2ip_mst_cmplt        => bus2ip_mst_cmplt,
--    bus2ip_mst_error        => open,
--    bus2ip_mst_rearbitrate  => open,
--    bus2ip_mst_cmd_timeout  => open,
--    -----------------------------------
--    -- IPIC Read data
--    -----------------------------------
--    bus2ip_mstrd_d          => open,
--    bus2ip_mstrd_src_rdy_n  => open,
--    ----------------------------------
--    -- IPIC Write data
--    ----------------------------------
--    ip2bus_mstwr_d          => ip2bus_mstwr_d,
--    bus2ip_mstwr_dst_rdy_n  => open
--    
--    );
  ------------------------------------------
  -- instantiate User Logic
  ------------------------------------------
  axi_capture_I : entity axi_time_scan_v1_00_a.axi_capture
    generic map
    (
      -- MAP USER GENERICS BELOW THIS LINE ---------------
     C_M_AXI_LITE_ADDR_WIDTH         => C_M_AXI_LITE_ADDR_WIDTH,
     C_M_AXI_LITE_DATA_WIDTH         => C_M_AXI_LITE_DATA_WIDTH,
     C_CAPT_AXI_DATA_WIDTH           => C_CAPT_AXI_DATA_WIDTH,
     C_CAPT_AXI_ADDR_WIDTH           => C_CAPT_AXI_ADDR_WIDTH,
     C_CAPT_AXI_ID_WIDTH             => C_CAPT_AXI_ID_WIDTH  ,
     
      -- MAP USER GENERICS ABOVE THIS LINE ---------------

      C_NUM_REG                      => USER_NUM_REG,
      C_SLV_DWIDTH                   => USER_SLV_DWIDTH
    )
    port map
    (
      -- MAP USER PORTS BELOW THIS LINE ------------------
--      M_AXI_ACLK                     => M_AXI_LITE_ACLK,
--      ip2bus_mstwr_req               => ip2bus_mstwr_req ,
--      bus2ip_mst_cmdack              => bus2ip_mst_cmdack,
--      bus2ip_mst_cmplt               => bus2ip_mst_cmplt ,
--      ip2bus_mstwr_d                 => ip2bus_mstwr_d   ,
--      ip2bus_mst_addr                => ip2bus_mst_addr  ,
      AXIS_CAPT2DMA_ACLK             => AXIS_CAPT2DMA_ACLK  ,
      AXIS_CAPT2DMA_TREADY           => AXIS_CAPT2DMA_TREADY,
      AXIS_CAPT2DMA_TDATA            => AXIS_CAPT2DMA_TDATA ,
      AXIS_CAPT2DMA_TKEEP            => AXIS_CAPT2DMA_TKEEP ,
      AXIS_CAPT2DMA_TVALID           => AXIS_CAPT2DMA_TVALID,
      AXIS_CAPT2DMA_TLAST            => AXIS_CAPT2DMA_TLAST ,
      
      CAPT_AXI_ACLK                  => S_AXI_ACLK,
      CAPT_AXI_ARESETN               => CAPT_AXI_ARESETN ,
      CAPT_AXI_AWADDR                => CAPT_AXI_AWADDR  ,
      CAPT_AXI_AWVALID               => CAPT_AXI_AWVALID ,
      CAPT_AXI_AWREADY               => CAPT_AXI_AWREADY ,
      CAPT_AXI_WDATA                 => CAPT_AXI_WDATA   ,
      CAPT_AXI_WSTRB                 => CAPT_AXI_WSTRB   ,
      CAPT_AXI_WVALID                => CAPT_AXI_WVALID  ,
      CAPT_AXI_BREADY                => CAPT_AXI_BREADY  ,
      CAPT_AXI_ARADDR                => CAPT_AXI_ARADDR  ,
      CAPT_AXI_ARVALID               => CAPT_AXI_ARVALID ,
      CAPT_AXI_RREADY                => CAPT_AXI_RREADY  ,
      CAPT_AXI_ARREADY               => CAPT_AXI_ARREADY ,
      CAPT_AXI_RDATA                 => CAPT_AXI_RDATA   ,
      CAPT_AXI_RRESP                 => CAPT_AXI_RRESP   ,
      CAPT_AXI_RVALID                => CAPT_AXI_RVALID  ,
      CAPT_AXI_WREADY                => CAPT_AXI_WREADY  ,
      CAPT_AXI_BRESP                 => CAPT_AXI_BRESP   ,
      CAPT_AXI_BVALID                => CAPT_AXI_BVALID  ,
      CAPT_AXI_AWID                  => CAPT_AXI_AWID    ,
      CAPT_AXI_AWLEN                 => CAPT_AXI_AWLEN   ,
      CAPT_AXI_AWSIZE                => CAPT_AXI_AWSIZE  ,
      CAPT_AXI_AWBURST               => CAPT_AXI_AWBURST ,
      CAPT_AXI_AWLOCK                => CAPT_AXI_AWLOCK  ,
      CAPT_AXI_AWCACHE               => CAPT_AXI_AWCACHE ,
      CAPT_AXI_AWPROT                => CAPT_AXI_AWPROT  ,
      CAPT_AXI_WLAST                 => CAPT_AXI_WLAST   ,
      CAPT_AXI_BID                   => CAPT_AXI_BID     ,
      CAPT_AXI_ARID                  => CAPT_AXI_ARID    ,
      CAPT_AXI_ARLEN                 => CAPT_AXI_ARLEN   ,
      CAPT_AXI_ARSIZE                => CAPT_AXI_ARSIZE  ,
      CAPT_AXI_ARBURST               => CAPT_AXI_ARBURST ,
      CAPT_AXI_ARLOCK                => CAPT_AXI_ARLOCK  ,
      CAPT_AXI_ARCACHE               => CAPT_AXI_ARCACHE ,
      CAPT_AXI_ARPROT                => CAPT_AXI_ARPROT  ,
      CAPT_AXI_RID                   => CAPT_AXI_RID     ,
      CAPT_AXI_RLAST                 => CAPT_AXI_RLAST   ,
      TIME_AXIS_TLAST                => TIME_AXIS_TLAST  ,
      TIME_AXIS_TDATA                => TIME_AXIS_TDATA  ,
      TIME_AXIS_TVALID               => TIME_AXIS_TVALID ,
      time_axis_aclk                 => time_axis_aclk,
      
      
      -- MAP USER PORTS ABOVE THIS LINE ------------------

      Bus2IP_Clk                     => ipif_Bus2IP_Clk,
      Bus2IP_Resetn                  => ipif_Bus2IP_Resetn,
      Bus2IP_Data                    => ipif_Bus2IP_Data,
      Bus2IP_BE                      => ipif_Bus2IP_BE,
      Bus2IP_RdCE                    => user_Bus2IP_RdCE,
      Bus2IP_WrCE                    => user_Bus2IP_WrCE,
      IP2Bus_Data                    => user_IP2Bus_Data,
      IP2Bus_RdAck                   => user_IP2Bus_RdAck,
      IP2Bus_WrAck                   => user_IP2Bus_WrAck,
      INTR_out                       => INTR_out
    );

  ------------------------------------------
  -- connect internal signals
  ------------------------------------------
  ipif_IP2Bus_Data <= user_IP2Bus_Data;
  ipif_IP2Bus_WrAck <= user_IP2Bus_WrAck;
  ipif_IP2Bus_RdAck <= user_IP2Bus_RdAck;
  ipif_IP2Bus_Error <= '0';

  user_Bus2IP_RdCE <= ipif_Bus2IP_RdCE(USER_NUM_REG-1 downto 0);
  user_Bus2IP_WrCE <= ipif_Bus2IP_WrCE(USER_NUM_REG-1 downto 0);

end IMP;
