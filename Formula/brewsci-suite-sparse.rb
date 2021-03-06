class BrewsciSuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.5.tar.gz"
  sha256 "b9a98de0ddafe7659adffad8a58ca3911c1afa8b509355e7aa58b02feb35d9b6"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-num"
    cellar :any
    sha256 "149a2e31b30bcff81142bef63462007756c866275e4603972d77333972f929d2" => :sierra
    sha256 "a58bd43534be8504bd86e0c971ed492568a3824366171aecad22e89c831c3beb" => :x86_64_linux
  end

  keg_only "suite-sparse is provided by homebrew/core"

  depends_on "brewsci/num/brewsci-metis"
  depends_on "openblas"

  def install
    args = [
      "INSTALL=#{prefix}",
      "BLAS=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "LAPACK=$(BLAS)",
      "MY_METIS_LIB=-L#{Formula["brewsci-metis"].opt_lib} -lmetis",
      "MY_METIS_INC=#{Formula["brewsci-metis"].opt_include}",
    ]
    system "make", "library", *args
    system "make", "install", *args
    lib.install Dir["**/*.a"]
    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    ENV.prepend_path "LD_LIBRARY_PATH", lib unless OS.mac?
    system ENV.cc, "-o", "test", "-I#{include}", pkgshare/"klu_simple.c",
                   "-L#{lib}", "-lsuitesparseconfig", "-lklu"
    system "./test"
  end
end
