require "helper"

class HatstoneRiscv64Test < Hatstone::Test
  def test_disasm

    insns = [
      lui(17, 64),  # lui a7, 64 
      lui(10, 1),   # lui a0, 1 
      auipc(0, 0), # auipc a0,0x0 
      addi(0, 36), # addi a0,a0,36
    ].pack("L<*")

    hs = Hatstone.new(Hatstone::ARCH_RISCV, Hatstone::MODE_RISCV64)

    disassembled = hs.disasm(insns, 0x0)

    assert_equal "lui", disassembled[0].mnemonic
    assert_equal "lui", disassembled[1].mnemonic
    assert_equal "auipc", disassembled[2].mnemonic
    assert_equal "addi", disassembled[3].mnemonic
  end

  def lui reg, imm
    insn = 0b00000000000000000000_00000_0110111  # lui base
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
end
