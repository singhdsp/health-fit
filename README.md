# 💪 HealthFit App

**HealthFit** is a mobile application developed to work seamlessly with our custom-built **HealthFit hardware**, which integrates an **STM32 microcontroller**, **ESP8266 Wi-Fi module**, **MLX90614 infrared temperature sensor**, and **MAX30100 pulse oximeter and heart-rate sensor**.

The hardware collects real-time health data and sends it to the cloud, while the app provides users with a smooth, intuitive interface to view live data, track history, and monitor overall wellness.


## 🧠 What It Does

- Connects to a cloud server that receives data from the HealthFit hardware.
- Displays **live health metrics** including:
  - Body temperature (from MLX90614)
  - Heart rate & SpO₂ levels (from MAX30100)
- Visualizes health history with easy-to-understand graphs.
- Helps users track wellness trends over time.


## 🔗 Hardware Overview

The **HealthFit hardware** includes:
- **STM32** – Central controller for data acquisition and communication.
- **ESP8266** – Sends sensor data to the cloud via Wi-Fi.
- **MLX90614** – Non-contact IR temperature sensor.
- **MAX30100** – Pulse oximeter and heart-rate monitoring sensor.