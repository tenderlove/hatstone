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
