component ImportExportWallet {
  connect WalletStore exposing {
    currentWallet,
    storeWallet,
    getWallet,
    walletError,
    resetWalletError,
    currentWalletConfig,
    encryptedWalletWithConfig
  }

  connect Application exposing { updateWebSocketConnect, updateMinerWebSocketConnect }

  state importErrorMessage : String = ""
  state exportSuccessMessage : String = ""
  state exportErrorMessage : String = ""

  state importDecryptedWalletJson : String = ""
  state importDecryptedWalletName : String = ""
  state importDecryptedWalletPassword : String = ""
  state importEncryptedWalletJson : String = ""
  state importEncryptedWalletPassword : String = ""

  state exportWalletJson : String = ""
  state selectedExport : String = "Encrypted"
  state selectedImport : String = "Encrypted"

  fun componentDidMount : Promise(Never, Void) {
    next { importErrorMessage = "", exportErrorMessage = "" }
  }

  fun onImportDecryptedWallet (event : Html.Event) {
    next
      {
        importDecryptedWalletJson = Dom.getValue(event.target),
        importErrorMessage = ""
      }
  }

  fun onImportDecryptedWalletName (event : Html.Event) {
    next
      {
        importDecryptedWalletName = Dom.getValue(event.target),
        importErrorMessage = ""
      }
  }

  fun onImportDecryptedWalletPassword (event : Html.Event) {
    next
      {
        importDecryptedWalletPassword = Dom.getValue(event.target),
        importErrorMessage = ""
      }
  }

  get importDecryptedButtonState : Bool {
    String.isEmpty(importDecryptedWalletJson) || String.isEmpty(importDecryptedWalletName) || String.isEmpty(importDecryptedWalletPassword)
  }

  fun onImportEncryptedWallet (event : Html.Event) {
    next
      {
        importEncryptedWalletJson = Dom.getValue(event.target),
        importErrorMessage = ""
      }
  }

  fun onImportEncryptedWalletPassword (event : Html.Event) {
    next
      {
        importEncryptedWalletPassword = Dom.getValue(event.target),
        importErrorMessage = ""
      }
  }

  get importEncryptedButtonState : Bool {
    String.isEmpty(importEncryptedWalletJson) || String.isEmpty(importEncryptedWalletPassword)
  }

  fun onExportWallet (event : Html.Event) {
    next { exportWalletJson = Dom.getValue(event.target) }
  }

  fun onExportKind (event : Html.Event) {
    next
      {
        selectedExport = Dom.getValue(event.target),
        exportErrorMessage = ""
      }
  }

  fun onImportKind (event : Html.Event) {
    next
      {
        selectedImport = Dom.getValue(event.target),
        importErrorMessage = ""
      }
  }

  fun importDecryptedWallet (event : Html.Event) {
    sequence {
      json =
        Json.parse(importDecryptedWalletJson)
        |> Maybe.toResult("Json parsing error in import wallet")

      wallet =
        decode json as Wallet

      encryptedWallet =
        Axentro.Wallet.encryptWallet(wallet, importDecryptedWalletName, importDecryptedWalletPassword)

      storeWallet(encryptedWallet, Maybe.nothing())

      getWallet(importDecryptedWalletName, importDecryptedWalletPassword)
      updateWebSocketConnect(currentWalletConfig.node)
      updateMinerWebSocketConnect(currentWalletConfig.node)
      Window.navigate("/dashboard")
    } catch {
      next { importErrorMessage = "Oops an unexpected error occured" }
    }
  }

  fun importEncryptedWallet (event : Html.Event) {
    sequence {
      json =
        Json.parse(importEncryptedWalletJson)
        |> Maybe.toResult("Json parsing error in import encrypted wallet")

      encryptedWallet =
        decode json as EncryptedWallet

      storeWallet(encryptedWallet, Maybe.nothing())

      resetWalletError()
      getWallet(encryptedWallet.name, importEncryptedWalletPassword)

      if (String.isEmpty(walletError)) {
        sequence {
          updateWebSocketConnect(currentWalletConfig.node)
          updateMinerWebSocketConnect(currentWalletConfig.node)
          Window.navigate("/dashboard")
        }
      } else {
        Promise.never()
      }
    } catch {
      next { importErrorMessage = "Oops an unexpected error occured" }
    }
  }

  fun exportDecryptedWallet : Promise(Never, Void) {
    sequence {
      encodedWallet =
        encode currentWallet

      walletJson =
        Json.stringify(encodedWallet)
        |> String.replace("publicKey", "public_key")

      next { exportWalletJson = walletJson }
    }
  }

  fun convertAndSetEncryptedWalletExport (ew : EncryptedWallet) : Promise(Never, Void) {
    sequence {
      encodedWallet =
        encode ew

      walletJson =
        Json.stringify(encodedWallet)

      next { exportWalletJson = walletJson }
    }
  }

  fun exportEncryptedWallet : Promise(Never, Void) {
    if (encryptedWalletWithConfig
        |> Maybe.isJust) {
      sequence {
        encryptedWalletWithConfig
        |> Maybe.map((ew : EncryptedWalletWithConfig) { convertAndSetEncryptedWalletExport(ew.wallet) })

        Promise.never()
      }
    } else {
      next { exportErrorMessage = "Could not export encrypted wallet - use the decrypted export instead" }
    }
  }

  fun exportWallet (event : Html.Event) {
    if (selectedExport == "Encrypted") {
      exportEncryptedWallet()
    } else {
      exportDecryptedWallet()
    }
  }

  fun clearExportWallet (event : Html.Event) {
    next { exportWalletJson = "" }
  }

  get exportOptions : Array(String) {
    ["Encrypted", "Decrypted"]
  }

  fun renderImportDecrypted : Html {
    <div>
      <div class="form-row">
        <div class="col-md-3 mb-3">
          <input
            type="text"
            class="form-control"
            id="import-dec-wallet-name"
            placeholder="Import wallet name"
            onInput={onImportDecryptedWalletName}
            value={importDecryptedWalletName}/>
        </div>
      </div>

      <div class="form-row">
        <div class="col-md-3 mb-3">
          <input
            type="text"
            class="form-control"
            id="import-dec-wallet-password"
            placeholder="Import wallet password"
            onInput={onImportDecryptedWalletPassword}
            value={importDecryptedWalletPassword}/>
        </div>
      </div>

      <div class="form-row">
        <div class="col-md-8 mb-6">
          <textarea
            type="text"
            class="form-control"
            id="import-dec-wallet"
            placeholder="Non encrypted wallet json"
            onInput={onImportDecryptedWallet}
            value={importDecryptedWalletJson}/>
        </div>
      </div>

      <div class="mt-3">
        <button
          onClick={importDecryptedWallet}
          class="btn btn-primary"
          disabled={importDecryptedButtonState}
          type="submit">

          "Import decrypted wallet"

        </button>
      </div>
    </div>
  }

  fun renderImportEncrypted : Html {
    <div>
      <div class="form-row">
        <div class="col-md-3 mb-3">
          <input
            type="text"
            class="form-control"
            id="import-enc-wallet-password"
            placeholder="Existing password"
            onInput={onImportEncryptedWalletPassword}
            value={importEncryptedWalletPassword}/>
        </div>
      </div>

      <div class="form-row">
        <div class="col-md-8 mb-6">
          <textarea
            type="text"
            class="form-control"
            id="import-enc-wallet"
            placeholder="Encrypted wallet json"
            onInput={onImportEncryptedWallet}
            value={importEncryptedWalletJson}/>
        </div>
      </div>

      <div class="mt-3">
        <button
          onClick={importEncryptedWallet}
          class="btn btn-primary"
          disabled={importEncryptedButtonState}
          type="submit">

          "Import encrypted wallet"

        </button>
      </div>
    </div>
  }

  fun renderImportWallet : Html {
    if (selectedImport == "Encrypted") {
      renderImportEncrypted()
    } else {
      renderImportDecrypted()
    }
  }

  fun render {
    <div>
      <div class="card border-dark mb-3">
        <div class="card-body">
          <h4 class="card-title">
            "Import Wallet"
          </h4>

          <{ UiHelper.errorAlert(importErrorMessage) }>
          <{ UiHelper.errorAlert(walletError) }>

          <div class="form-row">
            <div class="col-md-3 mb-3">
              <select
                onChange={onImportKind}
                class="form-control"
                id="import-kind">

                <{ UiHelper.selectNameOptions(selectedImport, exportOptions) }>

              </select>
            </div>
          </div>

          <{ renderImportWallet() }>
        </div>
      </div>

      <div class="card border-dark mb-3">
        <div class="card-body">
          <h4 class="card-title">
            "Export Wallet"
          </h4>

          <{ UiHelper.errorAlert(exportErrorMessage) }>

          <div class="form-row">
            <div class="col-md-3 mb-3">
              <select
                onChange={onExportKind}
                class="form-control"
                id="export-kind">

                <{ UiHelper.selectNameOptions(selectedExport, exportOptions) }>

              </select>
            </div>
          </div>

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
