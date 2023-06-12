class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://github.com/softwareQinc/staq/archive/v3.2.2.tar.gz"
  sha256 "e22dac337f98a73b6f59a4f667b01bc5381a0e950b64bf027e0512b350c1b634"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b41da0a0d659d25fa17070db35d90783b1edfdab7833a4319359f1afaeaf08ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47eef4ba53a3f93473a7e6b9f0b6e6d768344dbe83ccca243a0904bf615a4768"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8750f91cf015c137dce432ee1cb0ec5c90990ac6f5a794c59b7293bf9832f4f8"
    sha256 cellar: :any_skip_relocation, ventura:        "7e472eb5b7e59045db83a0110d0ef55fbc10e5f18922b22c2fae147a2fcd407a"
    sha256 cellar: :any_skip_relocation, monterey:       "092afb458a2cadad960517f47e43cbf60eeb4d9c52341e1cd0e152e0dc862eb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf7dfdf898a020c31b85b0d292b54f75c92a5ececd778e0c453225fafc719d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c69a9cbf5522a513767ac3bf134d9aadac26434a3a636b34ffb27574981b0018"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"input.qasm").write <<~EOS
      OPENQASM 2.0;
      include "qelib1.inc";

      qreg q[1];
      creg c[1];
      h q[0];
      h q[0];
      measure q->c;
    EOS
    assert_equal <<~EOS, shell_output("#{bin}/staq -O3 ./input.qasm").chomp
      OPENQASM 2.0;
      include "qelib1.inc";

      qreg q[1];
      creg c[1];
      measure q[0] -> c[0];
    EOS
  end
end
