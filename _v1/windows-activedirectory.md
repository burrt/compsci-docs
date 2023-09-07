---
layout: compsci-note
title: Active Directory
categories: [windows]
description: Some notes on Active Directory
---

## Security Groups

Security groups can be used to assign user rights and assign permissions to resources.

### Group Scopes

* **Universal**: can grant permissions in any domain in the same forest or trusting forest
* **Global**: can grant permissions on any domain in the same forest, or trusting domains or forests
* **Domain** local: can grant permissions within the same domain

## Special Identities

* They can still be assigned rights and permissions but cannot view or edit their memberships
* Group scopes do **not** apply
* Examples: Authenticated User, Everyone
