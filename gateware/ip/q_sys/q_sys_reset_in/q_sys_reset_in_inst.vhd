	component q_sys_reset_in is
		port (
			clk         : in  std_logic := 'X'; -- clk
			in_reset_n  : in  std_logic := 'X'; -- reset_n
			out_reset_n : out std_logic         -- reset_n
		);
	end component q_sys_reset_in;

	u0 : component q_sys_reset_in
		port map (
			clk         => CONNECTED_TO_clk,         --       clk.clk
			in_reset_n  => CONNECTED_TO_in_reset_n,  --  in_reset.reset_n
			out_reset_n => CONNECTED_TO_out_reset_n  -- out_reset.reset_n
		);

