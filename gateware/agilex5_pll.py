#
# This file is part of LiteX.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

# See.
# https://cdrdv2-public.intel.com/813919/ds-813918-813919.pdf (section Switching Characteristics)
# https://cdrdv2-public.intel.com/813672/ug-813671-813672.pdf (section 5)

from migen import *

from litex.gen import *

from litex.soc.cores.clock.common import *
from litex.soc.cores.clock.intel_common import *

# Altera / Agilex5 ---------------------------------------------------------------------------------

class Agilex5PLL(IntelClocking):
    nclkouts_max          = 7
    n_div_range           = (1, 110+1)
    m_div_range           = (4, 320+1)
    c_div_range           = (1, 510+1)
    clkin_pfd_freq_range  = (10e6, 325e6)

    def __init__(self, speedgrade="-1V"):
        self.logger = logging.getLogger("AgilexPLL")
        self.logger.info("Creating AgilexPLL, {}.".format(colorer("speedgrade {}".format(speedgrade))))
        IntelClocking.__init__(self)

        self.clko = Signal(self.nclkouts_max)

        self.clkin_freq_range = {
            "-1V" : (10e6,  800e6),
            "-2V" : (10e6,  717e6),
            "-3V" : (10e6,  625e6),
        }[speedgrade]

        self.vco_freq_range = {
            "-1V" : (600e6, 3200e6),
            "-2V" : (600e6, 3200e6),
            "-3V" : (600e6, 2400e6),
        }[speedgrade]

        self.clko_freq_range = {
            "-1V" : (0e6, 1100e6),
            "-2V" : (0e6, 1100e6),
            "-3V" : (0e6,  780e6),
        }[speedgrade]

    def do_finalize(self):
        #config = self.compute_config()

        m_factor = 11 # 100MHz * 11 = 1100MHz
        n_factor = 1  # No divider required here

        # /5: 220MHz, /11: 100MHz
        c_factor = [11, 5, 11, 11, 11, 11, 11]

        self.params.update(
            p_REFERENCE_CLOCK_FREQUENCY = f"{self.clkin_freq/1e6:0.1f} MHz",
            i_refclk                    = self.clkin,
            i_reset                     = self.reset,
            o_locked                    = self.locked,
            p_N_CNT                     = n_factor,
            p_M_CNT                     = m_factor,
            **{f"p_C{i}_CNT"  : c_factor[i]  for i in range(self.nclkouts_max)},
            **{f"o_outclk{i}" : self.clko[i] for i in range(self.nclkouts_max)},
        )

        self.specials += Instance("ipm_iopll_basic", **self.params)
