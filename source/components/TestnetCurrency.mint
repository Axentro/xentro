record TestCurrencyRequest {
  call : String,
  address : String
}

component TestnetCurrency {
  state sendError : String = ""
  state sendSuccess : String = ""

  connect WalletStore exposing { currentWallet, currentWalletConfig }

  fun render {
    currentWallet
    |> Maybe.map(view)
    |> Maybe.withDefault(<div/>)
  }

  fun isTestNet (address : String) {
    `#{address}.startsWith('VD')`
  }

  fun view (wallet : Wallet) {
    if (isTestNet(wallet.address)) {
      <div class="card">
        <div class="card-body">
          <div class="d-flex justify-content-between mb-3">
            <div>
              <{ UiHelper.errorAlert(sendError) }>
              <{ UiHelper.successAlert(sendSuccess) }>

              <p class="text-muted">
                "Testnet Currency"
              </p>

              <button
                class="btn btn-success"
                onClick={(e : Html.Event) { getCurrency(wallet.address) }}>

                "Get 500 AXNT"

              </button>
            </div>
          </div>
        </div>
      </div>
    } else {
      <div/>
    }
  }

  fun getCurrency (address : String) {
    postRequestTestCurrency(address)
  }

  fun postRequestTestCurrency (address : String) {
    sequence {
      requestBody =
        encode {
          call = "currency",
          address = address
        }

      baseUrl =
        currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

      if (response.status == 200) {
        next { sendSuccess = "Success, 500 AXNT should arrive momentarily!" }
      } else {
        next { sendError = "Oh no! There's no AXNT for you" }
      }
    } catch {
      next { sendError = "Oh no! There's no AXNT for you" }
    }
  }
}
