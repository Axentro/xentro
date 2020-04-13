store WalletStore {
  state walletError : String = ""
  state currentWallet : Maybe(Wallet) = Maybe.nothing()

  fun storeWallet (wallet : EncryptedWallet) : Promise(Never, Void) {
    sequence {
      encodedWallet =
        encode wallet

      walletJson =
        Json.stringify(encodedWallet)

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

      encryptedWallet =
        decode json as EncryptedWallet

      wallet =
        Sushi.Wallet.decryptWallet(encryptedWallet, password)

      next { currentWallet = Maybe.just(wallet) }
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
