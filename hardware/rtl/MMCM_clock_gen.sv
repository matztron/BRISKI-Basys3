`include "mmcm_lookup_params.svh"
module MMCM_clock_gen #(
    parameter int MMCM_OUT_FREQ = 650
) (
    input logic CLKIN1,
    input logic ASYNC_RESET,
    output logic CLK_OUT,
    output logic LOCKED
);
    // Function to derive Master Divider (D)
    function int DeriveMasterDiv(input int freq);
    // Default to 0 if no match found
    DeriveMasterDiv = 0;

    // Loop through the `desired_freqs` array to find a match
    for (int i = 0; i < $size(desired_freqs); i++) begin
        if (freq == desired_freqs[i]) begin
            // If a match is found, return the corresponding D_value
	    $display ("Dval = %d", D_values[i]);
            return D_values[i];
        end
    end
    endfunction

    // Function to derive Master Multiplier (M)
    function real DeriveMasterMult (input int freq);
    // Default to 0 if no match found
    DeriveMasterMult = 0.0;

    // Loop through the `desired_freqs` array to find a match
    for (int i = 0; i < $size(desired_freqs); i++) begin
        if (freq == desired_freqs[i]) begin
            // If a match is found, return the corresponding M_value
	    $display ("Mval = %f", M_values[i]);
            return M_values[i];
        end
    end
    endfunction

    // Function to derive Output Divider (O)
    function real DeriveOutDiv (input int freq);
    // Default to 0 if no match found
    DeriveOutDiv = 0.0;

    // Loop through the `desired_freqs` array to find a match
    for (int i = 0; i < $size(desired_freqs); i++) begin
        if (freq == desired_freqs[i]) begin
            // If a match is found, return the corresponding O_value
	    $display ("Oval = %f", O_values[i]);
            return O_values[i];
        end
    end
    endfunction

    logic CLKFBOUT;
    logic clkout0;

    /*localparam int Dval = DeriveMasterDiv(MMCM_OUT_FREQ);
    localparam real Mval = DeriveMasterMult(MMCM_OUT_FREQ);
    localparam real Oval = DeriveOutDiv(MMCM_OUT_FREQ);*/
    // Just use the 100MHz of Basys for now
    localparam int Dval = 1;
    localparam real Mval = 10;
    localparam real Oval = 10;

    // MMCME4_BASE instantiation
    // THIS MIGHT HAVE TO BE CHANGED TO: "MMCME2_BASE" as MMCME4_BASE MIGHT BE ULTRASCALE SPECIFIC
    /*MMCME4_BASE #(
        .BANDWIDTH("OPTIMIZED"),   // Jitter programming (HIGH, LOW, OPTIMIZED)
        .CLKFBOUT_MULT_F(Mval),     // Multiply value for all CLKOUT (2.000-64.000) (M counter)
        .CLKFBOUT_PHASE(0.0),      // Phase offset in degrees of CLKFB (-360.000-360.000)
        .CLKIN1_PERIOD(8),         // Input clock period in ns units, ps resolution (i.e., 33.333 is 30 MHz).
        .CLKOUT0_DIVIDE_F(Oval),    // Divide amount for CLKOUT0 (1.000-128.000)  (O counter for clk 0)
        .CLKOUT0_DUTY_CYCLE(0.5),
        .CLKOUT1_DUTY_CYCLE(0.5),
        .CLKOUT2_DUTY_CYCLE(0.5),
        .CLKOUT3_DUTY_CYCLE(0.5),
        .CLKOUT4_DUTY_CYCLE(0.5),
        .CLKOUT5_DUTY_CYCLE(0.5),
        .CLKOUT6_DUTY_CYCLE(0.5),
        .CLKOUT0_PHASE(0.0),
        .CLKOUT1_PHASE(0.0),
        .CLKOUT2_PHASE(0.0),
        .CLKOUT3_PHASE(0.0),
        .CLKOUT4_PHASE(0.0),
        .CLKOUT5_PHASE(0.0),
        .CLKOUT6_PHASE(0.0),
        .CLKOUT1_DIVIDE(1),    // (O counter)
        .CLKOUT2_DIVIDE(1),
        .CLKOUT3_DIVIDE(1),
        .CLKOUT4_DIVIDE(1),
        .CLKOUT5_DIVIDE(1),
        .CLKOUT6_DIVIDE(1),
        .CLKOUT4_CASCADE("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
        .DIVCLK_DIVIDE(Dval),    // Master division value (1-106) (D counter)
        .IS_CLKFBIN_INVERTED(1'b0), // Optional inversion for CLKFBIN
        .IS_CLKIN1_INVERTED(1'b0),  // Optional inversion for CLKIN1
        .IS_PWRDWN_INVERTED(1'b0),  // Optional inversion for PWRDWN
        .IS_RST_INVERTED(1'b0),     // Optional inversion for RST
        .REF_JITTER1(0.0),          // Reference input jitter in UI (0.000-0.999)
        .STARTUP_WAIT("FALSE")      // Delays DONE until MMCM is locked (FALSE, TRUE)
    ) MMCME4_BASE_inst (
        .CLKOUT0(clkout0),     // 1-bit output: CLKOUT0
        .CLKOUT0B(),           // 1-bit output: Inverted CLKOUT0
        .CLKOUT1(),            // 1-bit output: CLKOUT1
        .CLKOUT1B(),           // 1-bit output: Inverted CLKOUT1
        .CLKOUT2(),            // 1-bit output: CLKOUT2
        .CLKOUT2B(),           // 1-bit output: Inverted CLKOUT2
        .CLKOUT3(),            // 1-bit output: CLKOUT3
        .CLKOUT3B(),           // 1-bit output: Inverted CLKOUT3
        .CLKOUT4(),            // 1-bit output: CLKOUT4
        .CLKOUT5(),            // 1-bit output: CLKOUT5
        .CLKOUT6(),            // 1-bit output: CLKOUT6
        .CLKFBOUT(CLKFBOUT),   // 1-bit output: Feedback clock
        .CLKFBOUTB(),          // 1-bit output: Inverted CLKFBOUT
        .LOCKED(LOCKED),       // 1-bit output: LOCK
        .CLKIN1(CLKIN1),       // 1-bit input: Clock
        .PWRDWN(1'b0),         // 1-bit input: Power-down
        .RST(ASYNC_RESET),     // 1-bit input: Reset
        .CLKFBIN(CLKFBOUT)     // 1-bit input: Feedback clock
    );*/
    MMCME2_BASE #(
        .BANDWIDTH("OPTIMIZED"),        // Jitter programming
        .CLKFBOUT_MULT_F(Mval),         // M counter
        .CLKFBOUT_PHASE(0.0),
        .CLKIN1_PERIOD(8),              // Input clock period in ns

        .CLKOUT0_DIVIDE_F(Oval),        // O counter (fractional)
        .CLKOUT1_DIVIDE(1),
        .CLKOUT2_DIVIDE(1),
        .CLKOUT3_DIVIDE(1),
        .CLKOUT4_DIVIDE(1),
        .CLKOUT5_DIVIDE(1),
        .CLKOUT6_DIVIDE(1),

        .CLKOUT0_DUTY_CYCLE(0.5),
        .CLKOUT1_DUTY_CYCLE(0.5),
        .CLKOUT2_DUTY_CYCLE(0.5),
        .CLKOUT3_DUTY_CYCLE(0.5),
        .CLKOUT4_DUTY_CYCLE(0.5),
        .CLKOUT5_DUTY_CYCLE(0.5),
        .CLKOUT6_DUTY_CYCLE(0.5),

        .CLKOUT0_PHASE(0.0),
        .CLKOUT1_PHASE(0.0),
        .CLKOUT2_PHASE(0.0),
        .CLKOUT3_PHASE(0.0),
        .CLKOUT4_PHASE(0.0),
        .CLKOUT5_PHASE(0.0),
        .CLKOUT6_PHASE(0.0),

        .CLKOUT4_CASCADE("FALSE"),
        .DIVCLK_DIVIDE(Dval),           // D counter
        .REF_JITTER1(0.0),
        .STARTUP_WAIT("FALSE")
    ) MMCME2_BASE_inst (
        .CLKOUT0(clkout0),        // Primary output
        .CLKOUT0B(),              // Not used
        .CLKOUT1(),               // Not used
        .CLKOUT1B(),              // Not used
        .CLKOUT2(),               // Not used
        .CLKOUT2B(),              // Not used
        .CLKOUT3(),               // Not used
        .CLKOUT3B(),              // Not used
        .CLKOUT4(),               // Not used
        .CLKOUT5(),               // Not used
        .CLKOUT6(),               // Not used

        .CLKFBOUT(CLKFBOUT),      // Feedback clock
        .CLKFBOUTB(),             // Not used
        .LOCKED(LOCKED),          // Lock status

        .CLKIN1(CLKIN1),          // Clock input
        .PWRDWN(1'b0),            // Always enabled
        .RST(ASYNC_RESET),        // Reset
        .CLKFBIN(CLKFBOUT)        // Feedback loop
    );

    BUFG clkout0_gbuf (
        .O(CLK_OUT),
        .I(clkout0)
    );

endmodule

