component ImportExportWallet {
  state importErrorMessage : String = ""
  state exportSuccessMessage : String = ""
  state exportErrorMessage : String = ""
  state importWalletJson : String = ""
  state importWalletName : String = ""
  state exportWalletJson : String = ""

  fun onImportWallet (event : Html.Event) {
    next { importWalletJson = Dom.getValue(event.target) }
  }

  fun onImportWalletName (event : Html.Event) {
    next { importWalletName = Dom.getValue(event.target) }
  }

  get importButtonState : Bool {
    String.isEmpty(importWalletJson) || String.isEmpty(importWalletName)
  }

  fun onExportWallet (event : Html.Event) {
    next { exportWalletJson = Dom.getValue(event.target) }
  }

  fun importWallet (event : Html.Event) {
    Promise.never()
  }

  fun exportWallet (event : Html.Event) {
    Promise.never()
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
              class="btn btn-secondary"
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
              class="btn btn-secondary"
              type="submit">

              "Export wallet"

            </button>
          </div>
        </div>
      </div>
    </div>
  }
}
