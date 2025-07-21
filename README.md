# Automatic Temperature Controller using FSM

This project implements a Finite State Machine (FSM)-based automatic temperature controller in Verilog that intelligently turns **heater** and **cooler** ON/OFF based on current and desired temperature values.

---

## Features</summary>

- FSM with 3 states: `IDLE`, `HEATING`, `COOLING`
- User-configurable temperature and tolerance
- Heater turns ON when temperature is below desired range
- Cooler turns ON when temperature is above desired range
- Fully functional simulation-based testbench with environmental feedback


---

## 📂 File Structure
```

├── Design.v # FSM-based controller logic
├── Simple_TB.v # Simple testbench to verify FSM transitions
├── Testbench.v # Extended testbench with dynamic environment simulation
├── README.md # Project documentation

```

---

## 🧠 FSM Overview

The system operates in three states:

- **IDLE**
  - Trigger: When the temperature is within the range `[desired_temp ± tolerance]`
  - Action: Heater OFF, Cooler OFF

- **HEATING**
  - Trigger: When `current_temp < (desired_temp - tolerance)`
  - Action: Heater ON, Cooler OFF

- **COOLING**
  - Trigger: When `current_temp > (desired_temp + tolerance)`
  - Action: Cooler ON, Heater OFF

### State Transitions Summary

| Present State | Condition Met                            | Next State |
|---------------|-------------------------------------------|------------|
| IDLE          | `current_temp < desired_temp - tol`       | HEATING    |
| IDLE          | `current_temp > desired_temp + tol`       | COOLING    |
| HEATING       | `current_temp >= desired_temp`            | IDLE       |
| COOLING       | `current_temp <= desired_temp`            | IDLE       |

---

## 📈 Waveform Output

A sample simulation output waveform showing transitions between states and the behavior of `heater_on` and `cooler_on` over time.

![Waveform Output](https://github.com/Srikar109755/Auto_Temperature_Controller/blob/main/Outputs1(TestBench)/Waveform.png)

---

## 🔁 FSM State Diagram

The state diagram visually explains how the FSM transitions occur based on temperature conditions.

![FSM Diagram](https://github.com/Srikar109755/Auto_Temperature_Controller/blob/main/Images/FSM1.png)

---

## 🧪 Test Strategy

Two testbenches were used:

- `Simple_TB.v`  
  Quickly tests FSM transitions by manually setting the current/desired temperatures.

- `Testbench.v`  
  Simulates real-world feedback: when heater/cooler is ON, temperature dynamically changes every few cycles. Validates whether the FSM stabilizes around the desired temperature.

### Example Test Cases Used

| Initial Temp | Desired Temp | Tolerance | Expected Action   |
|--------------|--------------|-----------|--------------------|
| 60           | 70           | 2         | Heating activates  |
| 80           | 70           | 2         | Cooling activates  |
| 70           | 70           | 2         | Remain in IDLE     |
| 40           | 70           | 2         | Long heating       |
| 95           | 70           | 2         | Long cooling       |

---

## ✅ How to Run the Simulation

1. Open the project in **Vivado** / **ModelSim** / **GTKWave**.
2. Compile `Design.v` and `Testbench.v`.
3. Simulate for at least **5000 ns** to capture state transitions.
4. View signals: `current_temp`, `desired_temp`, `heater_on`, `cooler_on`, `present_state`.

---

## 📌 Notes

- Temperature changes are delayed to simulate real-world heat dynamics (e.g., heating every 10 cycles).
- The controller logic uses a **Moore FSM** where outputs depend only on the current state.

---

## 📁 License

This project is open-source for educational and personal learning purposes.

---

