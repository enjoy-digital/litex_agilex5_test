	component ed_synth_emif_ph2_inst is
		port (
			ref_clk_0           : in    std_logic                      := 'X';             -- clk
			core_init_n_0       : in    std_logic                      := 'X';             -- reset_n
			usr_clk_0           : out   std_logic;                                         -- clk
			usr_rst_n_0         : out   std_logic;                                         -- reset_n
			s0_axi4_araddr      : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- araddr
			s0_axi4_arburst     : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- arburst
			s0_axi4_arid        : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- arid
			s0_axi4_arlen       : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- arlen
			s0_axi4_arlock      : in    std_logic                      := 'X';             -- arlock
			s0_axi4_arqos       : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- arqos
			s0_axi4_arsize      : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arsize
			s0_axi4_arvalid     : in    std_logic                      := 'X';             -- arvalid
			s0_axi4_aruser      : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- aruser
			s0_axi4_arprot      : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- arprot
			s0_axi4_awaddr      : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- awaddr
			s0_axi4_awburst     : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- awburst
			s0_axi4_awid        : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- awid
			s0_axi4_awlen       : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- awlen
			s0_axi4_awlock      : in    std_logic                      := 'X';             -- awlock
			s0_axi4_awqos       : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awqos
			s0_axi4_awsize      : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awsize
			s0_axi4_awvalid     : in    std_logic                      := 'X';             -- awvalid
			s0_axi4_awuser      : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- awuser
			s0_axi4_awprot      : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awprot
			s0_axi4_bready      : in    std_logic                      := 'X';             -- bready
			s0_axi4_rready      : in    std_logic                      := 'X';             -- rready
			s0_axi4_wdata       : in    std_logic_vector(255 downto 0) := (others => 'X'); -- wdata
			s0_axi4_wstrb       : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- wstrb
			s0_axi4_wlast       : in    std_logic                      := 'X';             -- wlast
			s0_axi4_wvalid      : in    std_logic                      := 'X';             -- wvalid
			s0_axi4_wuser       : in    std_logic_vector(63 downto 0)  := (others => 'X'); -- wuser
			s0_axi4_ruser       : out   std_logic_vector(63 downto 0);                     -- ruser
			s0_axi4_arready     : out   std_logic;                                         -- arready
			s0_axi4_awready     : out   std_logic;                                         -- awready
			s0_axi4_bid         : out   std_logic_vector(6 downto 0);                      -- bid
			s0_axi4_bresp       : out   std_logic_vector(1 downto 0);                      -- bresp
			s0_axi4_bvalid      : out   std_logic;                                         -- bvalid
			s0_axi4_rdata       : out   std_logic_vector(255 downto 0);                    -- rdata
			s0_axi4_rid         : out   std_logic_vector(6 downto 0);                      -- rid
			s0_axi4_rlast       : out   std_logic;                                         -- rlast
			s0_axi4_rresp       : out   std_logic_vector(1 downto 0);                      -- rresp
			s0_axi4_rvalid      : out   std_logic;                                         -- rvalid
			s0_axi4_wready      : out   std_logic;                                         -- wready
			mem_ck_t_0          : out   std_logic;                                         -- mem_ck_t
			mem_ck_c_0          : out   std_logic;                                         -- mem_ck_c
			mem_cke_0           : out   std_logic;                                         -- mem_cke
			mem_reset_n_0       : out   std_logic;                                         -- mem_reset_n
			mem_cs_0            : out   std_logic;                                         -- mem_cs
			mem_ca_0            : out   std_logic_vector(5 downto 0);                      -- mem_ca
			mem_dq_0            : inout std_logic_vector(31 downto 0)  := (others => 'X'); -- mem_dq
			mem_dqs_t_0         : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- mem_dqs_t
			mem_dqs_c_0         : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- mem_dqs_c
			mem_dmi_0           : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- mem_dmi
			oct_rzqin_0         : in    std_logic                      := 'X';             -- oct_rzqin
			s0_axi4lite_clk     : in    std_logic                      := 'X';             -- clk
			s0_axi4lite_rst_n   : in    std_logic                      := 'X';             -- reset_n
			s0_axi4lite_awaddr  : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- awaddr
			s0_axi4lite_awvalid : in    std_logic                      := 'X';             -- awvalid
			s0_axi4lite_awready : out   std_logic;                                         -- awready
			s0_axi4lite_wdata   : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- wdata
			s0_axi4lite_wstrb   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- wstrb
			s0_axi4lite_wvalid  : in    std_logic                      := 'X';             -- wvalid
			s0_axi4lite_wready  : out   std_logic;                                         -- wready
			s0_axi4lite_bresp   : out   std_logic_vector(1 downto 0);                      -- bresp
			s0_axi4lite_bvalid  : out   std_logic;                                         -- bvalid
			s0_axi4lite_bready  : in    std_logic                      := 'X';             -- bready
			s0_axi4lite_araddr  : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- araddr
			s0_axi4lite_arvalid : in    std_logic                      := 'X';             -- arvalid
			s0_axi4lite_arready : out   std_logic;                                         -- arready
			s0_axi4lite_rdata   : out   std_logic_vector(31 downto 0);                     -- rdata
			s0_axi4lite_rresp   : out   std_logic_vector(1 downto 0);                      -- rresp
			s0_axi4lite_rvalid  : out   std_logic;                                         -- rvalid
			s0_axi4lite_rready  : in    std_logic                      := 'X';             -- rready
			s0_axi4lite_awprot  : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- awprot
			s0_axi4lite_arprot  : in    std_logic_vector(2 downto 0)   := (others => 'X')  -- arprot
		);
	end component ed_synth_emif_ph2_inst;

	u0 : component ed_synth_emif_ph2_inst
		port map (
			ref_clk_0           => CONNECTED_TO_ref_clk_0,           --     ref_clk_0.clk
			core_init_n_0       => CONNECTED_TO_core_init_n_0,       -- core_init_n_0.reset_n
			usr_clk_0           => CONNECTED_TO_usr_clk_0,           --     usr_clk_0.clk
			usr_rst_n_0         => CONNECTED_TO_usr_rst_n_0,         --   usr_rst_n_0.reset_n
			s0_axi4_araddr      => CONNECTED_TO_s0_axi4_araddr,      --       s0_axi4.araddr
			s0_axi4_arburst     => CONNECTED_TO_s0_axi4_arburst,     --              .arburst
			s0_axi4_arid        => CONNECTED_TO_s0_axi4_arid,        --              .arid
			s0_axi4_arlen       => CONNECTED_TO_s0_axi4_arlen,       --              .arlen
			s0_axi4_arlock      => CONNECTED_TO_s0_axi4_arlock,      --              .arlock
			s0_axi4_arqos       => CONNECTED_TO_s0_axi4_arqos,       --              .arqos
			s0_axi4_arsize      => CONNECTED_TO_s0_axi4_arsize,      --              .arsize
			s0_axi4_arvalid     => CONNECTED_TO_s0_axi4_arvalid,     --              .arvalid
			s0_axi4_aruser      => CONNECTED_TO_s0_axi4_aruser,      --              .aruser
			s0_axi4_arprot      => CONNECTED_TO_s0_axi4_arprot,      --              .arprot
			s0_axi4_awaddr      => CONNECTED_TO_s0_axi4_awaddr,      --              .awaddr
			s0_axi4_awburst     => CONNECTED_TO_s0_axi4_awburst,     --              .awburst
			s0_axi4_awid        => CONNECTED_TO_s0_axi4_awid,        --              .awid
			s0_axi4_awlen       => CONNECTED_TO_s0_axi4_awlen,       --              .awlen
			s0_axi4_awlock      => CONNECTED_TO_s0_axi4_awlock,      --              .awlock
			s0_axi4_awqos       => CONNECTED_TO_s0_axi4_awqos,       --              .awqos
			s0_axi4_awsize      => CONNECTED_TO_s0_axi4_awsize,      --              .awsize
			s0_axi4_awvalid     => CONNECTED_TO_s0_axi4_awvalid,     --              .awvalid
			s0_axi4_awuser      => CONNECTED_TO_s0_axi4_awuser,      --              .awuser
			s0_axi4_awprot      => CONNECTED_TO_s0_axi4_awprot,      --              .awprot
			s0_axi4_bready      => CONNECTED_TO_s0_axi4_bready,      --              .bready
			s0_axi4_rready      => CONNECTED_TO_s0_axi4_rready,      --              .rready
			s0_axi4_wdata       => CONNECTED_TO_s0_axi4_wdata,       --              .wdata
			s0_axi4_wstrb       => CONNECTED_TO_s0_axi4_wstrb,       --              .wstrb
			s0_axi4_wlast       => CONNECTED_TO_s0_axi4_wlast,       --              .wlast
			s0_axi4_wvalid      => CONNECTED_TO_s0_axi4_wvalid,      --              .wvalid
			s0_axi4_wuser       => CONNECTED_TO_s0_axi4_wuser,       --              .wuser
			s0_axi4_ruser       => CONNECTED_TO_s0_axi4_ruser,       --              .ruser
			s0_axi4_arready     => CONNECTED_TO_s0_axi4_arready,     --              .arready
			s0_axi4_awready     => CONNECTED_TO_s0_axi4_awready,     --              .awready
			s0_axi4_bid         => CONNECTED_TO_s0_axi4_bid,         --              .bid
			s0_axi4_bresp       => CONNECTED_TO_s0_axi4_bresp,       --              .bresp
			s0_axi4_bvalid      => CONNECTED_TO_s0_axi4_bvalid,      --              .bvalid
			s0_axi4_rdata       => CONNECTED_TO_s0_axi4_rdata,       --              .rdata
			s0_axi4_rid         => CONNECTED_TO_s0_axi4_rid,         --              .rid
			s0_axi4_rlast       => CONNECTED_TO_s0_axi4_rlast,       --              .rlast
			s0_axi4_rresp       => CONNECTED_TO_s0_axi4_rresp,       --              .rresp
			s0_axi4_rvalid      => CONNECTED_TO_s0_axi4_rvalid,      --              .rvalid
			s0_axi4_wready      => CONNECTED_TO_s0_axi4_wready,      --              .wready
			mem_ck_t_0          => CONNECTED_TO_mem_ck_t_0,          --         mem_0.mem_ck_t
			mem_ck_c_0          => CONNECTED_TO_mem_ck_c_0,          --              .mem_ck_c
			mem_cke_0           => CONNECTED_TO_mem_cke_0,           --              .mem_cke
			mem_reset_n_0       => CONNECTED_TO_mem_reset_n_0,       --              .mem_reset_n
			mem_cs_0            => CONNECTED_TO_mem_cs_0,            --              .mem_cs
			mem_ca_0            => CONNECTED_TO_mem_ca_0,            --              .mem_ca
			mem_dq_0            => CONNECTED_TO_mem_dq_0,            --              .mem_dq
			mem_dqs_t_0         => CONNECTED_TO_mem_dqs_t_0,         --              .mem_dqs_t
			mem_dqs_c_0         => CONNECTED_TO_mem_dqs_c_0,         --              .mem_dqs_c
			mem_dmi_0           => CONNECTED_TO_mem_dmi_0,           --              .mem_dmi
			oct_rzqin_0         => CONNECTED_TO_oct_rzqin_0,         --         oct_0.oct_rzqin
			s0_axi4lite_clk     => CONNECTED_TO_s0_axi4lite_clk,     --   s0_axil_clk.clk
			s0_axi4lite_rst_n   => CONNECTED_TO_s0_axi4lite_rst_n,   -- s0_axil_rst_n.reset_n
			s0_axi4lite_awaddr  => CONNECTED_TO_s0_axi4lite_awaddr,  --       s0_axil.awaddr
			s0_axi4lite_awvalid => CONNECTED_TO_s0_axi4lite_awvalid, --              .awvalid
			s0_axi4lite_awready => CONNECTED_TO_s0_axi4lite_awready, --              .awready
			s0_axi4lite_wdata   => CONNECTED_TO_s0_axi4lite_wdata,   --              .wdata
			s0_axi4lite_wstrb   => CONNECTED_TO_s0_axi4lite_wstrb,   --              .wstrb
			s0_axi4lite_wvalid  => CONNECTED_TO_s0_axi4lite_wvalid,  --              .wvalid
			s0_axi4lite_wready  => CONNECTED_TO_s0_axi4lite_wready,  --              .wready
			s0_axi4lite_bresp   => CONNECTED_TO_s0_axi4lite_bresp,   --              .bresp
			s0_axi4lite_bvalid  => CONNECTED_TO_s0_axi4lite_bvalid,  --              .bvalid
			s0_axi4lite_bready  => CONNECTED_TO_s0_axi4lite_bready,  --              .bready
			s0_axi4lite_araddr  => CONNECTED_TO_s0_axi4lite_araddr,  --              .araddr
			s0_axi4lite_arvalid => CONNECTED_TO_s0_axi4lite_arvalid, --              .arvalid
			s0_axi4lite_arready => CONNECTED_TO_s0_axi4lite_arready, --              .arready
			s0_axi4lite_rdata   => CONNECTED_TO_s0_axi4lite_rdata,   --              .rdata
			s0_axi4lite_rresp   => CONNECTED_TO_s0_axi4lite_rresp,   --              .rresp
			s0_axi4lite_rvalid  => CONNECTED_TO_s0_axi4lite_rvalid,  --              .rvalid
			s0_axi4lite_rready  => CONNECTED_TO_s0_axi4lite_rready,  --              .rready
			s0_axi4lite_awprot  => CONNECTED_TO_s0_axi4lite_awprot,  --              .awprot
			s0_axi4lite_arprot  => CONNECTED_TO_s0_axi4lite_arprot   --              .arprot
		);

