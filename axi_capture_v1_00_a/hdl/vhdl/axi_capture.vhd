library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.ipif_pkg.all;

library axi_lite_ipif_v1_01_a;
use axi_lite_ipif_v1_01_a.axi_lite_ipif;

library axi_slave_burst_v1_00_a;
use axi_slave_burst_v1_00_a.axi_slave_burst;

entity axi_capture is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_MIN_SIZE               : std_logic_vector     := X"000001FF";
    C_USE_WSTRB                    : integer              := 0;
    C_DPHASE_TIMEOUT               : integer              := 8;
    C_BASEADDR                     : std_logic_vector     := X"FFFFFFFF";
    C_HIGHADDR                     : std_logic_vector     := X"00000000";
    C_FAMILY                       : string               := "virtex6";
    C_NUM_REG                      : integer              := 1;
    C_NUM_MEM                      : integer              := 1;
    C_SLV_AWIDTH                   : integer              := 32;
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
    
    TIME_AXIS_TLAST                   : in std_logic;
    TIME_AXIS_TDATA                   : in std_logic_vector(63 downto 0);
    TIME_AXIS_TVALID                  : in std_logic
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


end IMP;
