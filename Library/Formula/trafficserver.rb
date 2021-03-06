require 'formula'

class Trafficserver < Formula
  url 'http://www.apache.org/dyn/closer.cgi/trafficserver/trafficserver-3.0.4.tar.bz2'
  homepage 'http://trafficserver.apache.org/'
  md5 '90e259fb09cb7439c6908f1f5344c40f'

  head 'http://svn.apache.org/repos/asf/trafficserver/traffic/trunk/'

  devel do
    url 'http://www.apache.org/dyn/closer.cgi/trafficserver/trafficserver-3.1.2-unstable.tar.bz2'
    md5 '2208cb9a0d0b7cea07770d51b1cf7df2'
  end

  depends_on 'pcre'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf -i" if ARGV.build_head?

    # Needed for correct ./configure detections.
    ENV.enable_warnings
    # Needed for OpenSSL headers on Lion.
    ENV.append_to_cflags "-Wno-deprecated-declarations"
    system "./configure", "--prefix=#{prefix}", "--with-user=#{ENV['USER']}", "--with-group=admin"
    system "make install"
  end

  def test
    system "trafficserver status"
  end
end
