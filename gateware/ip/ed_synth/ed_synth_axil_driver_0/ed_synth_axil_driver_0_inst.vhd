	component ed_synth_axil_driver_0 is
		port (
			axil_driver_clk     : in  std_logic                     := 'X';             -- clk
			axil_driver_rst_n   : in  std_logic                     := 'X';             -- reset_n
			axil_driver_awaddr  : out std_logic_vector(31 downto 0);                    -- awaddr
			axil_driver_awvalid : out std_logic;                                        -- awvalid
			axil_driver_awready : in  std_logic                     := 'X';             -- awready
			axil_driver_wdata   : out std_logic_vector(31 downto 0);                    -- wdata
			axil_driver_wstrb   : out std_logic_vector(3 downto 0);                     -- wstrb
			axil_driver_wvalid  : out std_logic;                                        -- wvalid
			axil_driver_wready  : in  std_logic                     := 'X';             -- wready
			axil_driver_bresp   : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- bresp
			axil_driver_bvalid  : in  std_logic                     := 'X';             -- bvalid
			axil_driver_bready  : out std_logic;                                        -- bready
			axil_driver_araddr  : out std_logic_vector(31 downto 0);                    -- araddr
			axil_driver_arvalid : out std_logic;                                        -- arvalid
			axil_driver_arready : in  std_logic                     := 'X';             -- arready
			axil_driver_rdata   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- rdata
			axil_driver_rresp   : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- rresp
			axil_driver_rvalid  : in  std_logic                     := 'X';             -- rvalid
			axil_driver_rready  : out std_logic;                                        -- rready
			axil_driver_awprot  : out std_logic_vector(2 downto 0);                     -- awprot
			axil_driver_arprot  : out std_logic_vector(2 downto 0);                     -- arprot
			cal_done_rst_n      : out std_logic                                         -- reset_n
		);
	end component ed_synth_axil_driver_0;

	u0 : component ed_synth_axil_driver_0
		port map (
			axil_driver_clk     => CONNECTED_TO_axil_driver_clk,     --       axil_driver_clk.clk
			axil_driver_rst_n   => CONNECTED_TO_axil_driver_rst_n,   --     axil_driver_rst_n.reset_n
			axil_driver_awaddr  => CONNECTED_TO_axil_driver_awaddr,  -- axil_driver_axi4_lite.awaddr
			axil_driver_awvalid => CONNECTED_TO_axil_driver_awvalid, --                      .awvalid
			axil_driver_awready => CONNECTED_TO_axil_driver_awready, --                      .awready
			axil_driver_wdata   => CONNECTED_TO_axil_driver_wdata,   --                      .wdata
			axil_driver_wstrb   => CONNECTED_TO_axil_driver_wstrb,   --                      .wstrb
			axil_driver_wvalid  => CONNECTED_TO_axil_driver_wvalid,  --                      .wvalid
			axil_driver_wready  => CONNECTED_TO_axil_driver_wready,  --                      .wready
			axil_driver_bresp   => CONNECTED_TO_axil_driver_bresp,   --                      .bresp
			axil_driver_bvalid  => CONNECTED_TO_axil_driver_bvalid,  --                      .bvalid
			axil_driver_bready  => CONNECTED_TO_axil_driver_bready,  --                      .bready
			axil_driver_araddr  => CONNECTED_TO_axil_driver_araddr,  --                      .araddr
			axil_driver_arvalid => CONNECTED_TO_axil_driver_arvalid, --                      .arvalid
			axil_driver_arready => CONNECTED_TO_axil_driver_arready, --                      .arready
			axil_driver_rdata   => CONNECTED_TO_axil_driver_rdata,   --                      .rdata
			axil_driver_rresp   => CONNECTED_TO_axil_driver_rresp,   --                      .rresp
			axil_driver_rvalid  => CONNECTED_TO_axil_driver_rvalid,  --                      .rvalid
			axil_driver_rready  => CONNECTED_TO_axil_driver_rready,  --                      .rready
			axil_driver_awprot  => CONNECTED_TO_axil_driver_awprot,  --                      .awprot
			axil_driver_arprot  => CONNECTED_TO_axil_driver_arprot,  --                      .arprot
			cal_done_rst_n      => CONNECTED_TO_cal_done_rst_n       --        cal_done_rst_n.reset_n
		);

