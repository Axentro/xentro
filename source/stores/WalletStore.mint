record WalletConfig {
  node : String,
  speed : String
}

record EncryptedWalletWithConfig {
  wallet : EncryptedWallet,
  config : WalletConfig
}

store WalletStore {
  state walletError : String = ""
  state currentWallet : Maybe(Wallet) = Maybe.nothing()
  state currentWalletName : String = ""
  state currentWalletConfig : WalletConfig = defaultWalletConfig
  state encryptedWalletWithConfig : Maybe(EncryptedWalletWithConfig) = Maybe.nothing()

  get defaultWalletConfig : WalletConfig {
    {
      node = "http://testnet.axentro.io:3000",
      speed = "FAST"
    }
  }

  fun updateWallet (
    wallet : EncryptedWallet,
    config : Maybe(WalletConfig)
  ) {
    sequence {
      storeWallet(wallet, config)

      raw =
        Storage.Local.get("tako_wallet_" + currentWalletName)

      json =
        Json.parse(raw)
        |> Maybe.toResult("Json parsing error in getWallet")

      encryptedWalletWithConfig =
        decode json as EncryptedWalletWithConfig

      next
        {
          currentWalletConfig = encryptedWalletWithConfig.config,
          encryptedWalletWithConfig = Maybe.just(encryptedWalletWithConfig)
        }
    } catch Object.Error => er {
      next { walletError = "(Object) Error could not update wallet: " + currentWalletName }
    } catch String => er {
      next { walletError = "(String) Error could not update wallet: " + currentWalletName }
    } catch Storage.Error => er {
      next { walletError = "(Storage) Error could not update wallet: " + currentWalletName }
    }
  }

  fun storeWallet (
    wallet : EncryptedWallet,
    config : Maybe(WalletConfig)
  ) : Promise(Never, Void) {
    sequence {
      walletConfig =
        config
        |> Maybe.withDefault(defaultWalletConfig)

      walletWithConfig =
        {
          wallet = wallet,
          config = walletConfig
        }

      encodedWalletWithConfig =
        encode walletWithConfig

      walletJson =
        Json.stringify(encodedWalletWithConfig)

      Storage.Local.set("tako_wallet_" + wallet.name, walletJson)

      Promise.never()
    } catch Storage.Error => er {
      next { walletError = "Error could not store wallet: " + wallet.name }
    }
  }

  fun getWallet (name : String, password : String) : Promise(Never, Void) {
    sequence {
      raw =
        Storage.Local.get("tako_wallet_" + name)

      json =
        Json.parse(raw)
        |> Maybe.toResult("Json parsing error in getWallet")

      encryptedWalletWithConfig =
        decode json as EncryptedWalletWithConfig

      wallet =
        Sushi.Wallet.decryptWallet(encryptedWalletWithConfig.wallet, password)

      next
        {
          currentWallet = Maybe.just(wallet),
          currentWalletName = name,
          currentWalletConfig = encryptedWalletWithConfig.config,
          encryptedWalletWithConfig = Maybe.just(encryptedWalletWithConfig)
        }
    } catch Object.Error => er {
      next { walletError = "(Object) Error could not retrieve wallet: " + name }
    } catch String => er {
      next { walletError = "(String) Error could not retrieve wallet: " + name }
    } catch Storage.Error => er {
      next { walletError = "(Storage) Error could not retrive wallet: " + name }
    } catch Wallet.Error => er {
      next { walletError = "(Wallet) Error could not retrive wallet: " + name }
    }
  }

  fun getSavedWalletOptions : Result(String, Array(String)) {
    `
    (() => {
      try {
        var names = []
        var i;
        for (i = 0; i < 100; i++) {
          var r = window.localStorage.key(i);
          if (r == null) {
            break;
          }

          if (r.startsWith("tako_wallet_")) {
            var parts = r.split("tako_wallet_")
            var name = parts[parts.length - 1]
            names.push(name)
           }
        }
        return #{Result::Ok(`Array.from(names)`)}
      } catch (e) {
        return  #{Result::Err("error retrieving saved wallet names")}
      }
    })()
    `
  }

  fun resetWallet : Promise(Never, Void) {
    next { currentWallet = Maybe.nothing() }
  }
}
