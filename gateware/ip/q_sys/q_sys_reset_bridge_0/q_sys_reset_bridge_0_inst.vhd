	component q_sys_reset_bridge_0 is
		port (
			in_reset_n  : in  std_logic := 'X'; -- reset_n
			out_reset_n : out std_logic         -- reset_n
		);
	end component q_sys_reset_bridge_0;

	u0 : component q_sys_reset_bridge_0
		port map (
			in_reset_n  => CONNECTED_TO_in_reset_n,  --  in_reset.reset_n
			out_reset_n => CONNECTED_TO_out_reset_n  -- out_reset.reset_n
		);

