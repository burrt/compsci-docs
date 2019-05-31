---
layout: compsci-note
title: C# Tips
categories: [tips, language]
description: Some tips and tricks with C#
sitemap: false
---

## C# Tips

### Empty async delegate

Useful for unit testing for mocks or even for method signatures that require a delegate.

```cs
(x, y) => {}
```
