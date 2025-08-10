# SPI-Slave-with-Single-Port-RAM
This project features a Serial Peripheral Interface (SPI) slave module integrated with a single-port RAM block.

The SPI slave receives data from an external master device and interfaces with the RAM to perform both data storage and retrieval operations.

## Wrapper
![DSP48A1 Diagram](https://github.com/user-attachments/assets/11065b22-f91a-418c-85aa-dbe884024e2f)

## Single-Port Synchronous RAM Module

The single-port synchronous RAM module implements a memory block with a single data port.  
It has the following parameters and ports:

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

---

### Command Encoding
The most significant bits of `din` (`din[9:8]`) determine the operation to be performed:

| Port | `din[9:8]` | Command | Description                                                                                           |
|------|------------|---------|-------------------------------------------------------------------------------------------------------|
| `din`| `00`       | Write   | Holds `din[7:0]` internally as a write address.                                                       |
| `din`| `01`       | Write   | Writes `din[7:0]` to the memory at the previously held write address.                                 |
| `din`| `10`       | Read    | Holds `din[7:0]` internally as a read address.                                                        |
| `din`| `11`       | Read    | Reads memory at the previously held read address. `tx_valid` should be HIGH and `dout` holds the word read; `din[7:0]` is ignored. |

---

## SPI Slave Module

|    Name   | Type | Size | Description |
| :---: | :---: | :---: | :---  |
| clk       |  Input | 1 bit  | Clock signal |
| rst_n     |  Input | 1 bit  | Active low reset signal |
| SS_n      |  Input | 1 bit  | Slave Select signal |
| MOSI      |  Input | 1 bit  | Master-Out-Slave-In data signal |
| tx_data   |  Input | 8 bit | Transfer data output signal, Takes MOSI for 10 clock cycles and stores it in tx_data to send it to the RAM |
| tx_valid  |  Input | 1 bit  | Indicates when tx_data is valid |
| MISO      | Output | 1 bit  | Master-In-Slave-Out data signal |
| rx_data   | Output | 10 bit | Received data from the memory |
| rx_valid  | Output | 1 bit  | Indicates when rx_data is valid |


### Wire connections:
* rx_data in the SPI slave module is connected to the din port in the RAM module.
* rx_valid in the SPI slave module is connected to rx_valid in the RAM module.
* dout in the RAM module is connected to tx_data in the SPI slave module.
* tx_valid in the RAM module is connected to tx_valid in the SPI slave module.

---

## FSM ( Finite State Machine )
![DSP48A1 Diagram](https://github.com/user-attachments/assets/bb583945-2598-4580-aa6d-5c0701eb0097)


