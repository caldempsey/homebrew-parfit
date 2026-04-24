class Parfit < Formula
  desc "Paragraph fit — a codebase-aware comment reflow tool that wraps prose with optimal-fit line breaking and leaves directives alone. Inspired by par."
  homepage "https://github.com/caldempsey/parfit"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/caldempsey/parfit/releases/download/v0.4.4/parfit-aarch64-apple-darwin.tar.xz"
      sha256 "f42ab7fa4beef2e480c0167788da67eaefcd096181bafa14aabcd5bff294153a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/caldempsey/parfit/releases/download/v0.4.4/parfit-x86_64-apple-darwin.tar.xz"
      sha256 "e30bd29758bd530959b5dfe65b1f56e700d6c74fda56e8d9751cafa7a8e04519"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/caldempsey/parfit/releases/download/v0.4.4/parfit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c7cc1da47358e455505c5937f6363263ae560126ca728d1c96d2114eb71d3d48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/caldempsey/parfit/releases/download/v0.4.4/parfit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7613f981c721563544826968054e23911b38bb291aa69673d32c7e0c58228db6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "parfit" if OS.mac? && Hardware::CPU.arm?
    bin.install "parfit" if OS.mac? && Hardware::CPU.intel?
    bin.install "parfit" if OS.linux? && Hardware::CPU.arm?
    bin.install "parfit" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
