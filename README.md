# Library of Arithmetic Units

SystemVerilog Edition!

Based on the [VHDL library](https://iis-people.ee.ethz.ch/~zimmi/arith_lib.html#library) written by Reto Zimmermann.

The library contains various arithmetic operations with multiple architectural choices for different speed requirements. All operations are parametrized in width and performance grade.

## Disclaimer

This project is still under active development; some parts may not yet be fully functional, and existing interfaces, toolflows, and conventions may be broken without prior notice. We target a stable release as soon as possible.

## License

All code checked into this repository is licensed under the permissive Solderpad Hardware License 0.51 (See `LICENSE`).

## Available Operations

### Adders

| Name         | Description                                       | unsigned | signed | slow | medium | fast |
| ------------ | ------------------------------------------------- | :------: | :----: | :--: | :----: | :--: |
| Add          | Adder                                             |    X     |   X    |  S   |   M    |  F   |
| AddC         | Adder with carry-in, carry-out                    |    X     |        |  S   |   M    |  F   |
| AddCfast     | Adder with fast carry-in, carry-out               |    X     |        |  S   |   M    |  F   |
| AddV         | Adder with carry-in, 2’s compl. overflow flag     |          |   X    |  S   |   M    |  F   |
| AddMod2Nm1   | Adder modulo 2^n - 1 (double zero representation) |    X     |        |  S   |   M    |  F   |
| AddMod2Nm1s0 | Adder modulo 2^n - 1 (single zero representation) |    X     |        |  S   |   M    |  F   |
| AddMod2Np1   | Adder modulo 2^n + 1                              |    X     |        |  S   |   M    |  F   |
| AddCsv       | Carry-save adder (3 operands)                     |    X     |   X    |      |        |  F   |
| AddMop       | Multi-operand adder                               |    X     |   X    |  S   |   M    |  F   |
| AddMopCsv    | Carry-save multi-operand adder                    |    X     |   X    |  S   |        |  F   |

### Subtractors, Complementers

| Name   | Description                                           | unsigned | signed | slow | medium | fast |
| ------ | ----------------------------------------------------- | :------: | :----: | :--: | :----: | :--: |
| Sub    | Subtractor                                            |    X     |   X    |  S   |   M    |  F   |
| SubC   | Subtractor with carry-in, carry-out                   |    X     |        |  S   |   M    |  F   |
| SubCZ  | Subtractor with carry-in, carry-out, zero flag        |    X     |        |  S   |   M    |  F   |
| SubV   | Subtractor with carry-in, 2’s compl. overflow flag    |          |   X    |  S   |   M    |  F   |
| SubVZ  | Subtractor with carry-in, 2’s compl. ovl. & zero flag |          |   X    |  S   |   M    |  F   |
| Neg    | 2’s complementer (negation)                           |          |   X    |  S   |   M    |  F   |
| NegC   | 2’s complementer, conditional                         |          |   X    |  S   |   M    |  F   |
| AbsVal | Absolute value for 2’s complement numbers             |          |   X    |  S   |   M    |  F   |

### Adder-Subtractors

| Name    | Description                                          | unsigned | signed | slow | medium | fast |
| ------- | ---------------------------------------------------- | :------: | :----: | :--: | :----: | :--: |
| AddSub  | Adder-subtractor                                     |    X     |   X    |  S   |   M    |  F   |
| AddSubC | Adder-subtractor with carry-in, carry-out            |    X     |        |  S   |   M    |  F   |
| AddSubV | Adder-subtractor with carry-in, 2’s compl. ovl. flag |          |   X    |  S   |   M    |  F   |

### Incrementers, Decrementers

| Name    | Description                                      | unsigned | signed | slow | medium | fast |
| ------- | ------------------------------------------------ | :------: | :----: | :--: | :----: | :--: |
| Inc     | Incrementer                                      |    X     |   X    |  S   |   M    |  F   |
| IncC    | Incrementer with carry-in, carry-out             |    X     |        |  S   |   M    |  F   |
| Dec     | Decrementer                                      |    X     |   X    |  S   |   M    |  F   |
| DecC    | Decrementer with carry-in, carry-out             |    X     |        |  S   |   M    |  F   |
| IncDec  | Incrementer-decrementer                          |    X     |   X    |  S   |   M    |  F   |
| IncDecC | Incrementer-decrementer with carry-in, carry-out |    X     |        |  S   |   M    |  F   |

### Comparators

| Name    | Description                       | unsigned | signed | slow | medium | fast |
| ------- | --------------------------------- | :------: | :----: | :--: | :----: | :--: |
| CmpEQ   | Equality comparator               |    X     |   X    |      |        |  F   |
| CmpGE   | Magnitude comparator              |    X     |        |  S   |   M    |  F   |
| CmpEQGE | Equality and magnitude comparator |    X     |   X    |  S   |   M    |  F   |

### Multipliers

| Name      | Description                    | unsigned | signed | slow | medium | fast |
| --------- | ------------------------------ | :------: | :----: | :--: | :----: | :--: |
| MulSgn    | Signed multiplier              |          |   X    |  S   |   M    |  F   |
| MulUns    | Unsigned multiplier            |    X     |        |  S   |   M    |  F   |
| MulAddSgn | Signed multiplier-adder        |          |   X    |  S   |   M    |  F   |
| MulAddUns | Unsigned multiplier-adder      |    X     |        |  S   |   M    |  F   |
| AddMulSgn | Signed adder-multiplier        |          |   X    |  S   |   M    |  F   |
| AddMulUns | Unsigned adder-multiplier      |    X     |        |  S   |   M    |  F   |
| MulCsvSgn | Signed carry-save multiplier   |          |   X    |  S   |        |  F   |
| MulCsvUns | Unsigned carry-save multiplier |    X     |        |  S   |        |  F   |
| SqrSgn    | Signed squarer                 |          |   X    |  S   |   M    |  F   |
| SqrUns    | Unsigned squarer               |    X     |        |  S   |   M    |  F   |

### Dividers, Square-Root Extractors

| Name       | Description                          | unsigned | signed | slow | medium | fast |
| ---------- | ------------------------------------ | :------: | :----: | :--: | :----: | :--: |
| DivArrSgn  | Signed array divider                 |          |   X    |  S   |        |      |
| DivArrUns  | Unsigned array divider               |    X     |        |  S   |        |      |
| SqrtArrUns | Unsigned array square-root extractor |    X     |        |  S   |        |      |

### Detectors

| Name        | Description                          | unsigned | signed | slow | medium | fast |
| ----------- | ------------------------------------ | :------: | :----: | :--: | :----: | :--: |
| AllZeroDet  | All-zeroes detector                  |          |        |      |        |  F   |
| AllOneDet   | All-ones detector                    |          |        |      |        |  F   |
| SumZeroDet  | Unsigned array square-root extractor |    X     |   X    |      |        |  F   |
| LeadZeroDet | Leading-zeroes detector (LZD)        |    X     |        |  S   |   M    |  F   |
| LeadOneDet  | Leading-ones detector (LOD)          |    X     |        |  S   |   M    |  F   |
| LeadSignDet | Leading-signs detector (LSD)         |          |   X    |  S   |   M    |  F   |
| Log2        | Integer logarithm (base 2)           |    X     |        |  S   |   M    |  F   |

### Encoders, Decoders, Gray

| Name     | Description                    | slow | medium | fast |
| -------- | ------------------------------ | :--: | :----: | :--: |
| Decode   | Decoder                        |      |        |  F   |
| Encode   | Encoder                        |      |        |  F   |
| Bin2Gray | Binary-to-Gray converter       |      |        |  F   |
| Gray2Bin | Gray-to-binary converter       |  S   |   M    |  F   |
| IncGray  | Gray incrementer               |  S   |   M    |  F   |
| IncGrayC | Gray incrementer with carry-in |  S   |   M    |  F   |

### Miscellaneous

| Name        | Description      | slow | medium | fast |
| ----------- | ---------------- | :--: | :----: | :--: |
| Cnt         | (m,k)-counter    |  S   |        |  F   |
| Cpr         | (m,2)-compressor |  S   |        |  F   |
| RedAnd      | Reduce-AND       |      |        |  F   |
| RedOr       | Reduce-OR        |      |        |  F   |
| RedXor      | Reduce-XOR       |      |        |  F   |
| PrefixAnd   | Prefix-AND       |  S   |   M    |  F   |
| PrefixOr    | Prefix-OR        |  S   |   M    |  F   |
| PrefixAndOr | Prefix-AND-OR    |  S   |   M    |  F   |
| PrefixXor   | Prefix-XOR       |  S   |   M    |  F   |

