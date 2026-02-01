{ resume-dev, ... }: {
  security.protectKernelImage = false; # https://discourse.nixos.org/t/hibernate-doesnt-work-anymore/24673/7
  boot = {
    kernelParams = if resume-dev == "" then [] else ["resume=${resume-dev}"];
    resumeDevice = "${resume-dev}";
  };
  powerManagement = {
    enable = true;
  };
}