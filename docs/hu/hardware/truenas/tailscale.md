# Tailscale FreeBSD-n (Tailscale on FreeBSD)

## Telepítés (Installation)
```
pkg install -y tailscale
service tailscaled start
service tailscaled enable

tailscale up
```

## Frissítés (Updating)
```
pkg update
pkg install -y tailscale
```
