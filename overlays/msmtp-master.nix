# Use msmtp from nixpkgs-master to fix build issues
final: prev: {
  msmtp = final.nixpkgs-master.msmtp;
}