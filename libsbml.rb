require 'formula'

class Libsbml < Formula
  homepage 'http://sbml.org/Software/libSBML'
  url 'http://sourceforge.net/projects/sbml/files/libsbml/5.8.0/stable/libSBML-5.8.0-src.tar.gz'
  sha1 'ca931f75962f3bb4397f96259c338185014ff091'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
