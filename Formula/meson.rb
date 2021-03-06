class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.44.0/meson-0.44.0.tar.gz"
  sha256 "50f9b12b77272ef6ab064d26b7e06667f07fa9f931e6a20942bba2216ba4281b"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99722391bc3b2289943de52db40d7b5852d34a2ccd73d2e199d21ef7f45c84f9" => :high_sierra
    sha256 "99722391bc3b2289943de52db40d7b5852d34a2ccd73d2e199d21ef7f45c84f9" => :sierra
    sha256 "99722391bc3b2289943de52db40d7b5852d34a2ccd73d2e199d21ef7f45c84f9" => :el_capitan
  end

  depends_on :python3
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
