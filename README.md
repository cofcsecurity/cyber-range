# cyber-range

The Range is a very WIP infrastructure as code style AWS environment. 

It is intended to be used for infosec training purposes including red/blue team simulations, incidence response training, etc.

Additionally, the range is meant to be ephemeral(ish) and destructible such that it can be spun up and down easily and state is reset upon initialization.

AWS Range Start:

1) terraform init
2) terraform plan
3) terraform apply -auto-approve

AWS Range Stop:
4) terraform destroy -auto-approve

## macOS Shortcuts (optional)

`scripts/range-up.sh` and `scripts/range-down.sh` wrap the steps above into
one command each, with logging, a jumpbox IP lookup, and a guard that refuses
to run against the wrong AWS account. You can wire each one up to a macOS
Shortcut so the range can be built/destroyed with a click.

### 1. Configure your AWS CLI profile

Set up an AWS CLI profile for the range's AWS account (currently
`126301120351`):

```
aws configure --profile <your-profile-name>
```

Verify it resolves to the right account:

```
AWS_PROFILE=<your-profile-name> aws sts get-caller-identity
```

### 2. Point the scripts at your profile

The scripts require `AWS_PROFILE` to be set — they will refuse to run
otherwise, and they abort if the resolved account doesn't match
`126301120351`. Either export it in your shell profile, or set it directly
inside each Shortcut (see below), e.g. `AWS_PROFILE=<your-profile-name>`.

### 3. Create the Shortcuts

In the Shortcuts app:

1. **File → New Shortcut**, name it e.g. "Build Cyber Range".
2. Add a **Run Shell Script** action.
   - Shell: `/bin/zsh`
   - Script: `AWS_PROFILE=<your-profile-name> /path/to/cyber-range/scripts/range-up.sh`
3. Repeat for "Destroy Cyber Range", pointing at `scripts/range-down.sh`.
4. For the destroy shortcut, add a **Show Alert** action *before* the Run
   Shell Script action, with "Show Cancel Button" enabled. This makes it
   confirm before tearing anything down — canceling stops the shortcut
   before the script runs.

Once created, either shortcut can be run from Spotlight, the menu bar, or by
voice ("Hey Siri, Build Cyber Range").

### What the scripts do

- **range-up.sh**: `terraform init` → `plan` → `apply -auto-approve`, then
  reads the `bastion_public_ip` output, copies it to the clipboard, and
  shows a notification with the jumpbox IP.
- **range-down.sh**: `terraform destroy -auto-approve`.

Both log full output to `~/Library/Logs/cyber-range/` and post a start and a
completion notification, so a run in progress doesn't look stalled.
