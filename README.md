# ⏰ Digital Alarm Clock Using 8051 Microcontroller

This project implements a **digital alarm clock** using the **8051 microcontroller**, showcasing the capabilities of embedded systems and assembly language programming. The clock features an LCD display, keypad input, and a buzzer for alarms, making it a comprehensive and educational application of the 8051 microcontroller.

---

## 📜 **Introduction**

With the integration of technology into daily life, the alarm clock remains an essential tool for starting our day. This project builds a **digital alarm clock** powered by the **8051 microcontroller**, a versatile and reliable chip often used in embedded systems.

---

## 🎯 **Objective**

The primary goal is to create a multifunctional digital alarm clock with the following capabilities:
- **Timekeeping**: Display the current time.
- **Alarm Functionality**: Set and trigger alarms with user-defined conditions.
- **Stopwatch Mode**: Provide precise stopwatch functionality.
- **Interactive Interface**: Enable user input via a keypad and provide visual feedback through an LCD.

---

## 🔧 **Required Components**

- **Microcontroller (8051)**: The core component for managing timekeeping and system operations.
- **LCD Display**: Displays time, alarms, and user messages.
- **Keypad Interface**: Captures user input for setting time, alarms, and controlling features.
- **Buzzer**: Alerts the user when the alarm is triggered.
- **LED**: Indicates whether an alarm is set.

---

## ⚙️ **Features**

### **Mandatory Features**
1. **User Interface**:
   - Display time, alarms, and stopwatch on an LCD.
   - Accept user input via a keypad.
   - Audible alarm via a buzzer.

2. **Stopwatch Functionality**:
   - Accurate timing for stopwatch-based tasks.
   - Stopwatch display on the LCD.

3. **Alarm Handling**:
   - Logical problem-solving interface to turn off the alarm.

### **Additional Features**
- **Snooze with Tune Change**: The alarm tune changes during snooze.
- **LED Alarm Indicator**: An LED indicates whether the alarm is active.

---

## 🛠️ **Hardware Setup**

### **Pin Definitions**
- **LCD_PORT**: Connected to Port 1.
- **LCD_RS & LCD_ENABLE**: Control pins (P3.0 and P3.1).
- **KEY_PORT**: Keypad interface via Port 2.
- **BUZZER**: Alarm output connected to P3.7.
- **ALRMSET LED**: Alarm indication via P3.6.

### **Circuit Diagram**
![Circuit Diagram](https://github.com/user-attachments/assets/bd0cde84-cd43-44a3-bf78-3766ed551e26)

---

## 📂 **Program Overview**

### **Main Program Flow**
1. **Initialization**:
   - Setup hardware and variables.
   - Configure timers for real-time clock and stopwatch.
   
2. **Main Loop**:
   - Scan the keypad and process user inputs.
   - Execute actions based on the current mode (clock, alarm, or stopwatch).

3. **Modes of Operation**:
   - **Clock Mode**: Displays the real-time clock.
   - **Alarm Mode**: Enables setting and resolving alarms.
   - **Stopwatch Mode**: Provides stopwatch functionality.
   - **Edit Time Mode**: Allows the user to modify the time.

4. **Alarm Resolution**:
   - Logical problem-solving is required to turn off the alarm.
   - Snooze functionality changes the alarm tune.

---

## 📟 **Key Features**

### **Display Functions**
- **Time Display**: Real-time clock and stopwatch on the LCD.
- **Alarm Setup**: Interface for setting alarms.
- **Logical Problem Display**: Interface for resolving the alarm.

### **Key Handling**
- Handles user inputs for:
  - Setting time and alarms.
  - Controlling the stopwatch.
  - Solving the alarm's logical problem.

### **Timer Interrupts**
- **TIMER0ISR**: Updates the real-time clock.
- **TIMER1ISR**: Manages the buzzer and alarm functionality.

### **Utility Functions**
- **NUM2ASCII**: Converts numeric values to ASCII characters.
- **Data Copy**: Copies data for display and processing.
- **Random Number Generation**: Generates numbers for alarm logic problems.

---

## 📉 **Flowchart**
![Flowchart](https://github.com/user-attachments/assets/38f5c0f3-b210-499a-b688-e943d48e4189)

---

## 🛠️ **Hardware Implementation**
![Hardware Implementation](https://github.com/user-attachments/assets/6e9e0cbc-54c4-4144-b3ef-1880422d852e)

---

## 🚧 **Challenges Faced**

1. **Real-Time Clock (RTC) Absence**: The microcontroller board lacked an RTC module, requiring the use of constant delays for second intervals.
2. **Proteus Double Click Issue**: Inputting initial clock values in Proteus caused double-click errors.
3. **Time Setting Reset**: Changing the time required a full circuit reset.
4. **Random Number Issue**: The RNG repeatedly generated identical problems for alarm resolution.

---

## 📝 **Conclusion**

This project demonstrates the integration of hardware and software to create a fully functional **digital alarm clock** using an 8051 microcontroller. Despite challenges, the implementation highlights the versatility of embedded systems and the creative potential of assembly language programming.

---

## 📜 **How to Use**

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/touhidulislam1999/Digital-Alarm-Clock-Using-8051-Microcontroller.git
