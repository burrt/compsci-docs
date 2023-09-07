---
layout: compsci-note
title: Useful C#/.NET tools and libraries
categories: [titoolsps, language]
description: Some useful tools/libraries for C#/.NET
---

## Useful C#/.NET tools and libraries

I think it would be useful to list a number of tools and libraries that I use when setting up new services as well as the reference documentation. This may get out of date soon however it will at least give me a reference point to revisit.

## Logging

* [Serilog](https://github.com/serilog/serilog)
  * for json logs, it is particularly useful for logging services like AWS CloudWatch
    * https://nblumhardt.com/2016/07/serilog-2-0-json-improvements/
    * https://nblumhardt.com/2016/06/structured-logging-concepts-in-net-series-1/
  * .NET/C# request logging improvements - https://github.com/serilog/serilog-aspnetcore#request-logging
  * some protection against PII - https://github.com/serilog-contrib/Serilog.Enrichers.Sensitive
    * a more powerful but manual library - https://github.com/destructurama/attributed

## HTTP

* .NET `HttpClient` is quite sufficient
* HTTP Request retries - https://github.com/App-vNext/Polly

### Swagger/Open API

* https://learn.microsoft.com/en-us/aspnet/core/tutorials/getting-started-with-swashbuckle
* https://github.com/domaindrivendev/Swashbuckle.AspNetCore/tree/master

## Database

Sometimes ORM isn't necessary, for mysql, the [MySqlConnector](https://github.com/mysql-net/MySqlConnector) seems quite handy.

