# Range Build-Out Backlog

Tracking items from the 2026-08-02 feasibility review. See that review for full rationale on sequencing and dependencies.

## Now
- [ ] Remote state backend (S3 + DynamoDB lock) — destroy workflow currently can't retrieve its own state artifact
- [ ] Bump Terraform (`>= 0.14.9`) and AWS provider (`~> 3.63.0`) pins
- [ ] Fix `blue_ubuntu_mail` — provisioned from the mongo AMI instead of the unused `ubuntu-email` AMI
- [ ] Clean up leftover/duplicate `blue_mongo_*` instances in `bluenet.tf`

## Detection
- [ ] Wazuh agents fleet-wide (no traffic mirroring required)
- [ ] Security Onion box + VPC Traffic Mirroring sessions (not a passive second NIC — AWS needs mirroring configured per source ENI)

## Scoring & spectator
- [ ] New isolated white/scoring subnet
- [ ] Stand up `scoringengine`, wire per-service checks against existing hosts
- [ ] Expose read-only scoreboard/spectator dashboard

## Scenario tooling
- [ ] Break up `bluenet.tf` into per-role modules + scenario `.tfvars`
- [ ] Move host config from golden AMIs into cloud-init/Ansible
- [ ] Domain-join hosts that should depend on `blue_windows_ad`, wire web server to actually read from `blue_CODB`, populate DNS records on `blue_dns`

## SECCDC realism
- [ ] Default-deny SG/NACL rules for blue to manage (currently allow-all everywhere)
- [ ] SCADASim host (CMU SEI SCADASim)
- [ ] **Caldera** — automated red-team attack chains for solo practice sessions when an external red teamer isn't available

## Later
- [ ] Competition scripting (backups, restore-from-broken-state, file-change detection) — deferred, revisit separately
