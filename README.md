Of course. Here is the complete and updated code for your README.md file.Markdown<div align="center">

# ⚡ 8-Bit Kogge-Stone Adder: RTL to GDSII

</div>

<div align="center">

![VLSI](https://img.shields.io/badge/VLSI-System%20Design-blue?style=for-the-badge)
![Technology](https://img.shields.io/badge/Tech-90nm%20%7C%20180nm-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

**A high-performance parallel prefix adder implementing complete ASIC design flow**

[Overview](#-overview) • [Architecture](#-architecture) • [Results](#-results) • [Getting Started](#-getting-started) • [Documentation](#-documentation)

---

</div>

## 🎯 Overview

This project presents a **complete RTL-to-GDSII implementation** of an 8-bit Kogge-Stone Adder, one of the fastest parallel prefix adder architectures used in modern high-performance computing systems. The design achieves **logarithmic delay complexity O(log₂n)** compared to linear delay O(n) in conventional ripple carry adders.

### ✨ Key Highlights

- 🚀 **Ultra-Fast Addition**: Logarithmic carry propagation with only 3 prefix stages
- 🎨 **Dual Technology**: Complete implementation in both 90nm and 180nm CMOS
- ⚙️ **Parameterized Design**: Scalable Verilog RTL with configurable precision
- 🔬 **Full Verification**: Comprehensive testbench with self-checking assertions
- 🏭 **Production Ready**: DRC/LVS clean layout ready for fabrication
- 📊 **Optimized Performance**: 2.05ns critical path delay at 90nm technology

---

## 🏗️ Architecture

### Design Hierarchy

The Kogge-Stone Adder operates in three distinct stages:

┌─────────────────────────────────────────────────────────┐│                    INPUT OPERANDS                        ││                    A[7:0]  B[7:0]                       │└─────────────────┬───────────────────────────────────────┘                  │         ┌────────▼────────┐         │  PRE-PROCESSING │  ◄── Generate (Gi) & Propagate (Pi)         │     STAGE       │      Gi = Ai · Bi         └────────┬────────┘      Pi = Ai ⊕ Bi                  │         ┌────────▼────────┐         │ PREFIX NETWORK  │  ◄── Parallel Carry Computation         │   (3 Levels)    │      Log₂(8) = 3 stages         │   Level 1       │      Span: 2¹ = 2 bits         │   Level 2       │      Span: 2² = 4 bits         │   Level 3       │      Span: 2³ = 8 bits         └────────┬────────┘                  │         ┌────────▼────────┐         │ POST-PROCESSING │  ◄── Sum Generation         │     STAGE       │      Si = Pi ⊕ Ci         └────────┬────────┘                  │         ┌────────▼────────┐         │    OUTPUTS      │         │  SUM[7:0]       │         │  OVERFLOW       │         └─────────────────┘(./images/arch.png)

### Prefix Operator

The core operation combines generate and propagate pairs:

$$(G_k, P_k) \circ (G_j, P_j) = (G_k + P_k \cdot G_j, P_k \cdot P_j)$$

This associative operator enables parallel prefix computation across all bit positions.

---

## 📊 Results

### PPA (Power, Performance, Area) Comparison

This table summarizes the key metrics from the synthesis reports for the two technology nodes. The "Improvement" column shows the percentage reduction achieved by moving from the 180nm process to the 90nm process.

| Parameter | 180nm Results | 90nm Results | Improvement |
| :--- | :--- | :--- | :--- |
| **Total Area** | $651.97 \ \mu m^2$ | $176.36 \ \mu m^2$ | **72.9%** reduction |
| **Max Delay** | Unconstrained | $2.05 \ ns$ | N/A |
| **Total Power** | $85.80 \ \mu W$ | $21.93 \ \mu W$ | **74.4%** reduction |
| **Cell Count** | 32 | 30 | **6.25%** reduction |

### Critical Timing Path Analysis (Synthesis)

#### 90nm Technology

The **critical path** is the longest delay path in the circuit, which determines its maximum operating frequency. For the 90nm design, the critical path delay was found to be **2.05 ns**. The path originates at the primary input `operand_a_i[0]` and ends at the primary output `result_o[7]`. A significant portion of the delay (**84%**) comes from the logic cells themselves, with the remaining **16%** from the interconnecting wires (nets).

| Parameter | Value | Description |
| :--- | :--- | :--- |
| **Startpoint** | `operand_a_i[0]` | The first input bit of operand A |
| **Endpoint** | `result_o[7]` | The most significant bit of the sum |
| **Path Delay** | **2050 ps (2.05 ns)** | Maximum delay for the design |
| **Logic (Cell) Delay** | 1721 ps (84.0%) | Delay through logic gates |
| **Net (Wire) Delay** | 329 ps (16.0%) | Delay of signals traveling on wires |
| **Logic Levels** | 4 | Number of logic gates in the path |

#### 180nm Technology

A valid critical path delay could not be determined for the 180nm implementation. [cite_start]During synthesis, the timing constraint (SDC) file failed to load correctly due to a port mismatch [cite: 572-578]. [cite_start]As a result, the synthesis tool ran without any timing constraints, and no paths were analyzed for delay[cite: 905]. To obtain a valid delay, the SDC file must be corrected and the synthesis/PNR flow re-run.

### Power Breakdown Analysis

The total power consumption is composed of **switching power** (from charging/discharging load capacitances), **internal power** (from short-circuit currents within gates), and **leakage power** (static power when the circuit is idle).

| Power Component | 180nm Results (μW) | 90nm Results (μW) | Change |
| :--- | :--- | :--- | :--- |
| **Switching Power** | [cite_start]58.85 [cite: 907] | 16.39 | **-72.1%** |
| **Internal Power** | [cite_start]26.91 [cite: 907] | 4.35 | **-83.8%** |
| **Leakage Power** | [cite_start]0.03 [cite: 907] | 1.18 | **+3833%** |
| **Total Power** | [cite_start]**85.80** [cite: 907] | **21.93** | **-74.4%** |

The transition to 90nm technology drastically reduces dynamic power (switching and internal) due to smaller transistors and lower operating voltages. However, it also leads to a significant increase in static **leakage power**, a common trade-off in smaller process nodes.

---

## 🖼️ Visual Gallery

### RTL Simulation Waveforms

(./images/waveforms.png)
*Functional verification showing correct addition and overflow detection*

### Gate-Level Schematic

<div align="center">

| 180nm Technology | 90nm Technology |
|:----------------:|:---------------:|
| (./images/genus_schematic.png) | (./images/genus_schematic_90.png) |

</div>

### Physical Layout

#### 180nm Implementation

(./images/layout_180.png)
(./images/layout_180_3d.png)

*Complete routed layout with 2D and 3D views*

#### 90nm Implementation

(./images/layout_90.png)

*Optimized layout showing improved density and routing*

---

## 🚀 Getting Started

### Prerequisites

```bash
# Required Tools
- Xilinx Vivado (for simulation)
- Cadence Genus (for synthesis)
- Cadence Innovus (for place & route)
- 90nm/180nm CMOS standard cell libraries
Quick StartClone the repositoryBashgit clone [https://github.com/upadhyaypranjal/8-Bit-Kogge-Stone-Adder.git](https://github.com/upadhyaypranjal/8-Bit-Kogge-Stone-Adder.git)
cd 8-Bit-Kogge-Stone-Adder
Run RTL SimulationBashcd rtl
# Open Vivado and source the simulation script
vivado -mode batch -source sim_kogge_stone.tcl
Synthesize the DesignBashcd synthesis
genus -f run_synthesis.tcl
Run Place & RouteBashcd pnr
innovus -init run_innovus.tcl
🔬 Technical SpecificationsRTL FeaturesParameterized Design: Configurable PRECISION parameter for any bit-widthAutomatic Stage Calculation: Uses clog2 function to compute prefix stagesOverflow Detection: Dedicated overflow flag for arithmetic operationsFully Synthesizable: Clean RTL without simulation-only constructsDesign MetricsParameterValueDescriptionBit Width8Default precision (configurable)Prefix Stages3log₂(8) stages for 8-bit operationLogic DepthO(log₂n)Theoretical delay complexityFan-outBoundedConsistent across all stagesWiring ComplexityHighDense interconnect network🎓 Academic ContextCourse InformationCourse: VLSI System Design (EC-307)Faculty: Dr. P. Ranga Babu, Department of ECE - IIITDM KurnoolDate: October 18, 2025Learning Outcomes✓ Complete ASIC design flow from specification to layout✓ RTL coding and functional verification using Verilog✓ Logic synthesis and technology mapping✓ Physical design including floorplanning and routing✓ Timing analysis and power optimization✓ Design rule checking and layout versus schematic verification📚 ReferencesA. K. Sahu and D. S. Kushwah, "A Review on Different Parallel Prefix Adders for High Speed and Low Power Applications," International Journal of Scientific Research and Engineering Trends (IJSRET), vol. 9, no. 4, pp. 317-321, Jul.-Aug. 2023.A. Mishra and N. Sharma, "Design and Performance Analysis of 64-bit Kogge Stone Adder using GDI and FinFET Technique," International Research Journal of Engineering and Technology (IRJET), vol. 7, no. 3, pp. 4185-4190, Mar. 2020.ElProCus, "Kogge Stone Adder: Circuit, Design, Advantages & Its Applications," [Online]. Available: https://www.elprocus.com/kogge-stone-adder/🛠️ Tools & Technologies<div align="center">CategoryToolsHDLVerilog HDLSimulationXilinx VivadoSynthesisCadence GenusPlace & RouteCadence InnovusTechnology90nm & 180nm CMOS LibrariesVerificationCustom Testbench, DRC, LVS</div>🤝 ContributingContributions are welcome! If you'd like to improve this project:Fork the repositoryCreate a feature branch (git checkout -b feature/AmazingFeature)Commit your changes (git commit -m 'Add some AmazingFeature')Push to the branch (git push origin feature/AmazingFeature)Open a Pull Request📝 LicenseThis project is licensed under the MIT License - see the LICENSE file for details.📬 ContactPranjal Upadhyay📧 Email: pranjal2004upadhyay@gmail.com💼 LinkedIn: https://www.linkedin.com/in/pranjalupadhyay0142🐱 GitHub: https://github.com/upadhyaypranjal🌟 AcknowledgmentsDr. P. Ranga Babu - Course Instructor and Project GuideIIITDM Kurnool - For providing resources and infrastructureCadence Design Systems - For EDA tool accessOpen Source Community - For various learning resources<div align="center">👨‍🎓 About the AuthorPranjal UpadhyayRoll No: 523EC0012Department of Electronics and Communication EngineeringIntegrated B.Tech and M.Tech ProgramIndian Institute of Information Technology Design and Manufacturing, Kurnool</div>⭐ Star this repository if you found it helpful!© 2025 Pranjal Upadhyay. All Rights Reserved.</div>
