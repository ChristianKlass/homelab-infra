# homelab-infra

Terraform definitions for the guests on my single-node Proxmox homelab. One file per
guest (LXC or VM) with cores, memory, disk, storage pool and a static IP.

A few things worth knowing before reading too much into it:

- Provider is `bpg/proxmox`. The API endpoint, token and SSH keys come from
  `terraform.tfvars`, which is not committed. State is local and not committed either.
- Most guests were imported into state after the fact rather than built by Terraform,
  so the template references are placeholders. This repo describes and manages the
  guests; it won't cold-provision them on a fresh node.
- Device passthrough (iGPU, Coral USB) is wired up on the host directly and sits
  outside Terraform on purpose.

`scripts/` holds a couple of small operational scripts that run from the same box.

This is a curated copy of a private repo: fresh history, network addressing rewritten,
and some guests left out.
