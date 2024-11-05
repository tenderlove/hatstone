# Hatstone

This is a very simple wrapper around [Capstone](https://www.capstone-engine.org).
Capstone is a library that disassembles binary data in to assembly code.  This
library, Hatstone, offers a Ruby interface to the Capstone library.

## Why a new library?

[Crabstone](https://github.com/bnagy/crabstone) is a different wrapper for Capstone.
I've been using Crabstone for quite a while and I really love it.  However,
I've been running in to problems with libffi, and especially problems on my M1
Mac where I have both the ARM64 installation and x86 installation of Capstone
on the same system (via two installations of Homebrew).

This C extension finds the right Capstone library at gem installation time, so
you can be assured that if you can install this gem, you can use this gem (hopefully!!)

## Installation

Make sure you have Capstone installed.  On macOS this is `brew install capstone`.
Then install this gem via the normal method `gem install hatstone`.

Note: RISCV support is only available in Capstone version 5 or later.

## Example Usage

In this example we'll assemble some simple ARM64 instructions and then use
Hatstone to disassemble them.

```ruby
require "hatstone"

# ARM64 movz instruction
def movz reg, imm
  insn = 0b0_10_100101_00_0000000000000000_00000
  insn |= (1 << 31)  # 64 bit
  insn |= (imm << 5) # immediate
  insn |= reg        # reg
end

# ARM64 ret instruction
def ret xn = 30
  insn = 0b1101011_0_0_10_11111_0000_0_0_00000_00000
  insn |= (xn << 5)
  insn
end

# Assemble some instructions
insns = [
  movz(0, 0x2a), # mov X0, 0x2a
  ret            # ret
].pack("L<L<")

# Now disassemble the instructions with Hatstone
hs = Hatstone.new(Hatstone::ARCH_ARM64, Hatstone::MODE_ARM)

hs.disasm(insns, 0x0).each do |insn|
  puts "%#05x %s %s" % [insn.address, insn.mnemonic, insn.op_str]
end
```
Another example, this time for RISCV64

```ruby
require 'hatstone'

def lui reg, imm
  insn = 0b00000000000000000000_00000_0110111 
  insn |= (reg << 7)  # Set destination register 
  insn |= (imm & 0xFFFFF) << 12  # Set 20-bit immediate
  insn
end

def auipc reg, imm
  insn = 0b00000000000000000000_00000_0010111  # auipc base
  insn |= (reg << 7)  # Set destination register
  insn |= (imm & 0xFFFFF) << 12  # Set 20-bit immediate
  insn
end

def addi reg, imm
  insn = 0b00000000000000000000_00000_0010011  # addi base
  insn |= (reg << 7)  # Set destination register
  insn |= (reg << 15)  # Set source register
  insn |= (imm & 0xFFF) << 20  # Set 12-bit immediate
  insn
end

insns = [
  lui(17, 64), # lui a7,64
  lui(10, 1),  # lui a0,1
  auipc(0, 0), # auipc a0,0x0
  addi(0, 36), # addi a0,a0,36
].pack("L<*")

hs = Hatstone.new(Hatstone::ARCH_RISCV, Hatstone::MODE_RISCV64)

hs.disasm(insns, 0x0).each do |insn|
  puts "%#05x %s %s" % [insn.address, insn.mnemonic, insn.op_str]
end
```
