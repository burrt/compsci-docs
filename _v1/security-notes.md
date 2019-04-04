---
layout: compsci-note
title: Security Notes
categories: [security]
description: Some very basic notes on security
order: 20
sitemap: false
---

# Contents

* [TOTP](#totp)
* [HTOP](#htop)

## TOTP

> Time-based One-time Password Algorithm is an algorithm that computes a one-time password from a shared secret key and the current time.
[Wikipedia](https://en.wikipedia.org/wiki/Time-based_One-time_Password_Algorithm)

Also see [RFC 6238](https://tools.ietf.org/html/rfc6238)

### Definition

TOTP is based on HOTP with a timestamp replacing the incrementing counter.

* current timestamp is turned into an integer time-counter (TC)
* start of an epoch (T0)
* counting in units of a time interval (TI).

For example:

```text
TC = floor((unixtime(now) − unixtime(T0)) / TI)
TOTP = HOTP(SecretKey, TC)
TOTP-Value = TOTP mod 10d  // where d is the desired number of digits of the one-time password.
```

### Implementation

* generate a key, `K`, which is an arbitrary byte string, and share it securely with the client.
* agree upon a `T0`, the Unix time to start counting time steps from (default Unix epoch)
* agree on an interval, `TI`, which will be used to calculate the value of the counter `C` (default 30 seconds)
* agree upon a cryptographic hash method (default is `SHA-1`)
  * TOTP implementations may use `HMAC-SHA-256` or `HMAC-SHA-512` functions based on `SHA-256` or `SHA-512` `SHA2` hash functions - [RFC 6238](https://tools.ietf.org/html/rfc6238#section-1.2))
* agree upon a token length, `N` (default is 6)

Although `RFC 6238` allows different parameters to be used, the Google implementation of the authenticator app does **not** support `T0`, `TI` values, hash methods and token lengths different from the default. It also expects the K secret key to be entered (or supplied in a QR code) in base-32 encoding according to `RFC 3548`.

Once the parameters are agreed upon, **token generation** is as follows:

* calculate `C` as the number of times `TI` has elapsed after `T0`.
* compute the HMAC hash `H` with `C` as the *message* and `K` as the key.
* `K` should be passed as it is, `C` should be passed as a *raw 64-bit unsigned integer*.
* take the least 4 significant bits of `H` and use it as an offset, `O`.
* take 4 bytes from `H` starting at O bytes MSB, **discard** the most significant bit and store the rest as an (unsigned) 32-bit integer, `I`.
* the token is the lowest `N` digits of `I` in base 10.
* if the result has fewer digits than `N`, pad it with zeroes from the left.

Now:

* both the server and the client compute the token
* then the server checks if the token supplied by the client matches the locally generated token
* some servers allow codes that should have been generated **before or after the current time** in order to account for slight *clock skews, network latency and user delays*

## HTOP

HOTP is an HMAC-based one-time password (OTP) algorithm. See [Wikipedia](https://en.wikipedia.org/wiki/HMAC-based_One-time_Password_Algorithm#Definition).

### Definition

* `K` be a secret key
* `C` be a counter
* `HMAC(K, m) = SHA1(K ⊕ 0x5c5c… ∥ SHA1(K ⊕ 0x3636… ∥ m))`
* `m` is a "message"
* `⊕` means `XOR`
* `∥` means concatenation
* `Truncate` be a function that selects 4 bytes from the result of the HMAC in a defined manner

Then `HOTP(K, C)` is mathematically defined by:

```text
HOTP(K, C) = Truncate(HMAC(K, C)) & 0x7FFFFFFF
```

The mask `0x7FFFFFFF` sets the result's MSB to zero. This avoids problems if the result is interpreted as a signed number as some processors do.

*For HOTP to be useful for an individual to input to a system, the result must be converted into a `HOTP` value, a 6–8 digits number that is implementation dependent.*

```text
HOTP-Value = HOTP(K, C) mod 10d  // where d is the desired number of digits
```