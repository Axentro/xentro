# Tako - Axentro Wallet

This is a desktop (electron) wallet for the Axentro blockchain. It's written in the Mint language and distributed as an electron desktop app.

### Packaging

- Build the mint app for production:

```bash
mint build --skip-icons --skip-service-worker
```

- Start up the app with python

```bash
python3 -m http.server --directory dist/
```

- Wrap the app in electron

```bash
nativefier --name "Tako - Axentro Wallet" --min-width 1280  --min-height 600 --disable-context-menu --disable-dev-tools "http://0.0.0.0:8000"
```
