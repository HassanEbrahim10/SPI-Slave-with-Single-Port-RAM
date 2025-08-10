# SPI-Slave-with-Single-Port-RAM
This project features a Serial Peripheral Interface (SPI) slave module integrated with a single-port RAM block.

The SPI slave receives data from an external master device and interfaces with the RAM to perform both data storage and retrieval operations.

## Wrapper
![DSP48A1 Diagram](https://github.com/user-attachments/assets/11065b22-f91a-418c-85aa-dbe884024e2f)

## Single-Port Synchronous RAM

### Parameters
| Name         | Default | Description                                  |
|--------------|---------|----------------------------------------------|
| `MEM_DEPTH`  | 256     | Depth of the RAM (number of memory locations).|
| `ADDR_SIZE`  | 8       | Address width in bits.                        |

---

### Ports
| Name       | Type   | Size   | Description                                                                                  |
|------------|--------|--------|----------------------------------------------------------------------------------------------|
| `din`      | Input  | 10 bits| Data input.                                                                                  |
| `clk`      | Input  | 1 bit  | Clock signal.                                                                                |
| `rst_n`    | Input  | 1 bit  | Active-low asynchronous reset.                                                               |
| `rx_valid` | Input  | 1 bit  | When HIGH: accepts `din[7:0]` as data; uses `din[9:8]` to determine write/read address internally. |
| `dout`     | Output | 8 bits | Data output.                                                                                 |
| `tx_valid` | Output | 1 bit  | HIGH when a memory read command is processed and valid data is present on `dout`.            |
