class SdslLite < Formula
  # cite Gog_2013: "https://arxiv.org/abs/1311.1249"
  desc "Succinct Data Structure Library 2.0"
  homepage "https://github.com/simongog/sdsl-lite"
  sha256 "ce4c65bbc6638e697deb0a4eb8c74a9daec382741a2481c95b7624a86e133efe"
  head "https://github.com/simongog/sdsl-lite", :branch => "master"

  # Use git to get submodules.
  url "https://github.com/simongog/sdsl-lite.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e44e437f1f32ce5fb6de0cfc5aec132bfc09322ad71c211a8bb77bc332d4325c" => :sierra_or_later
    sha256 "34182f95fd635533ba8f686b5ebafe411204dbcb3969a6b2e92f2e22c4d778bb" => :x86_64_linux
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    # Reduce memory usage for Circle CI
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]
    ENV.cxx11
    system "./install.sh", prefix
    pkgshare.install "examples", "extras", "tutorial"
  end

  test do
    ENV.cxx11
    system *ENV.cxx.split, "-o", "fm-index",
      "-I#{opt_include}", pkgshare/"examples/fm-index.cpp",
      "-L#{opt_lib}", "-lsdsl", "-ldivsufsort", "-ldivsufsort64"
    assert_match "FM-index", shell_output("./fm-index 2>&1", 1)
  end
end
