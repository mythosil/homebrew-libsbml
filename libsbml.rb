require 'formula'

class Libsbml < Formula
  homepage 'http://sbml.org/Software/libSBML'
  url 'http://sourceforge.net/projects/sbml/files/libsbml/5.9.0/stable/libSBML-5.9.0-core-plus-packages-src.zip'
  version '5.9.0'
  sha1 '91305920fa12db48d3ae7f6ea7f272415ed97616'

  depends_on 'cmake' => :build
  depends_on 'swig' => :build
  depends_on :python => :optional

  option 'with-csharp', 'generate C# interface library [default=no]'
  option 'with-java', 'generate Java interface library [default=no]'
  option 'with-matlab', 'generate MATLAB interface library [default=no]'
  option 'with-octave', 'generate Octave interface library [default=no]'
  option 'with-perl', 'generate Perl interface library [default=no]'
  option 'with-ruby', 'generate Ruby interface library [default=no]'

  def install
    mkdir 'build' do
      args = std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      
      python do
        args << '-DWITH_PYTHON=ON'
        args << "-DPYTHON_INCLUDE_DIR='#{python.incdir}'"
        args << "-DPYTHON_LIBRARY='#{python.libdir}/lib#{python.xy}.dylib'"
        args << "-DPYTHON_SETUP_ARGS:STRING='--prefix=#{prefix} --single-version-externally-managed --record=installed.txt'"
      end

      args << '-DWITH_CSHARP=ON' if build.with? 'csharp'
      args << '-DWITH_JAVA=ON' if build.with? 'java'
      args << '-DWITH_MATLAB=ON' if build.with? 'matlab'
      args << '-DWITH_OCTAVE=ON' if build.with? 'octave'
      args << '-DWITH_PERL=ON' if build.with? 'perl'
      args << '-DWITH_RUBY=ON' if build.with? 'ruby'

      system 'cmake', '..', *args
      ENV.deparallelize # just for debug
      system 'make', 'install'
    end
  end
end
