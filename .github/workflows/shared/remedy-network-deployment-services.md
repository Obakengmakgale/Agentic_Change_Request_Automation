## Remedy service: Network Deployment Services

Catalogue description: "Load Balancing, Switch & Port Config, DNS, VLAN, VPC, Subnet, and DNS". The form notes a 3-day lead time for normal changes and 10 days for high-risk ones.

Fields marked `*` are required. The form reveals fields in stages, in this order.

**Always present:** Network Platform\* (AWS | Azure | On Prem), Reason for Request\*, Alternative Contact Details\*, Additional Information.

**Platform = AWS** reveals Request Type\*: 3rd Party connectivity | Azure Connectivity | Create Custom VPC/Subnets | Classless Inter-Domain Routing (CIDR) | Internet Facing Environment | Private Route53 DNS Hosted Zone. A request that only says "AWS" with no other detail means **Create Custom VPC/Subnets**.

**Request Type = Create Custom VPC/Subnets** reveals, in order:

| Field | Default / rule |
|---|---|
| VPC ID\* | `N/A` for a new VPC |
| Tiering | optional, normally blank |
| Number of Private Subnets\* | default 4 |
| Number of IP Addresses per Private Subnet\* | default 251 |
| Number of Public Subnets\* | default 2 |
| Number of IP Addresses per Public Subnet\* | default 251 |
| Region\* | Cape Town \| Ireland \| Other. "Other" reveals **Specify Other Region\*** (e.g. Frankfurt). Map AWS codes: af-south-1 → Cape Town, eu-west-1 → Ireland, eu-central-1 → Other/Frankfurt |
| Private hosted zone (URL) | optional |
| Environment\* | Production \| Non-Prod |
| Requesting Region\* | Africa Region/International \| South Africa (default) |
| AWS Account\* | **Filled by Remedy, not typed.** Choosing the account (Account ID picker) makes Remedy populate four lines from its account database: `Account Name: <name>` / `Account ID: <12 digits>` / `Account Owner: <name>` / `Technical Owner: <name>`. In the request table give the expected four lines so the executor can verify them; the executor must not edit this field |
| Reason for Request\* | 1–3 sentences: what the application is and why it needs this network change |
| Alternative Contact Details\* | the requester's email address |
| Additional Information | optional, e.g. a region note or "please reach out with questions" |

**Known accounts (Centaur Banker; Account Owner and Technical Owner are both Mabu Manaileng in Remedy's account database):**
- Production: `ZAF-PROD-TC002170-APP-Centaur-Banker`, ID `750907156317`, Region Ireland, hosted zone `tc002170-dev.afs1-nprd.aws-za.sbgrp.cloud`.
- Non-Prod: `ZAF-NPRD-TC002170-DEV-Centaur-Banker`, ID `972199684108`, Region Other → Frankfurt.

Only use these when the request is about Centaur Banker. For any other application the account name, ID, owners and reason must come from the requester.

**Azure** and **On Prem** platforms have different follow-up fields (Subscription, Resource Group, VNet; switch/port/VLAN/F5/WAN forms). They are out of scope for now: say so and stop.
