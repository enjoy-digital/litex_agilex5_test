	component q_sys_product_info_0 is
		port (
			clk          : in  std_logic                     := 'X';             -- clk
			reset_n      : in  std_logic                     := 'X';             -- reset_n
			chipselect_n : in  std_logic                     := 'X';             -- chipselect_n
			read_n       : in  std_logic                     := 'X';             -- read_n
			av_data_read : out std_logic_vector(31 downto 0);                    -- readdata
			av_address   : in  std_logic_vector(1 downto 0)  := (others => 'X')  -- address
		);
	end component q_sys_product_info_0;

	u0 : component q_sys_product_info_0
		port map (
			clk          => CONNECTED_TO_clk,          --       clock_reset.clk
			reset_n      => CONNECTED_TO_reset_n,      -- clock_reset_reset.reset_n
			chipselect_n => CONNECTED_TO_chipselect_n, --    avalon_slave_0.chipselect_n
			read_n       => CONNECTED_TO_read_n,       --                  .read_n
			av_data_read => CONNECTED_TO_av_data_read, --                  .readdata
			av_address   => CONNECTED_TO_av_address    --                  .address
		);

