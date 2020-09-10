# Xentro - Axentro Wallet

This is a desktop (electron) wallet for the Axentro blockchain. It's written in the Mint language and distributed as an electron desktop app.

### Developing

- Build the mint app for production:

```bash
mint build --skip-icons --skip-service-worker
```

- Start up the app with python

```bash
python3 -m http.server --directory dist/
```
