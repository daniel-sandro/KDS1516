LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY aufgabe2_test IS
    -- empty
END aufgabe2_test;

ARCHITECTURE test OF aufgabe2_test IS
    CONSTANT RSTDEF: std_ulogic := '1';
    CONSTANT tpd: time := 20 ns;    -- 1/50 MHz

    COMPONENT aufgabe2 IS
        PORT(rst:  IN  std_logic;                     -- (BTN3) User Reset
             clk:  IN  std_logic;                     -- 50 MHz crystal oscillator clock source
             BTN0: IN  std_logic;                     -- load
             BTN1: IN  std_logic;                     -- decrement
             BTN2: IN  std_logic;                     -- increment
             sw:   IN  std_logic_vector(7 DOWNTO 0);  -- 8 slide switches: SW7 SW6 SW5 SW4 SW3 SW2 SW1 SW0
             an:   OUT std_logic_vector(3 DOWNTO 0);  -- 4 digit enable (anode control) signals (active low)
             seg:  OUT std_logic_vector(7 DOWNTO 1);  -- 7 FPGA connections to seven-segment display (active low)
             dp:   OUT std_logic;                     -- 1 FPGA connection to digit dot point (active low)
             LD0:  OUT std_logic);                    -- 1 FPGA connection to LD0 (carry output)
    END COMPONENT;

    SIGNAL rst:     std_logic := RSTDEF;
    SIGNAL clk:     std_logic := '0';
    SIGNAL hlt:     std_logic := '0';

    SIGNAL BTN0:    std_logic := '0';
    SIGNAL BTN1:    std_logic := '0';
    SIGNAL BTN2:    std_logic := '0';
    SIGNAL sw:      std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL an:      std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL seg:     std_logic_vector(7 DOWNTO 1) := (OTHERS => '0');
    SIGNAL dp:      std_logic := '0';
    SIGNAL LD0:     std_logic := '0';
