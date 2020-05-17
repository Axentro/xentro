component ImportExportWallet {

  connect WalletStore exposing { currentWallet, storeWallet, getWallet, currentWalletConfig }
  connect Application exposing { updateWebSocketConnect } 

  state importErrorMessage : String = ""
  state exportSuccessMessage : String = ""
  state exportErrorMessage : String = ""
  state importWalletJson : String = ""
  state importWalletName : String = ""
  state importWalletPassword : String = ""
  state exportWalletJson : String = ""

  fun onImportWallet (event : Html.Event) {
    next { importWalletJson = Dom.getValue(event.target) }
  }

  fun onImportWalletName (event : Html.Event) {
    next { importWalletName = Dom.getValue(event.target) }
  }

 fun onImportWalletPassword (event : Html.Event) {
    next { importWalletPassword = Dom.getValue(event.target) }
  }
  
  get importButtonState : Bool {
    String.isEmpty(importWalletJson) || String.isEmpty(importWalletName) || String.isEmpty(importWalletPassword)
  }

  fun onExportWallet (event : Html.Event) {
    next { exportWalletJson = Dom.getValue(event.target) }
  }

  fun importWallet (event : Html.Event) {
    sequence {
      json =
        Json.parse(importWalletJson)
        |> Maybe.toResult("Json parsing error in import wallet")

      wallet =
        decode json as Wallet

      encryptedWallet =
        Sushi.Wallet.encryptWallet(wallet, importWalletName, importWalletPassword)

      storeWallet(encryptedWallet, Maybe.nothing())

      getWallet(importWalletName, importWalletPassword)
      
      updateWebSocketConnect(currentWalletConfig.node)
      Window.navigate("/dashboard") 


    } catch {
      next { importErrorMessage = "Oops an unexpected error occured" }
    }
  }

  fun exportWallet (event : Html.Event) {
    sequence {
      encodedWallet =
        encode currentWallet

      walletJson =
        Json.stringify(encodedWallet)

      next { exportWalletJson = walletJson }
    }
  }

  fun clearExportWallet (event : Html.Event) {
    next { exportWalletJson = "" }
  }

  fun render {
    <div>
      <div class="card border-dark mb-3">
        <div class="card-body">
          <h4 class="card-title">
            "Import Wallet"
          </h4>

          <{ UiHelper.errorAlert(importErrorMessage) }>

          <div class="form-row">
            <div class="col-md-3 mb-3">
              <input
                type="text"
                class="form-control"
                id="import-wallet-name"
                placeholder="Import wallet name"
                onInput={onImportWalletName}
                value={importWalletName}/>
            </div>
          </div>

           <div class="form-row">
            <div class="col-md-3 mb-3">
              <input
                type="text"
                class="form-control"
                id="import-wallet-password"
                placeholder="Import wallet password"
                onInput={onImportWalletPassword}
                value={importWalletPassword}/>
            </div>
          </div>

          <div class="form-row">
            <div class="col-md-8 mb-6">
              <textarea
                type="text"
                class="form-control"
                id="import-wallet"
                placeholder="Non encrypted wallet json"
                onInput={onImportWallet}
                value={importWalletJson}/>
            </div>
          </div>

          <div class="mt-3">
            <button
              onClick={importWallet}
              class="btn btn-primary"
              disabled={importButtonState}
              type="submit">

              "Import wallet"

            </button>
          </div>
        </div>
      </div>

      <div class="card border-dark mb-3">
        <div class="card-body">
          <h4 class="card-title">
            "Export Wallet (decrypted)"
          </h4>

          <{ UiHelper.errorAlert(importErrorMessage) }>

          <div class="form-row">
            <div class="col-md-8 mb-6">
              <textarea
                type="text"
                class="form-control"
                id="export-wallet"
                value={exportWalletJson}/>
            </div>
          </div>

          <div class="mt-3">
            <button
              onClick={exportWallet}
              class="btn btn-primary"
              type="submit">

              "Export wallet"

            </button>

             <span class="ml-2">
             <button
              onClick={clearExportWallet}
              class="btn btn-outline-primary"
              type="submit">

              "Clear"

            </button>
          </span>
          </div>
        </div>
      </div>
    </div>
  }
}
