with (import ../nix {});

let

   ndk = androidenv.androidndk_17c.override { fullNDK = true; };
   ndk_root = "${ndk}/libexec/${ndk.name}";

in

mkShell {

  LANG="en_US.UTF-8";
  JAVA_HOME=openjdk8;

  nativeBuildInputs = [
    nodejs-8_x
    openjdk8
    androidenv.androidsdk_9_0 # Only used for `sdkmanager`
  ];

  passthru = { inherit ndk ndk_root; };

  shellHook = ''
    ./install-ndk-17c.sh
    ${lib.optionalString stdenv.isLinux ''
      for dep in lib lib64; do
        if [ -L /$dep ] || [ ! -e /$dep ]; then
          echo "Creating /$dep"
          ln -s ${stdenv.cc.libc}/$dep /$dep
        else
          echo "Using existing /$dep"
        fi
      done
    ''}
  '';
}