BEGIN
    rst <= RSTDEF, NOT RSTDEF AFTER 5*tpd;
    clk <= clk WHEN hlt = '1' ELSE '1' AFTER tpd/2 WHEN clk='0' ELSE '0' AFTER tpd/2;

    u1: aufgabe2
    PORT MAP(rst  => rst,
             clk  => clk,
             BTN0 => BTN0,
             BTN1 => BTN1,
             BTN2 => BTN2,
             sw   => sw,
             an   => an,
             seg  => seg,
             dp   => dp,
             LD0  => LD0);

    main: PROCESS
        PROCEDURE test_std_counter IS
            TYPE frame IS RECORD
                an: std_logic_vector(3 DOWNTO 0);
                BTN0: std_logic;
                BTN1: std_logic;
                BTN2: std_logic;
                sw:   std_logic_vector(7 DOWNTO 0);
                seg:  std_logic_vector(7 DOWNTO 1);
                LD0:  std_logic;
            END RECORD;
            TYPE frames IS ARRAY(natural RANGE <>) OF frame;
            CONSTANT SEG_0: std_logic_vector(7 DOWNTO 1) := "0000001";
            CONSTANT SEG_1: std_logic_vector(7 DOWNTO 1) := "1001111";
            CONSTANT SEG_2: std_logic_vector(7 DOWNTO 1) := "0010010";
            CONSTANT SEG_3: std_logic_vector(7 DOWNTO 1) := "0000110";
            CONSTANT SEG_4: std_logic_vector(7 DOWNTO 1) := "1001100";
            CONSTANT SEG_5: std_logic_vector(7 DOWNTO 1) := "0100100";
            CONSTANT SEG_6: std_logic_vector(7 DOWNTO 1) := "0100000";
            CONSTANT SEG_7: std_logic_vector(7 DOWNTO 1) := "0001111";
            CONSTANT SEG_8: std_logic_vector(7 DOWNTO 1) := "0000000";
            CONSTANT SEG_9: std_logic_vector(7 DOWNTO 1) := "0000100";
            CONSTANT SEG_A: std_logic_vector(7 DOWNTO 1) := "0001000";
            CONSTANT SEG_B: std_logic_vector(7 DOWNTO 1) := "1100000";
            CONSTANT SEG_C: std_logic_vector(7 DOWNTO 1) := "0110001";
            CONSTANT SEG_D: std_logic_vector(7 DOWNTO 1) := "1000010";
            CONSTANT SEG_E: std_logic_vector(7 DOWNTO 1) := "0110000";
            CONSTANT SEG_F: std_logic_vector(7 DOWNTO 1) := "0111000";
            CONSTANT testtab: frames := (
                -- Load tests
                ("1110", '0', '0', '0', X"00", SEG_0, '0'),
                ("1110", '1', '0', '0', X"00", SEG_0, '0'),         -- Loads 0x0000
                ("1110", '1', '0', '0', X"01", SEG_1, '0'),         -- Loads 0x0001
                ("1110", '1', '0', '0', X"02", SEG_2, '0'),         -- Loads 0x0002
                ("1110", '1', '0', '0', X"03", SEG_3, '0'),         -- Loads 0x0003
                ("1110", '1', '0', '0', X"04", SEG_4, '0'),         -- Loads 0x0004
                ("1110", '1', '0', '0', X"05", SEG_5, '0'),         -- Loads 0x0005
                ("1110", '1', '0', '0', X"06", SEG_6, '0'),         -- Loads 0x0006
                ("1110", '1', '0', '0', X"07", SEG_7, '0'),         -- Loads 0x0007
                ("1110", '1', '0', '0', X"08", SEG_8, '0'),         -- Loads 0x0008
                ("1110", '1', '0', '0', X"09", SEG_9, '0'),         -- Loads 0x0009
                ("1110", '1', '0', '0', X"0A", SEG_A, '0'),         -- Loads 0x000A
                ("1110", '1', '0', '0', X"0B", SEG_B, '0'),         -- Loads 0x000B
                ("1110", '1', '0', '0', X"0C", SEG_C, '0'),         -- Loads 0x000C
                ("1110", '1', '0', '0', X"0D", SEG_D, '0'),         -- Loads 0x000D
                ("1110", '1', '0', '0', X"0E", SEG_E, '0'),         -- Loads 0x000E
                ("1110", '1', '0', '0', X"0F", SEG_F, '0'),         -- Loads 0x000F
                ("1101", '1', '0', '0', X"00", SEG_0, '0'),         -- Loads 0x0000
                ("1101", '1', '0', '0', X"10", SEG_1, '0'),         -- Loads 0x0010
                ("1101", '1', '0', '0', X"20", SEG_2, '0'),         -- Loads 0x0020
                ("1101", '1', '0', '0', X"30", SEG_3, '0'),         -- Loads 0x0030
                ("1101", '1', '0', '0', X"40", SEG_4, '0'),         -- Loads 0x0040
                ("1101", '1', '0', '0', X"50", SEG_5, '0'),         -- Loads 0x0050
                ("1101", '1', '0', '0', X"60", SEG_6, '0'),         -- Loads 0x0060
                ("1101", '1', '0', '0', X"70", SEG_7, '0'),         -- Loads 0x0070
                ("1101", '1', '0', '0', X"80", SEG_8, '0'),         -- Loads 0x0080
                ("1101", '1', '0', '0', X"90", SEG_9, '0'),         -- Loads 0x0090
                ("1101", '1', '0', '0', X"A0", SEG_A, '0'),         -- Loads 0x00A0
                ("1101", '1', '0', '0', X"B0", SEG_B, '0'),         -- Loads 0x00B0
                ("1101", '1', '0', '0', X"C0", SEG_C, '0'),         -- Loads 0x00C0
                ("1101", '1', '0', '0', X"D0", SEG_D, '0'),         -- Loads 0x00D0
                ("1101", '1', '0', '0', X"E0", SEG_E, '0'),         -- Loads 0x00E0
                ("1101", '1', '0', '0', X"F0", SEG_F, '0'),         -- Loads 0x00F0
                -- Subtraction tests
                ("1110", '1', '0', '0', X"00", SEG_0, '0'),         -- Loads 0x0000
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_F, '1'),    -- 0xFFFF NOTE: Underflow activates carry
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_E, '0'),    -- 0xFFFE
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_D, '0'),    -- 0xFFFD
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_C, '0'),    -- 0xFFFC
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_B, '0'),    -- 0xFFFB
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_A, '0'),    -- 0xFFFA
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_9, '0'),    -- 0xFFF9
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_8, '0'),    -- 0xFFF8
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_7, '0'),    -- 0xFFF7
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_6, '0'),    -- 0xFFF6
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_5, '0'),    -- 0xFFF5
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_4, '0'),    -- 0xFFF4
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_3, '0'),    -- 0xFFF3
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_2, '0'),    -- 0xFFF2
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_1, '0'),    -- 0xFFF1
                ("1110", '0', '1', '0', "XXXXXXXX", SEG_0, '0'),     -- 0xFFF0
                -- Addition tests
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_1, '0'),    -- 0xFFF1
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_2, '0'),    -- 0xFFF2
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_3, '0'),    -- 0xFFF3
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_4, '0'),    -- 0xFFF4
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_5, '0'),    -- 0xFFF5
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_6, '0'),    -- 0xFFF6
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_7, '0'),    -- 0xFFF7
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_8, '0'),    -- 0xFFF8
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_9, '0'),    -- 0xFFF9
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_A, '0'),    -- 0xFFFA
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_B, '0'),    -- 0xFFFB
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_C, '0'),    -- 0xFFFC
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_D, '0'),    -- 0xFFFD
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_E, '0'),    -- 0xFFFE
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_F, '0'),    -- 0xFFFF
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_0, '1'),    -- 0x0000
                ("1110", '0', '0', '1', "XXXXXXXX", SEG_1, '0')     -- 0x0001                
            );
        BEGIN
            ASSERT FALSE REPORT "starting test for std_counter..." SEVERITY note;
            FOR i IN testtab'RANGE LOOP
                WAIT UNTIL clk'EVENT AND clk = '1';
                BTN0 <= testtab(i).BTN0;
                BTN1 <= testtab(i).BTN1;
                BTN2 <= testtab(i).BTN2;
                sw   <= testtab(i).sw;
                FOR j IN 0 TO 5 * (2 ** 15) LOOP
                    WAIT UNTIL clk'EVENT AND clk = '1';
                END LOOP;
                BTN0 <= '0';
                BTN1 <= '0';
                BTN2 <= '0';
                FOR j IN 0 TO 5 * (2 ** 15) LOOP
                    WAIT UNTIL clk'EVENT AND clk = '1';
                END LOOP;
                WAIT UNTIL clk'EVENT AND clk = '1' AND an = testtab(i).an;
                ASSERT seg = testtab(i).seg REPORT "wrong segment, i=" & integer'IMAGE(i) SEVERITY error;
                ASSERT LD0 = testtab(i).LD0 REPORT "wrong carry out, i=" & integer'IMAGE(i) SEVERITY error;
            END LOOP;
        END PROCEDURE;

        PROCEDURE test_sync_buffer IS
        BEGIN
            ASSERT FALSE REPORT "starting test for sync_buffer..." SEVERITY note;
            -- TODO: implement test
        END PROCEDURE;

        PROCEDURE test_sync_module IS
        BEGIN
            ASSERT FALSE REPORT "starting test for sync_module..." SEVERITY note;
            -- TODO: implement test
        END PROCEDURE;

        PROCEDURE test_aufgabe2 IS
        BEGIN
            ASSERT FALSE REPORT "starting test for aufgabe2..." SEVERITY note;
            -- TODO: implement test
        END PROCEDURE;
    BEGIN
        WAIT UNTIL clk'EVENT AND clk = '1' AND rst = (NOT RSTDEF);

        test_std_counter;
        test_sync_buffer;
        test_sync_module;
        test_aufgabe2;

        ASSERT FALSE REPORT "all tests completed" SEVERITY note;

        hlt <= '1';
        WAIT;
    END PROCESS;

END test;
