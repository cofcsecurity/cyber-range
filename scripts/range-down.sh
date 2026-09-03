#!/usr/bin/env zsh
# Tear down the cyber-range: terraform destroy -auto-approve
set -euo pipefail

# Set AWS_PROFILE to your own AWS CLI profile for the club account before
# running this (see README.md), or export it in the environment that invokes
# this script (e.g. inside the macOS Shortcut).
AWS_PROFILE="${AWS_PROFILE:?Set AWS_PROFILE to your AWS CLI profile for the range account (see README.md)}"
export AWS_PROFILE
EXPECTED_ACCOUNT="126301120351"

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

LOG_DIR="$HOME/Library/Logs/cyber-range"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/range-down-$(date +%Y%m%d-%H%M%S).log"

ACTUAL_ACCOUNT="$(aws sts get-caller-identity --query Account --output text 2>&1)" || {
  osascript -e "display notification \"AWS_PROFILE=$AWS_PROFILE failed to authenticate\" with title \"Cyber Range\" sound name \"Basso\""
  echo "Failed to resolve AWS identity for profile $AWS_PROFILE: $ACTUAL_ACCOUNT" | tee "$LOG_FILE"
  exit 1
}
if [ "$ACTUAL_ACCOUNT" != "$EXPECTED_ACCOUNT" ]; then
  osascript -e "display notification \"Wrong AWS account: got $ACTUAL_ACCOUNT, expected $EXPECTED_ACCOUNT\" with title \"Cyber Range\" sound name \"Basso\""
  echo "Refusing to run: AWS_PROFILE=$AWS_PROFILE resolved to account $ACTUAL_ACCOUNT, expected $EXPECTED_ACCOUNT" | tee "$LOG_FILE"
  exit 1
fi

osascript -e "display notification \"Destroying range under $AWS_PROFILE (account $ACTUAL_ACCOUNT) — this takes a few minutes, watch for the completion notification.\" with title \"Cyber Range\" subtitle \"Destroy started\""

STATUS=0
{
  echo "=== Range destroy started: $(date) ==="
  echo "AWS profile: $AWS_PROFILE (account $ACTUAL_ACCOUNT)"
  terraform destroy -input=false -auto-approve
  echo "=== Range destroy finished: $(date) ==="
} 2>&1 | tee "$LOG_FILE" || STATUS=$?

if [ "$STATUS" -eq 0 ]; then
  osascript -e 'display notification "Range destroyed" with title "Cyber Range" sound name "Glass"'
else
  osascript -e "display notification \"Range destroy FAILED — see $LOG_FILE\" with title \"Cyber Range\" sound name \"Basso\""
fi

exit "$STATUS"
