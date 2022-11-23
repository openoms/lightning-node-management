# Tailscale on FreeBSD

## Install
```
pkg install -y tailscale
service tailscaled start
service tailscaled enable

tailscale up
```

## Update
```
pkg update
pkg install -y tailscale
```
