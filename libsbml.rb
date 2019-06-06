class Libsbml < Formula
  desc "Library project for handling SBML files and data streams"
  homepage "http://sbml.org/Software/libSBML"
  url "https://downloads.sourceforge.net/project/sbml/libsbml/5.18.0/stable/libSBML-5.18.0-core-plus-packages-src.tar.gz"
  version "5.18.0"
  sha256 "6c01be2306ec0c9656b59cb082eb7b90176c39506dd0f912b02e08298a553360"

  bottle :unneeded

  depends_on "cmake" => :build
  depends_on "swig" => :build

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <sbml/SBMLTypes.h>
      int main() {
        SBMLDocument_t *d = SBMLDocument_createWithLevelAndVersion(3, 1);
        SBMLDocument_free(d);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsbml", "-o", "test"
    system "./test"
  end
end
