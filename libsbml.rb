require 'formula'

class Libsbml < Formula
  homepage 'http://sbml.org/Software/libSBML'
  url 'http://sourceforge.net/projects/sbml/files/libsbml/5.9.0/stable/libSBML-5.9.0-core-plus-packages-src.zip'
  version '5.9.0'
  sha1 '91305920fa12db48d3ae7f6ea7f272415ed97616'

  LANGUAGES_OPTIONAL = {
    'csharp' => 'C#',
    'java' => 'Java',
    'matlab' => 'MATLAB',
    'octave' => 'Octave',
    'perl' => 'Perl',
    'ruby' => 'Ruby',
    'python' => 'Python'
  }
  LANGUAGES_OPTIONAL.each do |opt, lang|
    option "with-#{opt}", "generate #{lang} interface library [default=no]"
  end

  depends_on 'cmake' => :build
  depends_on 'swig' => :build
  depends_on :python => :optional

  # fix ruby's sitelib dir
  def patches; DATA; end

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
      #ENV.deparallelize # uncomment for debug
      system 'make', 'install'
    end
  end
end

__END__
--- a/src/bindings/ruby/CMakeLists.txt	2013-11-12 11:50:37.000000000 -0500
+++ b/src/bindings/ruby/CMakeLists.txt	2014-01-02 03:15:12.000000000 -0500
@@ -152,7 +152,7 @@
 if (UNIX OR CYGWIN) 
   execute_process(COMMAND "${RUBY_EXECUTABLE}" -e "print RUBY_PLATFORM"
     OUTPUT_VARIABLE RUBY_PLATFORM)
-  set(RUBY_PACKAGE_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR}/ruby/site_ruby/${RUBY_VERSION_MAJOR}.${RUBY_VERSION_MINOR}/${RUBY_PLATFORM})
+  set(RUBY_PACKAGE_INSTALL_DIR ${RUBY_SITEARCH_DIR})
 else()
   set(RUBY_PACKAGE_INSTALL_DIR ${MISC_PREFIX}bindings/ruby)
 endif()
