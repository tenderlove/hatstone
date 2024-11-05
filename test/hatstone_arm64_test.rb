require "helper"

class HatstoneArm64Test < Hatstone::Test
  def test_disasm
    hs = Hatstone.new(Hatstone::ARCH_ARM64, Hatstone::MODE_ARM)

    # Assemble some instructions
    insns = [
      movz(0, 42),  # mov X0, 42
      ret           # ret
    ].pack("L<L<")

    disassembled = hs.disasm(insns, 0x0)
    
    assert_equal "mov", disassembled[0].mnemonic
    assert_equal "ret", disassembled[1].mnemonic
  end

  # ARM instructions
  def movz reg, imm
    insn = 0b0_10_100101_00_0000000000000000_00000
    insn |= (1 << 31)  # 64 bit
    insn |= (imm << 5) # immediate
    insn |= reg        # reg
  end

  def ret xn = 30
    insn = 0b1101011_0_0_10_11111_0000_0_0_00000_00000
    insn |= (xn << 5)
    insn
  end
end

