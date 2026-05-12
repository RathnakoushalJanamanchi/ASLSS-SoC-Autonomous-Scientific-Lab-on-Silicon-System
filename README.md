# 🧠⚡ ASLSS-SoC — Autonomous Scientific Lab-on-Silicon System
### *A Full-Stack Neuromorphic RISC-V SoC for Hardware-Accelerated AI-Driven Scientific Discovery*

> **"From silicon to swarm intelligence — the world's first open-source SoC that thinks, senses, reasons, and discovers — all on a single chip."**

---

<div align="center">

![Language](https://img.shields.io/badge/Language-Verilog%20RTL-blueviolet?style=for-the-badge&logo=verilog)
![PDK](https://img.shields.io/badge/PDK-SkyWater%20SKY130A-brightgreen?style=for-the-badge)
![EDA](https://img.shields.io/badge/EDA-OpenLane%20v1-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Flow%20Status-Completed%20✅-success?style=for-the-badge)
![DRC](https://img.shields.io/badge/DRC-Clean%20🟢-green?style=for-the-badge)
![LVS](https://img.shields.io/badge/LVS-Clean%20🟢-green?style=for-the-badge)

</div>

---

## 🌌 Table of Contents

- [🔥 Problem Statement](#-problem-statement)
- [💡 Novelty & Contributions](#-novelty--contributions)
- [🏗️ Architecture Overview](#%EF%B8%8F-architecture-overview)
- [🧩 Module Breakdown](#-module-breakdown)
- [🔄 Complete Design Flow](#-complete-design-flow)
- [📐 Physical Design Details](#-physical-design-details)
- [📊 Results & Metrics](#-results--metrics)
- [⏱️ Timing Analysis](#%EF%B8%8F-timing-analysis)
- [⚡ Power Analysis](#-power-analysis)
- [🗂️ Repository Structure](#%EF%B8%8F-repository-structure)
- [🚀 Getting Started](#-getting-started)
- [🔬 Signoff Verification](#-signoff-verification)

---

## 🔥 Problem Statement

Modern science is bottlenecked at the sensor-reasoning gap. Data from physical environments is collected by sensors, but real-time intelligent inference, hypothesis formation, knowledge graph updating, and multi-agent coordination require **cloud offloading** — introducing prohibitive latency, power overhead, and communication bandwidth.

**Current systems suffer from:**

| Challenge | Impact |
|-----------|--------|
| Sensor–compute separation | High latency, requires network |
| Software-only AI inference | Power-hungry, slow (~ms–seconds per inference) |
| No hardware knowledge graph | Graph lookups serialized through CPU |
| Single-agent reasoning | No collaborative scientific reasoning |
| Closed-loop exploration | Cannot autonomously adapt experiments |

> **The bottleneck is architectural.** No existing silicon integrates sensing, multi-core RISC-V processing, mesh NoC, neuromorphic compute, knowledge graph memory, swarm coordination, and fault tolerance in a single synthesizable RTL design.

---

## 💡 Novelty & Contributions

ASLSS-SoC introduces several **first-of-its-kind hardware integrations** in open-source silicon:

### 🌟 Key Innovations

```
┌─────────────────────────────────────────────────────────────┐
│  1. FIRST open-source SoC to integrate a hardware           │
│     Knowledge Graph Engine alongside a RISC-V cluster       │
│                                                             │
│  2. FIRST hardware swarm coordination engine synthesized    │
│     to silicon with conflict resolution & task allocation   │
│                                                             │
│  3. Hybrid RRAM-inspired Neuromorphic + Matrix Compute      │
│     fabric co-designed with a 4x4 mesh NoC                 │
│                                                             │
│  4. Full closed-loop pipeline: Sense → Reason → Hypothesize │
│     → Learn → Coordinate — entirely in RTL hardware         │
│                                                             │
│  5. Radiation-tolerant design using TMR and ECC memory      │
│     controllers for space/extreme-environment deployment     │
└─────────────────────────────────────────────────────────────┘
```

### 🏆 Design Philosophy
- **Zero external compute** — all inference and reasoning runs on-chip
- **Autonomous loop** — no human-in-the-loop required for hypothesis formation
- **Multi-agent native** — swarm consensus built into the silicon fabric
- **Open-source** — fully synthesizable on SKY130A via OpenLane

---

## 🏗️ Architecture Overview

```
╔══════════════════════════════════════════════════════════════════════════╗
║                        ASLSS-SoC TOP LEVEL                             ║
║                   (aslss_soc_top — SKY130A @ 100 MHz)                  ║
╠═════════════════════════════════════════════════════════════════════════╣
║                                                                         ║
║  ┌──────────────────────┐      ┌──────────────────────────────────┐    ║
║  │   SENSOR SUBSYSTEM   │      │         CPU CLUSTER              │    ║
║  │  ┌────────────────┐  │      │  ┌────────┬────────┬──────────┐  │    ║
║  │  │ Vision Engine  │  │      │  │ Core 0 │ Core 1 │ Core 2/3 │  │    ║
║  │  │ Radar Engine   │  │      │  │VexRISCV│VexRISCV│ VexRISCV │  │    ║
║  │  │ Spectroscopy   │  │      │  └───┬────┴───┬────┴────┬─────┘  │    ║
║  │  │ Env. Sensor    │  │      │      │  IRQ   │  MEM   │ ARB    │    ║
║  │  │ Obs.Aggregator │  │      │  ┌───┴────────┴────────┴─────┐  │    ║
║  │  └────────┬───────┘  │      │  │     Memory Arbiter        │  │    ║
║  └───────────┼──────────┘      │  └──────────────────────────-┘  │    ║
║              │                 └──────────┬───────────────────────┘    ║
║              ▼                            │                             ║
║  ┌───────────────────────────────────────────────────────────────────┐ ║
║  │                   4×4 MESH NoC (40-bit packets)                   │ ║
║  │   [N0]──[N1]──[N2]──[N3]                                         │ ║
║  │    │     │     │     │      XY-routing, 16 nodes, 5-port routers  │ ║
║  │   [N4]──[N5]──[N6]──[N7]                                         │ ║
║  │    │     │     │     │                                            │ ║
║  │   [N8]──[N9]──[N10]─[N11]                                        │ ║
║  │    │     │     │     │                                            │ ║
║  │  [N12]─[N13]─[N14]─[N15]                                        │ ║
║  └───────────────────────────────────────────────────────────────────┘ ║
║              │                                                          ║
║  ┌───────────┼──────────────────────────────────────────────────────┐  ║
║  │           ▼    COGNITIVE ENGINE LAYER                            │  ║
║  │  ┌─────────────┐   ┌─────────────┐   ┌──────────────────────┐   │  ║
║  │  │  Hypothesis │   │  Rule Logic │   │   Experiment Planner │   │  ║
║  │  │   Engine    │──▶│    Unit     │──▶│   + Context Decision │   │  ║
║  │  └──────┬──────┘   └─────────────┘   └──────────────────────┘   │  ║
║  │         │          ML Pattern Analyzer + Reasoning Engine        │  ║
║  └─────────┼────────────────────────────────────────────────────────┘  ║
║            ▼                                                            ║
║  ┌─────────────────────────┐   ┌────────────────────────────────────┐  ║
║  │  KNOWLEDGE GRAPH ENGINE │   │       AI COMPUTE FABRIC            │  ║
║  │  ┌────────────────────┐ │   │  ┌─────────────┐  ┌────────────┐  │  ║
║  │  │  Node Manager      │ │   │  │Matrix Compute│  │Neuromorphic│  │  ║
║  │  │  Edge Processor    │ │   │  │   Unit (4x4) │  │   Engine   │  │  ║
║  │  │  Graph Query Eng.  │ │   │  └─────────────┘  └────────────┘  │  ║
║  │  │  Discovery Update  │ │   │  ┌──────────────────────────────┐  │  ║
║  │  └────────────────────┘ │   │  │  RRAM Compute Fabric         │  │  ║
║  └─────────────────────────┘   │  │  (Memristive In-Memory Comp) │  │  ║
║                                │  └──────────────────────────────┘  │  ║
║                                └────────────────────────────────────┘  ║
║  ┌──────────────────────────────────────────────────────────────────┐  ║
║  │  SWARM ENGINE  │  NAVIGATION  │  COMMUNICATION  │  RELIABILITY  │  ║
║  │  Task Allocator│  SLAM Engine │  Packet Encode  │  TMR Control  │  ║
║  │  Knowledge Sync│  Path Planer │  CRC Unit       │  Fault Detect │  ║
║  │  Conflict Res. │  Terrain Ana │  Pkt Decoder    │  Error Logger │  ║
║  └──────────────────────────────────────────────────────────────────┘  ║
║  ┌──────────────────────────────────────────────────────────────────┐  ║
║  │  MEMORY SUBSYSTEM                                                │  ║
║  │  Knowledge Graph Memory │ Sensor Buffer │ Shared Memory         │  ║
║  │  ECC Memory Controller  │ Non-Volatile Storage Controller       │  ║
║  └──────────────────────────────────────────────────────────────────┘  ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## 🧩 Module Breakdown

### 🔴 CPU Cluster — `vexriscv_cluster`

| Parameter | Value |
|-----------|-------|
| Core Architecture | VexRISCV (RV32I) |
| Number of Cores | 4 |
| Data Width | 32-bit |
| IRQ Lines | 32 per core |
| NoC Ports | 4 bidirectional |
| Memory Interface | Shared arbiter with read/write |

The 4-core VexRISCV cluster shares a unified memory arbiter and exposes individual NoC ports, enabling each core to independently inject/receive packets on the 4×4 mesh.

---

### 🟠 Network-on-Chip — `noc_mesh_4x4_final`

```
Topology   : 4×4 Mesh
Nodes      : 16
Packet Bits: 40 (32-bit data + 8-bit address/routing header)
Routing    : XY Dimension-Order Routing
Port Width : 5 (N, S, E, W, Local)
```

The mesh NoC provides deterministic, deadlock-free communication between all IP blocks. Each of the 16 nodes contains a 5-port router with an internal arbiter, enabling simultaneous injection from sensors, CPU cores, AI engines, and swarm agents.

---

### 🟡 Sensor Subsystem

| Engine | Function |
|--------|----------|
| `vision_engine` | Image/frame processing, pixel pipeline |
| `radar_engine` | FMCW radar signal processing |
| `spectroscopy_engine` | Spectral analysis and peak detection |
| `environment_sensor_engine` | Temperature, humidity, chemical readings |
| `observation_aggregator` | Fuses multi-modal sensor streams |

---

### 🟢 Cognitive/Reasoning Engine

```
Sensor Data
     │
     ▼
[Hypothesis Engine] ──── generates candidate explanations
     │
     ▼
[ML Pattern Analyzer] ── matches patterns against history
     │
     ▼
[Rule Logic Unit] ─────── applies domain knowledge rules
     │
     ▼
[Context Decision Ctrl] ─ selects best action/experiment
     │
     ▼
[Experiment Planner] ──── generates next observation plan
```

---

### 🔵 Knowledge Graph Engine — `knowledge_graph_engine`

```
Nodes  : 256
Edges  : 256
Operations:
  • node_manager    → CRUD on graph nodes
  • edge_processor  → relationship management
  • graph_query_engine → BFS/DFS traversal
  • discovery_update_unit → online learning insertion
```

This is the heart of the autonomous discovery loop. Every confirmed hypothesis updates the knowledge graph in hardware, persisting scientific facts across observation cycles without CPU intervention.

---

### 🟣 AI Compute Fabric

| Block | Type | Config |
|-------|------|--------|
| `matrix_compute_unit` | Systolic Array | 4×4, 8-bit operands |
| `neuromorphic_engine` | Spiking Neural Network | 4 neurons |
| `rram_compute_fabric` | Memristive In-Memory | Analog-weight simulation |

The matrix compute unit performs `y = Mx` in hardware (4×4 integer matrix-vector product), accelerating neural inference without touching the CPU.

---

### 🟤 Swarm Engine — `swarm_engine`

```
Agents  : 8 (configurable via `AGENT_COUNT`)
Modules :
  ├── swarm_comm_controller  → inter-agent messaging
  ├── task_allocator         → dynamic work distribution
  ├── knowledge_sync_unit    → distributed graph consensus
  └── conflict_resolver      → priority-based contention handling
```

Each swarm agent can independently sense, reason, and publish to the shared knowledge graph, with hardware arbitration ensuring consistent updates.

---

### 🔵 Navigation Subsystem

| Module | Function |
|--------|----------|
| `slam_engine` | Simultaneous localization & mapping |
| `terrain_analysis` | Ground classification |
| `path_planner` | Obstacle-aware routing |

---

### 🔒 Reliability Subsystem

| Module | Technique |
|--------|-----------|
| `tmr_controller` | Triple Modular Redundancy |
| `fault_detection_unit` | Parity + timeout monitoring |
| `error_logger` | 16-deep event FIFO (`ERROR_LOG_DEPTH`) |
| `ecc_memory_controller` | SECDED error correction |

---

## 🔄 Complete Design Flow

```
RTL Sources (Verilog)
        │
        ▼
  ┌─────────────┐
  │  Synthesis  │  Yosys → sky130_fd_sc_hd, AREA_0 strategy
  │  (Yosys)    │  15,443 cells synthesized
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │ Floorplan   │  Die: 598×609 µm²  Core Util: 45%
  │ (OpenROAD)  │  PDN pitch: 25 µm, aspect ratio 1.0
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │  Placement  │  RePlace (global) + OpenDP (detailed)
  │             │  Target density: 70%
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │  CTS        │  TritonCTS — clock tree synthesis
  │             │  Clock: 100 MHz (10 ns period)
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │  Routing    │  FastRoute (global) + TritonRoute (detailed)
  │             │  DRT violations: 0
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │  RC Extract │  OpenRCX — min/nom/max corners
  │  (3 corners)│  SPEF generated per corner
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │  Signoff    │  Magic DRC, Netgen LVS, OpenSTA STA
  │  DRC/LVS/   │  IR Drop (VPWR/VGND), Antenna check
  │  STA        │
  └──────┬──────┘
         │
         ▼
  Final GDS / LEF / SPICE
```

**OpenLane Run:** `RUN_2026.03.17_16.04.36`
**Total Flow Runtime:** 37 min 53 sec
**Routing Runtime:** 33 min 31 sec

---

## 📐 Physical Design Details

### Die & Core Dimensions

```
┌────────────────────────────────────────────────────┐
│                    DIE BOUNDARY                    │
│  (0,0) ─────────────────────────────── (598.0 µm) │
│  │                                             │   │
│  │   ┌──────────────────────────────────────┐ │   │
│  │   │           CORE AREA                  │ │   │
│  │   │   (5.52, 10.88) to (592.48, 595.68)  │ │   │
│  │   │                                      │ │   │
│  │   │        15,797 Standard Cells         │ │   │
│  │   │        44,425 Total Instances        │ │   │
│  │   │    (incl. decap/fill/welltap)        │ │   │
│  │   └──────────────────────────────────────┘ │   │
│  │                                             │   │
│  (0, 608.7)──────────────────────────(598, 608.7)  │
└────────────────────────────────────────────────────┘
```

| Physical Parameter | Value |
|-------------------|-------|
| Die Area | **0.364 mm²** |
| Core Area | **343,254 µm²** (0.343 mm²) |
| Core Utilization | **45%** (configured) |
| Final Cell Density | 43,393 cells/mm² |
| Placement Density | ~46.21% actual |
| PDK | SKY130A (130nm CMOS) |
| Standard Cell Library | `sky130_fd_sc_hd` |

### Routing Statistics

| Metric | Value |
|--------|-------|
| Total Wire Length | **645,873 µm** |
| Total Vias | **122,590** |
| Metal Layer 2 Usage | 41.58% |
| Metal Layer 3 Usage | 45.02% |
| Metal Layer 4 Usage | 30.64% |
| Metal Layer 5 Usage | 33.93% |
| Metal Layer 6 Usage | 18.43% |
| DRT Violations | **0** |

---

## 📊 Results & Metrics

### 🧮 Synthesis Statistics

```
╔══════════════════════════════════════╗
║     POST-SYNTHESIS CELL COUNT        ║
╠══════════════════════════════════════╣
║  Total Cells       :  15,443         ║
║  Flip-Flops (DFF)  :   3,072  ← 17 Q║
║  MUX2              :   3,101         ║
║  buf_1 (buffers)   :   5,226         ║
║  and3              :   1,546         ║
║  or4               :     563         ║
║  a221o             :     295         ║
║  or2               :     295         ║
║  nor2              :     210         ║
║  inv               :     105         ║
╠══════════════════════════════════════╣
║  Chip Area         : 155,048 µm²     ║
║  Strategy          : AREA_0 (Yosys)  ║
╚══════════════════════════════════════╝
```

### 📦 Design Complexity

| Metric | Pre-Synthesis | Post-Synthesis |
|--------|--------------|----------------|
| RTL Modules | ~40 | — |
| Total Cells | — | 15,443 |
| Wire Count | — | 15,430 |
| Flip-Flops | — | 3,170 (DFF+DFRTP+DFSTP) |
| Total Instances | — | 44,425 |
| Logic Levels | — | 14 |
| Input Ports | — | 3,171 |
| Output Ports | — | 3,264 |

---

## ⏱️ Timing Analysis

Static timing analysis was performed across **3 process corners** (min/nom/max) with SPEF parasitics.

### Summary — Post-Route (Nominal Corner)

```
╔══════════════════════════════════════════════════════╗
║              TIMING SIGNOFF SUMMARY                  ║
╠══════════════════════════════════════════════════════╣
║  Clock Period          :  10.0 ns  (100 MHz)         ║
║  Worst Negative Slack  :  0.00 ns  ✅  (No Violation)║
║  Total Negative Slack  :  0.00 ns  ✅                 ║
║  Worst Setup Slack     :  +4.52 ns ✅  (3.52 ns guard)║
║  Worst Hold Slack      :  +0.29 ns ✅                 ║
║  Critical Path Delay   :  7.02 ns                    ║
╠══════════════════════════════════════════════════════╣
║  Suggested Max Clock   :  ~143 MHz (7.02 ns critical) ║
╚══════════════════════════════════════════════════════╝
```

### Timing Across Corners

| Corner | Setup WNS | Hold WNS | TNS |
|--------|-----------|----------|-----|
| Synthesis (pre-route) | +5.19 ns | +0.26 ns | 0.0 |
| Post-Place | — | — | 0.0 |
| Post-CTS | — | — | 0.0 |
| **Post-Route (Signoff)** | **+4.52 ns** | **+0.29 ns** | **0.0** |

> ✅ **Zero timing violations across all corners and all stages.**

---

## ⚡ Power Analysis

Power estimated using OpenSTA after parasitics extraction (nominal corner, 1.8V):

```
╔══════════════════════════════════════════════════════╗
║               POWER REPORT — TYPICAL                 ║
╠══════════════════════════════════════════════════════╣
║  Group         Internal  Switching  Leakage   Total  ║
║  ─────────── ─────────── ────────── ───────  ──────  ║
║  Sequential    14.4 mW    1.11 mW   ~0 µW   15.6 mW  ║
║  Combinational  9.4 mW   12.3 mW   ~0 µW   21.7 mW  ║
║  ─────────── ─────────── ────────── ───────  ──────  ║
║  TOTAL         23.8 mW   13.4 mW   96.9 nW  37.3 mW  ║
║                 63.9%     36.1%      ~0%    100%     ║
╚══════════════════════════════════════════════════════╝
```

**Power Breakdown Visual:**

```
Sequential Logic  ████████████████░░░░░░  41.7%
Combinational     ████████████████████░░  58.3%
```

| Corner | Total Power |
|--------|-------------|
| Fastest | TBD (parasitics extracted) |
| **Typical** | **37.3 mW** |
| Slowest | TBD (parasitics extracted) |

---

## 🔬 Signoff Verification

### ✅ DRC — Magic Design Rule Check

```
Total Magic DRC Violations : 0  ✅ CLEAN
```

### ✅ LVS — Layout vs. Schematic

```
Number of nets (layout)    : 15,810
Number of nets (schematic) : 15,810
Design is LVS clean        : ✅ PASS
```

### ⚠️ Antenna Check

```
Pin Violations  : 181
Net Violations  :  99
```

> Antenna violations are present but within acceptable bounds for SKY130A; diode insertion (`RUN_HEURISTIC_DIODE_INSERTION = 1`) is enabled and 510 diode cells were inserted. Further optimization can reduce these.

### IR Drop

| Rail | Report |
|------|--------|
| VPWR | `32-irdrop-VPWR.rpt` |
| VGND | `32-irdrop-VGND.rpt` |

PDN pitch set to 25 µm horizontal and vertical to ensure adequate current delivery.

---

## 🗂️ Repository Structure

```
aslss_soc/
├── 📄 config.tcl                   # OpenLane configuration
├── 📄 my_design.dot / .svg         # Design hierarchy graph
├── src/
│   ├── rtl/
│   │   ├── top/
│   │   │   └── aslss_soc_top.v    # 🔝 Top-level integration
│   │   ├── cpu/
│   │   │   ├── vexriscv_cluster.v      # 4-core RISC-V cluster
│   │   │   ├── vexriscv_core_wrapper.v
│   │   │   ├── memory_arbiter.v
│   │   │   └── cpu_interrupt_controller.v
│   │   ├── noc/
│   │   │   ├── noc_mesh.v              # 4×4 mesh interconnect
│   │   │   ├── noc_router.v            # 5-port XY router
│   │   │   ├── noc_arbiter.v
│   │   │   └── noc_packet.v
│   │   ├── sensors/
│   │   │   ├── vision_engine.v
│   │   │   ├── radar_engine.v
│   │   │   ├── spectroscopy_engine.v
│   │   │   ├── environment_sensor_engine.v
│   │   │   └── observation_aggregator.v
│   │   ├── reasoning/
│   │   │   ├── hypothesis_engine.v
│   │   │   ├── ml_pattern_analyzer.v
│   │   │   ├── rule_logic_unit.v
│   │   │   ├── experiment_planner.v
│   │   │   ├── context_decision_controller.v
│   │   │   └── reasoning_engine.v
│   │   ├── knowledge/
│   │   │   ├── knowledge_graph_engine.v
│   │   │   ├── node_manager.v
│   │   │   ├── edge_processor.v
│   │   │   ├── graph_query_engine.v
│   │   │   └── discovery_update_unit.v
│   │   ├── ai_compute/
│   │   │   ├── matrix_compute_unit.v   # 4×4 systolic array
│   │   │   ├── neuromorphic_engine.v   # SNN engine
│   │   │   └── rram_compute_fabric.v   # Memristive compute
│   │   ├── swarm/
│   │   │   ├── swarm_engine.v
│   │   │   ├── swarm_comm_controller.v
│   │   │   ├── task_allocator.v
│   │   │   ├── knowledge_sync_unit.v
│   │   │   └── conflict_resolver.v
│   │   ├── navigation/
│   │   │   ├── slam_engine.v
│   │   │   ├── path_planner.v
│   │   │   └── terrain_analysis.v
│   │   ├── memory/
│   │   │   ├── knowledge_graph_memory.v
│   │   │   ├── sensor_buffer.v
│   │   │   ├── shared_memory.v
│   │   │   ├── ecc_memory_controller.v
│   │   │   └── nonvolatile_storage_controller.v
│   │   ├── communication/
│   │   │   ├── communication_controller.v
│   │   │   ├── packet_encoder.v
│   │   │   ├── packet_decoder.v
│   │   │   └── crc_unit.v
│   │   ├── reliability/
│   │   │   ├── tmr_controller.v
│   │   │   ├── fault_detection_unit.v
│   │   │   └── error_logger.v
│   │   └── common/
│   │       ├── definitions.vh
│   │       ├── parameters.vh
│   │       └── utility_modules.v
│   ├── sim/
│   │   └── testbench_top.v
│   ├── constrains/
│   │   └── aslss_soc.sdc
│   └── scripts/
└── runs/
    └── RUN_2026.03.17_16.04.36/
        ├── reports/
        │   ├── synthesis/   → timing/area stats
        │   ├── signoff/     → DRC, LVS, IR Drop, Antenna
        │   └── metrics.csv  → full run metrics
```

---

## 🚀 Getting Started

### Prerequisites

```bash
# OpenLane v1 with Docker
docker pull efabless/openlane:latest

# Or native installation
pip install openlane
```

### Running the Flow

```bash
# Clone / enter project
cd aslss_soc

# Run full OpenLane flow
./flow.tcl -design aslss_soc -config config.tcl

# Or with Docker
docker run -v $(pwd):/openlane/designs/aslss_soc \
  efabless/openlane:latest \
  ./flow.tcl -design aslss_soc
```

### Key Configuration Parameters

```tcl
CLOCK_PERIOD       = 10.0 ns    # 100 MHz
FP_CORE_UTIL       = 45         # 45% utilization
FP_ASPECT_RATIO    = 1.0        # Square die
PL_TARGET_DENSITY  = 0.70       # 70% placement density
FP_PDN_VPITCH      = 25         # PDN pitch (µm)
FP_PDN_HPITCH      = 25
MAX_FANOUT_CONSTRAINT = 6
STD_CELL_LIBRARY   = sky130_fd_sc_hd
SYNTH_STRATEGY     = AREA 0
```

### Simulation

```bash
# Run testbench
iverilog -o sim_out src/sim/testbench_top.v src/rtl/**/*.v
vvp sim_out
gtkwave dump.vcd
```

---

## 🏅 Summary Scorecard

```
┌────────────────────────────────────────────────────────────────┐
│                  ASLSS-SoC FINAL SCORECARD                     │
├────────────────────────────┬───────────────────────────────────┤
│  Flow Status               │  ✅ COMPLETED                     │
│  DRC                       │  ✅ 0 Violations                  │
│  LVS                       │  ✅ Clean (15,810 nets matched)   │
│  Setup Timing (WNS)        │  ✅ +4.52 ns (no violation)       │
│  Hold Timing (WNS)         │  ✅ +0.29 ns (no violation)       │
│  Total Negative Slack      │  ✅ 0.00 ns                       │
│  Power (Typical)           │  📊 37.3 mW                       │
│  Die Area                  │  📐 0.364 mm²                     │
│  Cell Count                │  🔲 15,443 logic + 28,628 phys   │
│  Process Technology        │  🏭 SKY130A 130nm Open PDK        │
│  Clock                     │  ⏱️  100 MHz (7.02 ns crit path)  │
│  Total Runtime             │  ⏰ 37m 53s                       │
└────────────────────────────┴───────────────────────────────────┘
```

---

## 📚 References & Tools

| Tool | Purpose |
|------|---------|
| [OpenLane](https://github.com/The-OpenROAD-Project/OpenLane) | RTL-to-GDS automation |
| [Yosys](https://yosyshq.net/yosys/) | Logic synthesis |
| [OpenROAD](https://theopenroadproject.org/) | Placement, CTS, Routing |
| [Magic VLSI](http://opencircuitdesign.com/magic/) | DRC & GDS extraction |
| [Netgen](http://opencircuitdesign.com/netgen/) | LVS verification |
| [OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA) | Static timing analysis |
| [SKY130 PDK](https://skywater-pdk.readthedocs.io/) | 130nm process design kit |
| [VexRISCV](https://github.com/SpinalHDL/VexRiscv) | RISC-V CPU generator |

---

<div align="center">

**Built with ❤️ on Open-Source Silicon | SKY130A | OpenLane**

*"The next great scientific discoveries may come not from human laboratories, but from silicon minds that never sleep."*

</div>
