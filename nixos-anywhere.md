

# install
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-facter ./facter.json --flake .#nixos-facter --target-host root@10.0.0.12


# deploy new configs
https://nixos-and-flakes.thiscute.world/best-practices/remote-deployment

nixos-rebuild switch --flake .#nixos-facter --target-host root@10.0.0.13 --build-host root@10.0.0.13 --verbose
