package com.industrial;

import java.util.Timer;
import java.util.TimerTask;

public class WaterMixerModel {
    private double temperature = 20;
    private double hotFlow = 50;
    private double coldFlow = 0;
    private boolean pidActive = false;
    private boolean alertSent = false;
    
    public static void main(String[] args) {
        WaterMixerModel mixer = new WaterMixerModel();
        mixer.start();
    }
    
    public void start() {
        System.out.println("==========================================");
        System.out.println("УЗЕЛ СМЕШИВАНИЯ ВОДЫ");
        System.out.println("==========================================");
        System.out.println();
        
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            public void run() {
                simulate();
                print();
            }
        }, 0, 1000);
    }
    
    private void simulate() {
        // Нагрев до 80°C
        if (!pidActive && temperature < 80) {
            temperature = Math.min(80, temperature + 2);
            
            // Алерт при 60°C
            if (temperature >= 60 && !alertSent) {
                System.out.println("\n🚨 АЛЕРТ! Температура: " + temperature + "°C");
                System.out.println("🔥 Активация ПИД-регулятора\n");
                pidActive = true;
                alertSent = true;
            }
        }
        
        // ПИД-регулятор охлаждает до 40°C
        if (pidActive && temperature > 40) {
            coldFlow = Math.min(100, coldFlow + 10);
            hotFlow = Math.max(0, hotFlow - 5);
            temperature = Math.max(40, temperature - 1);
            
            if (temperature <= 40.5) {
                System.out.println("\n✅ Стабилизация на 40°C");
            }
        }
    }
    
    private void print() {
        System.out.printf("🌡️ %.1f°C | 🔥 %.0f | ❄️ %.0f | 💧 %.0f | ПИД: %s%n",
            temperature, hotFlow, coldFlow, hotFlow + coldFlow, pidActive ? "АКТИВЕН" : "ВЫКЛ");
    }
}
