{ lib, stdenv, buildGoModule, fetchFromGitHub, git, Virtualization, testers, linuxkit }:

buildGoModule rec {
  pname = "linuxkit";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "linuxkit";
    repo = "linuxkit";
    rev = "v${version}";
    sha256 = "sha256-y/jsMr7HmrHjVMn4fyQ3MPHION8hQO2G4udX1AMx8bk=";
  };

  vendorSha256 = null;

  modRoot = "./src/cmd/linuxkit";

  buildInputs = lib.optionals stdenv.isDarwin [ Virtualization ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/linuxkit/linuxkit/src/cmd/linuxkit/version.Version=${version}"
  ];

  checkInputs = [ git ];

  passthru.tests.version = testers.testVersion {
    package = linuxkit;
    command = "linuxkit version";
  };

  meta = with lib; {
    description = "A toolkit for building secure, portable and lean operating systems for containers";
    license = licenses.asl20;
    homepage = "https://github.com/linuxkit/linuxkit";
    maintainers = with maintainers; [ nicknovitski ];
    platforms = platforms.unix;
  };
}
