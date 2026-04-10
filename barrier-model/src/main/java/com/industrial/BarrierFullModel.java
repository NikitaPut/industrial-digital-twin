package com.industrial;

import java.util.Scanner;

public class BarrierFullModel {
    private double angle = 0;
    private boolean errorState = false;
    private boolean limitOpen = false;
    private boolean limitClosed = true;
    
    public static void main(String[] args) throws Exception {
        BarrierFullModel barrier = new BarrierFullModel();
        
        System.out.println("==========================================");
        System.out.println("МОДЕЛЬ ШЛАГБАУМА");
        System.out.println("==========================================");
        System.out.println("Команды: o-открыть, c-закрыть, e-ошибка, r-сброс, q-выход");
        
        Scanner scanner = new Scanner(System.in);
        
        while (true) {
            System.out.print("> ");
            String cmd = scanner.nextLine().toLowerCase();
            
            switch (cmd) {
                case "o": barrier.update(true, false); break;
                case "c": barrier.update(false, true); break;
                case "e": barrier.update(true, true); break;
                case "r": barrier.resetError(); break;
                case "q": System.out.println("Выход..."); scanner.close(); return;
                default: System.out.println("Неизвестная команда");
            }
            barrier.printStatus();
        }
    }
    
    public void update(boolean openCmd, boolean closeCmd) {
        if (openCmd && closeCmd) {
            errorState = true;
            System.err.println("ОШИБКА: получены обе команды!");
            return;
        }
        if (errorState) {
            System.err.println("Шлагбаум в ошибке! Нажмите r");
            return;
        }
        if (openCmd && angle < 90 && !limitOpen) {
            angle = Math.min(90, angle + 10);
            if (angle >= 90) {
                limitOpen = true;
                limitClosed = false;
                System.out.println("Концевик ОТКРЫТ");
            }
        } else if (closeCmd && angle > 0 && !limitClosed) {
            angle = Math.max(0, angle - 10);
            if (angle <= 0) {
                limitClosed = true;
                limitOpen = false;
                System.out.println("Концевик ЗАКРЫТ");
            }
        }
    }
    
    public void resetError() {
        errorState = false;
        System.out.println("Ошибка сброшена");
    }
    
    public void printStatus() {
        String bar = "";
        int filled = (int)(angle / 10);
        for (int i = 0; i < filled; i++) bar += "#";
        for (int i = filled; i < 9; i++) bar += ".";
        
        System.out.printf("Угол: %3.0f [%s] | Открыт:%s | Закрыт:%s | Ошибка:%s%n",
            angle, bar, limitOpen ? "ДА" : "НЕТ", limitClosed ? "ДА" : "НЕТ", errorState ? "ЕСТЬ" : "НЕТ");
    }
}
