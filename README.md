## Design of (RV-32I ISA) RISC-V Processor on Verilog HDL
Feature list:
- All 37 instruction of R,I,J,S,B,U Format are implemented
- All cases of ”Data Dependency” is checked and Forwarding unit is optimized to address all ”Data Hazard”
- Bubble insertion technique is used to address ”Control Hazard”
- Minimum frequency obtained is 85.84 MHz with 4897 LUT, 4543 FF and 130 IO
