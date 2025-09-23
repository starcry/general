| Command             | What it does                                                                                     | Example                                      |
| ------------------- | ------------------------------------------------------------------------------------------------ | -------------------------------------------- |
| `ms`                | Start Minikube and enable Ingress addon.                                                         | `ms`                                         |
|---------|--------------|---------|
| `gl`                | Pretty Git graph log.                                                                            | `gl`                                         |
|---------|--------------|---------|
| `gdm`               | Pretty Git log of commits not on `master` (current..master).                                     | `gdm`                                        |
|---------|--------------|---------|
| `gs`                | Git status (short alias).                                                                        | `gs`                                         |
|---------|--------------|---------|
| `gat`               | Stage all modified tracked files.                                                                | `gat`                                        |
|---------|--------------|---------|
| `gaa`               | Stage updated/removed tracked files (`git add -u`).                                              | `gaa`                                        |
|---------|--------------|---------|
| `gb`                | Print current Git branch name.                                                                   | `gb`                                         |
|---------|--------------|---------|
| `gco`               | Create a conventional commit message: `TYPE: BRANCH: message`.                                   | `gco fix "remove trailing spaces"`           |
|---------|--------------|---------|
| `tf`                | Alias for Terraform.                                                                             | `tf version`                                 |
|---------|--------------|---------|
| `tg`                | Alias for Terragrunt.                                                                            | `tg --version`                               |
|---------|--------------|---------|
| `tgp`               | Terragrunt plan.                                                                                 | `tgp`                                        |
|---------|--------------|---------|
| `tfp`               | Terraform plan to file `tf.plan`.                                                                | `tfp`                                        |
|---------|--------------|---------|
| `tfa`               | Terraform apply from `tf.plan`.                                                                  | `tfa`                                        |
|---------|--------------|---------|
| `rb`                | Reload `~/.bashrc` and `~/.bash_profile`.                                                        | `rb`                                         |
|---------|--------------|---------|
| `tgo`               | Open a new tmux session named `aidan`.                                                           | `tgo`                                        |
|---------|--------------|---------|
| `fn`                | Find files by name (in current tree).                                                            | `fn "*.tf"`                                  |
|---------|--------------|---------|
| `lsd`               | Disk usage per subdirectory (human-readable).                                                    | `lsd`                                        |
|---------|--------------|---------|
| `gr`                | `cd` to Git repository root.                                                                     | `gr`                                         |
|---------|--------------|---------|
| `ocp`               | Copy STDIN to system clipboard (xclip).                                                          | \`echo hi | ocp\`                            |
|---------|--------------|---------|
| `choco`             | Echo a Chocolatey install one-liner (Windows).                                                   | `choco`                                      |
|---------|--------------|---------|
| `rts`               | Strip trailing spaces in all files under `.`                                                     | `rts`                                        |
|---------|--------------|---------|
| `ppc`               | Format a CSV into columns (via `column -s,`).                                                    | `ppc data.csv`                               |
|---------|--------------|---------|
| `lsak`              | List AWS IAM users and their access keys.                                                        | `lsak`                                       |
|---------|--------------|---------|
| `hc`                | Save the Nth most recent shell command into `$COMMAND`.                                          | `hc 10`                                      |
|---------|--------------|---------|
| `gg`                | Case-insensitive `git grep` across repo, with line numbers.                                      | `gg password`                                |
|---------|--------------|---------|
| `insid`             | AWS EC2: describe a single instance by ID.                                                       | `insid i-0123456789abcdef0`                  |
|---------|--------------|---------|
| `instag`            | AWS EC2: list instances; filter by value and optional tag key.                                   | `instag web Name`                            |
|---------|--------------|---------|
| `inssec`            | Show unique inbound SG rules for an instance.                                                    | `inssec i-0123456789abcdef0`                 |
|---------|--------------|---------|
| `ssm`               | Start SSM session to `$i` (used by `sst`).                                                       | `i=i-0123; ssm`                              |
|---------|--------------|---------|
| `sst`               | Start SSM sessions to all **running** instances matching a name.                                 | `sst backend`                                |
|---------|--------------|---------|
| `lssec`             | List AWS Secrets Manager secrets (Name, ARN).                                                    | `lssec`                                      |
|---------|--------------|---------|
| `getsec`            | Print key/values of secrets matching a substring.                                                | `getsec prod/db`                             |
|---------|--------------|---------|
| `mtgf`              | Temporarily rename `terragrunt*.hcl` → `.tf`, format, and revert.                                | `mtgf`                                       |
|---------|--------------|---------|
| `tgf`               | Loop-format Terragrunt files by temporary rename.                                                | `tgf`                                        |
|---------|--------------|---------|
| `tff`               | Run `terraform fmt` on all `*.tf` (excluding cache).                                             | `tff`                                        |
|---------|--------------|---------|
| `tcp`               | Copy current tmux buffer to clipboard (Linux/macOS aware).                                       | `tcp`                                        |
|---------|--------------|---------|
| `wp`                | Watch Kubernetes pods and grep for a string.                                                     | `wp api`                                     |
|---------|--------------|---------|
| `ep`                | `kubectl exec` into a pod with `/bin/sh`.                                                        | `ep my-pod-abcdef`                           |
|---------|--------------|---------|
| `gwr`               | Remove trailing whitespace in tracked files (\`tf                                                | hcl | py | json | groovy | ts\`). | `gwr`    |
|---------|--------------|---------|
| `t2s`               | Convert tabs to two spaces in `*.tf` and `*.hcl`.                                                | `t2s`                                        |
|---------|--------------|---------|
| `gba`               | Count commits per Git author.                                                                    | `gba`                                        |
|---------|--------------|---------|
| `fixb`              | Clean repo: strip spaces, convert tabs → spaces, fmt Terraform/Terragrunt, and commit each step. | `fixb`                                       |
|---------|--------------|---------|
| `awsp`              | Set `AWS_PROFILE` (defaults to `default`).                                                       | `awsp prod`                                  |
|---------|--------------|---------|
| `fmtbranch`         | Rename `*.hcl` → `*.tf` and format (batch).                                                      | `fmtbranch`                                  |
|---------|--------------|---------|
| `taws`              | Temporarily set (`taws KEY SECRET`) or unset (`taws`) AWS creds.                                 | `taws AKIA... wJalrXUtn...`                  |
|---------|--------------|---------|
| `parse_git_branch`  | Echo current branch formatted for PS1.                                                           | `parse_git_branch`                           |
|---------|--------------|---------|
| `cdr`               | `cd` up to the repo root from anywhere inside it.                                                | `cdr`                                        |
|---------|--------------|---------|
| `tflog`             | Enable verbose Terraform logging to `./log.log`.                                                 | `tflog && tf plan`                           |
|---------|--------------|---------|
| `reni`              | Find ENI ID(s) by hostname (Route53 lookup).                                                     | `reni db.internal.local`                     |
|---------|--------------|---------|
| `inspw`             | Get Windows password data for an EC2 instance (with key).                                        | `inspw i-0123 keypair.pem`                   |
|---------|--------------|---------|
| `sga`               | Show ENI attachment info filtered by Security Group ID.                                          | `sga sg-0123456789abcdef0`                   |
|---------|--------------|---------|
| `l53`               | List Route53 hosted zones (ID, Name).                                                            | `l53`                                        |
|---------|--------------|---------|
| `shzone`            | Show record sets for a hosted zone ID (tabular).                                                 | `shzone Z123ABCDEF`                          |
|---------|--------------|---------|
| `s53`               | List zone + non-NS/SOA records for zones matching a string/ID.                                   | `s53 example.com`                            |
|---------|--------------|---------|
| `r53`               | For all zones: print zone header + records, filtered by string.                                  | `r53 example.com`                            |
|---------|--------------|---------|
| `gc`                | Re-encode GoPro `.MP4` files to H.265 (smaller).                                                 | `gc`                                         |
|---------|--------------|---------|
| `aaws`              | Run a command once per AWS profile in `~/.aws/credentials`.                                      | `aaws 'aws sts get-caller-identity'`         |
|---------|--------------|---------|
| `run_python_script` | Activate `~/myenv` and run a script/command with args.                                           | `run_python_script scripts/report.py --flag` |
|---------|--------------|---------|
| `pbcopy`            | Copy STDIN to clipboard (Linux via xclip).                                                       | \`echo hello | pbcopy\`                      |
|---------|--------------|---------|
| `pbpaste`           | Paste from clipboard to STDOUT.                                                                  | `pbpaste > notes.txt`                        |
|---------|--------------|---------|
| `fc`                | Copy a file’s contents to clipboard.                                                             | `fc README.md`                               |
|---------|--------------|---------|
| `flash_screen`      | Briefly invert terminal screen (visual flash).                                                   | `flash_screen`                               |
|---------|--------------|---------|
| `whatismyip`        | Show your public IP address (OpenDNS).                                                           | `whatismyip`                                 |
