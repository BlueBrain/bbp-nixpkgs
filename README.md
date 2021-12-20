## BBP NIXPKGS 


Contains all the nix expressions for the Blue Brain Project.

* See pkgs/top-level/all-packages.nix for a complete list of supported software.

* See pkgs/bbp/* for the list of the specific BBP softwares.

For any information about nix usage in the BBP, please check https://bbpteam.epfl.ch/project/spaces/display/BBPHPC/Nix+Package+Manager


## Version Update Workflow

If you have updated software package and would like to deploy new version via nix, follow below steps :

#### Step 1
Clone `bbp-nixpkgs` repository :
```
git clone https://github.com/BlueBrain/bbp-nixpkgs.git
```

#### Step 2
Update `revision-id` for your software package. For example, for ReportingLib you have to edit below section in `bbp-nixpkgs/bbp/hpc/neurodamus/default.nix` :
```
  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/reportinglib/bbp";
    rev = "98f5b5869ad3a2c741e847a658d2bb75986ed05f";
    sha256 = "1a3p7rl2ic1x3g0xhzxh8psbq6z97qvxs60r3zlsc08y83fink4f";
  };
```
Replace `rev` with new `commit-id`. You have to also update `sha256` (just update few characters for now).

#### Step 3

Now execute below command to get correct SHA :
```
cd bbp-nixpkgs
nix-build ./ -A reportinglib.src
```

You will get an error message like :
```
output path ‘/gpfs/bbp.cscs.ch/apps/bgq/nix/nix-root/store/rl1yi89nh-bbp-fb5c1b5’ has r:sha256 hash ‘1m87s31wjyv5kz33pv9s139mbyn3j1bxgj2ivgy1dgcmcc7lr1xq’ when ‘10g0rm3l0qbgk7ylqsa38bpylnz4329ckr7y42rax586ay7zp51g’ was expected
```
Copy the `hash` (`1m87s31wjyv5k.....` in this case) and replace `sha256` filled in Step 2.

#### Step 4

If you have multiple packages to update, update them as above.

#### Step 5

Now build your software package :

```
nix-build ./ -A reportinglib
```

#### Step 6

Once everything is built successfully, commit the changes and submit a pull request on Github.


## Info

Note: Based on a direct fork of the nixos nixpkgs branch https://nixos.org/nixos

## Funding

The development of this software was supported by funding to the Blue Brain Project, a research center of the École polytechnique fédérale de Lausanne (EPFL), from the Swiss government’s ETH Board of the Swiss Federal Institutes of Technology.

Copyright (c) 2016-2021 Blue Brain Project/EPFL

