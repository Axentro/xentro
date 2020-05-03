# Tako - SushiChain Wallet

This is a dekstop (electron) wallet for the SushiChain blockchain. It's written in the Mint language and distributed as an electron desktop app.

### Packaging

* Build the mint app for production:

```bash
mint build --skip-icons --skip-service-workers
```

* Start up the app with python

```bash
python3 -m http.server
```

* Wrap the app in electron

```bash
nativefier --name "Tako - SushiChain Wallet" --min-width 1280  --min-height 600 --disable-context-menu --disable-dev-tools "http://0.0.0.0:8000"
```