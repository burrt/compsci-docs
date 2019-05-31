---
layout: compsci-note
title: VHDL Tips
categories: [tips, language]
description: Some tips and tricks with VHDL
order: 20
sitemap: false
---

# Contents

* [Rules](#rules)
* [Logging](#logging)
* [Asserts](#asserts)
* [Initialising 1D array](#initialising-1d-array)
* [Initialising 2D array](#initialising-2d-array)
* [Conversions](#conversions)
* [Component declarations](#component-declarations)
* [Incrementing a counter](#incrementing-a-counter)

## Rules

* DO NOT write to same signal in 2 different processes!
* DO NOT have a 'reset' signal in combinational logic!
* DO NOT write to **registers** in combinational processes! Creates latches and are **unsynthesisable**!
* **Variables** update immediately
* **Signals** update on its **last** assignment
* Sequential logic **only** needs `(clk, reset)`
* natural vs integer : unsigned vs either

```vhdl
-- Combination Logic rule:
-- Must have a sensitivity list containing all the input signals which it reads
-- Must always update the signals which it assigns (outputs):
-- Only for simulation to work correctly

process (A, B, SEL)
begin
    Z <= B;           -- set default signal, good idea
    if SEL = '1' then
        Z <= A;
    end if;
end process;
```

## Logging

```vhdl
variable s : line;
write(s, string'("Writing to console"));
hwrite(s, loadstore_addr);
writeline(output, s);
 ```

## Asserts

```vhdl
x_sig <= '1';
y_sig <= '1';
assert (x_sig = y_sig) report "x_sig != y_sig" severity failure;
```

* Can have other levels of severity
* If **FALSE**, break and print report - failure causes a STOP (or break in Modelsim?)

## Initialising 1D array

```vhdl
type bram is array (0 to 1023) of std_logic_vector(31 downto 0);
signal fifo : bram := (others => (others => '0'));
```

## Initialising 2D array

```vhdl
type ram is array (63 downto 0) of std_logic_vector (63 downto 0);
signal TLB : ram := (X"1000000010000300",
                     0 => X"000bffffaaaaffff",  -- specify index!
                     others => INIT_TLB) ;      -- do normal 'others'
```

## Conversions

### std_logic_vector -> Integer

```vhdl
int <= to_integer(signed(std_logic_v));
u_int <= to_integer(unsigned(std_logic_v)); -- unsigned or natural
```

### Integer -> std_logic_vector

```vhdl
my_slv <= std_logic_vector(to_unsigned(my_int, my_slv'length));
```

## Adding std_logic_vectors

```vhdl
pr_out <= std_logic_vector(unsigned(pr_in1) + unsigned(pr_in2));
```

## Component declarations

```vhdl
label: entity work.counter_mod port map (..)
```

## Increment a counter

```vhdl
use ieee.numeric_std.all
nextvalue <= std_logic_vector(unsigned(nextvalue) + 1);
```
