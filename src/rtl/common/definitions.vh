`ifndef DEFINITIONS_VH
`define DEFINITIONS_VH

// Packet types
`define PKT_SENSOR_DATA      8'd1
`define PKT_SWARM_MESSAGE    8'd2
`define PKT_KNOWLEDGE_SYNC   8'd3
`define PKT_SYSTEM_STATUS    8'd4

// Terrain types
`define TERRAIN_UNKNOWN      3'd0
`define TERRAIN_SAFE         3'd1
`define TERRAIN_OBSTACLE     3'd2
`define TERRAIN_SLOPE        3'd3
`define TERRAIN_HAZARD       3'd4

// Fault types
`define FAULT_NONE           3'd0
`define FAULT_TMR            3'd1
`define FAULT_MEMORY         3'd2
`define FAULT_COMM           3'd3
`define FAULT_SENSOR         3'd4

// Swarm message types
`define SWARM_TASK_REQ       8'd1
`define SWARM_KNOWLEDGE      8'd2
`define SWARM_CONFLICT       8'd3

`endif
