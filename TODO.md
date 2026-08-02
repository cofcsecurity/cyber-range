# Range Build-Out Backlog

Tracking items from the 2026-08-02 feasibility review. See that review for full rationale on sequencing and dependencies.

## Now
- [ ] Remote state backend (S3 + DynamoDB lock) — destroy workflow currently can't retrieve its own state artifact.
      **Blocked on human input**: needs a real S3 bucket + DynamoDB table (bucket name, region, who owns it), plus
      updating `terraform-check.yaml` to `init -backend=false` so the check job keeps working without AWS creds.
      Not something to provision unattended.
- [x] Bump Terraform (`>= 0.14.9`) and AWS provider (`~> 3.63.0`) pins — bumped to `>= 1.5.0` / `~> 3.76.0`
      (latest 3.x). Jump to provider 4.x/5.x/6.x deliberately deferred — those carry breaking schema changes
      (e.g. `aws_eip.vpc` → `domain`) that need a real `terraform plan` against live state to validate safely.
- [x] Fix `blue_ubuntu_mail` — now provisioned from `ubuntu-email` AMI instead of `mongo`
- [x] Clean up leftover/duplicate `blue_mongo_*` instances in `bluenet.tf` — removed 5 unused hosts

## Detection
- [ ] Wazuh agents fleet-wide — on hold: no cloud-init/Ansible layer exists yet to get an agent onto hosts without
      one-off boot scripts I can't verify against real AWS. Revisit alongside scenario tooling below.
- [ ] Security Onion box + VPC Traffic Mirroring sessions — **in review**, [feature/security-onion](https://github.com/cofcsecurity/cyber-range/pull/new/feature/security-onion).
      Adds the host, monitor NIC, and a mirror session per existing blue_subnet host. Needs: a `range-security-onion`
      AMI built (Security Onion installs as its own appliance, not a package), sizing verified under real load, and
      a real `terraform plan`/`apply` since I have no AWS credentials to test this against live infra.

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
