# Bluetooth helper

https://github.com/ThomasHabets/bthelper

[This is not an official Google product.](https://blog.habets.se/2022/02/SSH-over-Bluetooth-cleanly.html)

## What is it

SSH Helper program so that you can SSH over bluetooth. This can be a useful
second way in in case you have a raspberry pi with broken network or firewall
config.

[Related blog posts][blog] that describes a more full setup guide, including
pairing.

## Example usage assuming you've already paired devices

### On the server

```
bt-listener -t localhost:22 -c 2
```

### On the client

```
ssh -oProxyCommand="bt-connecter AA:BB:CC:XX:YY:ZZ 2" myhostname-console
```

Or in `~/.ssh/config`:

```
Host myhostname-console
    ProxyCommand bt-connecter AA:BB:CC:XX:YY:ZZ 2
```

And then just `ssh myhostname-console`.

## Example for console, not SSH

```
bt-listener -c 5 -e -- getty '{}' -E -H '{addr}'
```

'{}' and '{addr}' are treated special and should be written exactly as
is.

```
bt-connecter -t AA:BB:CC:XX:YY:ZZ 5
```

## Portability

Code currently relies on `signalfd()`, so it's Linux-only. Should be
portable to FreeBSD and MacOSX using `kqueue() with EVFILT_SIGNAL`,
but I don't have a mac to develop it on.

Alternatively we could switch to libevent.

[blog]: https://blog.habets.se/2022/02/SSH-over-Bluetooth-cleanly.html
