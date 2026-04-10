// Программа управления шлагбаумом
// Угол меняется от 0 до 90 градусов

VAR_GLOBAL
    // Входные команды
    OpenCmd AT %IX0.0 : BOOL;      // Команда открыть
    CloseCmd AT %IX0.1 : BOOL;     // Команда закрыть
    
    // Выходные сигналы
    Angle AT %QW0 : INT;            // Текущий угол (0-900 = 0-90.0°)
    LimitOpen AT %QX0.0 : BOOL;     // Концевик открыт
    LimitClosed AT %QX0.1 : BOOL;   // Концевик закрыт
    ErrorFlag AT %QX0.2 : BOOL;     // Флаг ошибки
END_VAR

VAR
    currentAngle : INT := 0;
    lastOpenCmd : BOOL := FALSE;
    lastCloseCmd : BOOL := FALSE;
END_VAR

// Основная логика
// Проверка на одновременные команды
IF OpenCmd = TRUE AND CloseCmd = TRUE THEN
    ErrorFlag := TRUE;
    LimitOpen := FALSE;
    LimitClosed := FALSE;
    
ELSIF ErrorFlag = TRUE THEN
    // В ошибке - ничего не делаем
    // Нужен сброс перезагрузкой
    
ELSIF OpenCmd = TRUE AND lastOpenCmd = FALSE THEN
    // Открываем
    IF currentAngle < 900 THEN
        currentAngle := currentAngle + 100;
        LimitClosed := FALSE;
    END_IF;
    
    // Проверка концевика открыто
    IF currentAngle >= 900 THEN
        currentAngle := 900;
        LimitOpen := TRUE;
    END_IF;
    
    lastOpenCmd := TRUE;
    lastCloseCmd := FALSE;
    
ELSIF CloseCmd = TRUE AND lastCloseCmd = FALSE THEN
    // Закрываем
    IF currentAngle > 0 THEN
        currentAngle := currentAngle - 100;
        LimitOpen := FALSE;
    END_IF;
    
    // Проверка концевика закрыто
    IF currentAngle <= 0 THEN
        currentAngle := 0;
        LimitClosed := TRUE;
    END_IF;
    
    lastCloseCmd := TRUE;
    lastOpenCmd := FALSE;
    
ELSE
    // Обновляем последние команды
    lastOpenCmd := OpenCmd;
    lastCloseCmd := CloseCmd;
END_IF;

// Записываем угол на выход
Angle := currentAngle;

END_PROGRAM

// Конфигурация задачи
TASK Main(INTERVAL := T#100ms, PRIORITY := 1);
PROGRAM Instance WITH Main;
END_CONFIGURATION
