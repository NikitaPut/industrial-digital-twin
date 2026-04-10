PROGRAM BarrierSimple
VAR
    OpenCmd AT %IX0.0 : BOOL;
    CloseCmd AT %IX0.1 : BOOL;
    Angle AT %QW0 : INT;
    LimitOpen AT %QX0.0 : BOOL;
    LimitClosed AT %QX0.1 : BOOL;
    Error AT %QX0.2 : BOOL;
    angle_val : INT := 0;
END_VAR

IF OpenCmd = TRUE AND CloseCmd = TRUE THEN
    Error := TRUE;
ELSIF OpenCmd = TRUE AND Error = FALSE THEN
    IF angle_val < 900 THEN
        angle_val := angle_val + 100;
    END_IF;
    LimitClosed := FALSE;
    IF angle_val >= 900 THEN
        angle_val := 900;
        LimitOpen := TRUE;
    END_IF;
ELSIF CloseCmd = TRUE AND Error = FALSE THEN
    IF angle_val > 0 THEN
        angle_val := angle_val - 100;
    END_IF;
    LimitOpen := FALSE;
    IF angle_val <= 0 THEN
        angle_val := 0;
        LimitClosed := TRUE;
    END_IF;
END_IF

Angle := angle_val;
END_PROGRAM

TASK Main(INTERVAL := T#100ms, PRIORITY := 1);
PROGRAM P1 WITH Main;
END_CONFIGURATION
