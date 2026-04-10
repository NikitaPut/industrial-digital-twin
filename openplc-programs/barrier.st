PROGRAM BarrierControl
VAR
    // Входы от Java модели (через Modbus)
    OpenCmd AT %IX0.0 : BOOL;      // Команда открыть
    CloseCmd AT %IX0.1 : BOOL;     // Команда закрыть
    
    // Выходы на Java модель
    Angle AT %QW0 : INT;            // Угол стрелы (0-900 = 0-90°)
    LimitOpen AT %QX0.0 : BOOL;     // Концевик открыт
    LimitClosed AT %QX0.1 : BOOL;   // Концевик закрыт
    Error AT %QX0.2 : BOOL;         // Флаг ошибки
    
    // Внутренние переменные
    currentAngle : INT := 0;
END_VAR

// Логика управления шлагбаумом
IF OpenCmd AND CloseCmd THEN
    // ОШИБКА: обе команды одновременно
    Error := TRUE;
    LimitOpen := FALSE;
    LimitClosed := FALSE;
    
ELSIF OpenCmd AND NOT Error THEN
    // Движение вверх
    IF currentAngle < 900 THEN
        currentAngle := currentAngle + 100;  // +10° за шаг
    END_IF;
    
    // Проверка концевика
    IF currentAngle >= 900 THEN
        currentAngle := 900;
        LimitOpen := TRUE;
        LimitClosed := FALSE;
    END_IF;
    
ELSIF CloseCmd AND NOT Error THEN
    // Движение вниз
    IF currentAngle > 0 THEN
        currentAngle := currentAngle - 100;  // -10° за шаг
    END_IF;
    
    // Проверка концевика
    IF currentAngle <= 0 THEN
        currentAngle := 0;
        LimitClosed := TRUE;
        LimitOpen := FALSE;
    END_IF;
    
ELSE
    // Нет ошибки, стоим на месте
    Error := FALSE;
END_IF;

// Запись угла на выход
Angle := currentAngle;
END_PROGRAM

// Конфигурация задач
TASK MainTask(INTERVAL := T#100ms, PRIORITY := 1);
PROGRAM INSTANCE BarrierControl WITH MainTask;
END_CONFIGURATION
