{ pkg-config, libusb1, dbus, lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "system76-power";
  version = "1.1.25";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-power";
    rev = version;
    sha256 = "sha256-h9SWuVqH3b9OT6OwC+oQ7B+X0aiqy4mV6HA9Y1WK/3M=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus libusb1 ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "sysfs-class-0.1.3" = "sha256-ztfwfCRAkxUd/LLNG5fpVuFdgX+tCKL3F35qYJ2GDm8=";
    };
  };

  postInstall = ''
    install -D -m 0644 data/com.system76.PowerDaemon.conf $out/etc/dbus-1/system.d/com.system76.PowerDaemon.conf
    install -D -m 0644 data/com.system76.PowerDaemon.policy $out/share/polkit-1/actions/com.system76.PowerDaemon.policy
    install -D -m 0644 data/com.system76.PowerDaemon.xml $out/share/dbus-1/interfaces/com.system76.PowerDaemon.xml
  '';

  meta = with lib; {
    description = "System76 Power Management";
    mainProgram = "system76-power";
    homepage = "https://github.com/pop-os/system76-power";
    license = licenses.gpl3Plus;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ maintainers.jwoudenberg ];
  };
}
