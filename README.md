# Digital-Alarm-Clock-Using-8051-Microcontroller
The project focuses on creating a digital alarm clock using an 8051 microcontroller. The system includes an LCD, a keypad for user input, and a buzzer for alarm. The program uses assembly language to manage timekeeping and alarm functions, including setting alarm time, triggering audible alarms, and interfacing with hardware components.

# Introduction:
The way we use timepieces has changed dramatically as a result of technology becoming more and more integrated into daily life. An essential device in nearly every home is the alarm clock, a timeless friend that helps us get started in the morning.
A fascinating project in the field of embedded systems and microcontroller applications is making a digital alarm clock. The project makes use of the 8051 microcontroller, a well-known and adaptable chip that is frequently utilized in embedded systems because of its durability and adaptability.

# Objective:
This project's main goal is to use the 8051 microcontroller to create a multipurpose digital alarm clock with functions that go beyond simple timekeeping. This includes the capability to incorporate extra features like a stopwatch, set alarms, and show information about the current time on the clock.

# Required Components:
In order to accomplish the intended functionality, the project focuses on combining a variety of hardware components with the 8051 microprocessor. The following synchronization is essential to this endeavor:
- Microcontroller (8051): The central nervous system, carrying out commands and overseeing the system's general operation.
- LCD Display: Showing the time, alarms, and pertinent messages on a user-friendly interface.
- Keypad Interface: Enabling user interactions to adjust the time, set alarms, and operate different clock features.
- Buzzer/Alarm Output: Notifying users of the occurrence of an alarm, enabling snooze features or other user-specified actions.

# Circuit Diagram:
![image](https://github.com/user-attachments/assets/bd0cde84-cd43-44a3-bf78-3766ed551e26)

# Features:
We had three mandatory features, they are:
- Use of display to show outputs, use of keypad to take input from the user, use of loud sound to alert the user during alarm.
- Stopwatch – A user can use this clock when he/she needs stopwatch-based works. For this you timing calculation should be very precise.
- Solving a logical problem to turn off the alarm buzzer.

**Additional Features:**
- Change in alarm tune when snooze is ringing.
- LED check whether alarm is set or not.

Now we give a detailed overview of how we have implemented these features:

# Hardware Setup:
**1.Pin Definitions:**
- **LCD_PORT**: Connects to the LCD display via Port 1.
- **LCD_RS:** Control pin for LCD (P3.0).
- **LCD_ENABLE:** Enable pin for LCD (P3.1).
- **KEY_PORT:** Keypad interface connected to Port 2.
- **BUZZER:** Pin for the buzzer (P3.7).
- **ALRMSET:** LED set pin for alarm indication (P3.6).

**2.Data Definitions:**
a. Memory locations for various variables like timers, alarm data, mode flags, solution data, etc.
b. String literals for messages to be displayed on the LCD.

# Main Program Flow:
1. Initiaization:
   - Hardware initialization and variable setup.
   - Timer configuration for the real-time clock and stopwatch.
2. Main Loop:
- Continuously scans the keypad and processes user inputs.
- Performs actions based on the mode and user interaction.

3. User Interface Modes:
- **Stopwatch Mode:** Starts/stops the stopwatch, displays elapsed time.
- **Clock Mode:** Displays real-time clock.
- **Edit Time Mode:** Allows editing of the time.
- **Alarm Setup Mode:** Enables setting the alarm time.
- **Alarm Resolution Mode:** Resolves the alarm, snooze functionality.

4. Actions and Display Functions:
- Display functions for presenting stopwatch, clock, edit time, alarm setup, etc., on the LCD.
- Keypad input handling functions to capture user interactions.
- Timer interrupt service routines (ISR) for updating the clock and handling the buzzer/alarm.
- Utility functions for conversions, copying data, generating random numbers, delays, etc.

# Display Function:
- **DISPLAY_STOPWATCH:** Formats and shows stopwatch data on the LCD.
- **DISPLAY_CLOCK:** Displays real-time clock data.
- **DISPLAY_EDITTIME:** Shows time-editing interface on the LCD.
- **DISPLAY_ALARMTIME:** Displays alarm setup interface.
- **DISPLAY_SOLUTION:** Shows alarm resolution interface.

# Key Handling Function:
- **KEY_TAKE_TIME:** Captures user input for time editing.
- **KEY_TAKE_ALRM:** Captures input for setting the alarm.
- **KEY_TAKE_STOPWATCH:** Handles stopwatch control input.
- **KEY_TAKE_SOLUTION:** Handles alarm resolution input.

# Timer Interrupt Service Routines:
- **TIMER0ISR:** Updates the real-time clock.
- **TIMER1ISR:** Handles buzzer and alarm functionality.

# Utilities:
- **NUM2ASCII:** Converts numerical values to ASCII characters.
- Functions for copying data, generating random numbers, delays, etc.

# Alarm Functionality:
1. **Alarm Setup:** Checks if the current time matches the set alarm time.

# Alarm Resolution:
- Resolves the alarm trigger, allows snooze functionality.
- Handles the buzzer to alert the user.

# Flowchart:
![image](https://github.com/user-attachments/assets/38f5c0f3-b210-499a-b688-e943d48e4189)

# Hardware Implementation:
![image](https://github.com/user-attachments/assets/6e9e0cbc-54c4-4144-b3ef-1880422d852e)

# Problem Faced:
- **RTC couldn’t be achieved:** The microcontroller board doesn’t have the RTC model included on board. So, we had to skip the RTC part and complete the project with a constant delay for each second.
- **Double Click problem in Proteus:** In case of software implementation, while entering the initial clock values, we faced double click problem.
- **Time Setting Problem in Hardware:** After setting the time initially, if we need to change the time it becomes problematic and the whole circuit needs to reset.
- **Random Problem to turn off the Alarm:** Although the problem was supposed to be generate an equation between any two random numbers. But it is always generating 12+2 and 14+1. It is not causing any problem to the circuitry; however, the problem arises as to generate the RNG we took the initial TL0 value to generate the number.
