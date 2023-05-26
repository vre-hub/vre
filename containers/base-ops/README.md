# VRE base layer ops container

Common base container for all VRE operations.

It contains:
 - A fixed version of rucio-server: `rucio/rucio-server:release-1.30.0`
   - uses `centos:7`
 - Useful basic programs
   - `git`, `wget`, `htop`, latest version of `kubectl`
 - CERN CA certs installed from CERN maintained mirror
 - ESCAPE VOMS and its setup
 - EGI trust anchors
 