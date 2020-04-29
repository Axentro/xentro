component Dashboard {
  connect Application exposing { setDataError, setWalletInfo, walletInfo, webSocket }
  connect WalletStore exposing { currentWallet }

  fun componentDidMount : Promise(Never, Void) {
    if (Maybe.isNothing(currentWallet)) {
      Window.navigate("/login")
    } else {
      sequence {
        currentWallet
        |> Maybe.map(
          (cw : Wallet) {
            webSocket
            |> Maybe.map((s : WebSocket) { sendMessage(s, cw) })
          })

        Promise.never()
      }
    }
  }

  fun componentDidUpdate : Promise(Never, Void) {
    sequence {
      Debug.log("component updated")
      Promise.never()
    }
  }

  fun sendMessage (socket : WebSocket, wallet : Wallet) : Promise(Never, Void) {
    sequence {
      `console.log('sending message ...')`

      message =
        { address = wallet.address }

      json =
        encode message

      WebSocket.send(Json.stringify(json), socket)
    }
  }

  fun render : Html {
    <Layout
      navigation=[<Navigation/>]
      content=[renderPageContent]/>
  }

  get renderPageContent : Html {
    walletInfo
    |> Maybe.map(pageContent)
    |> Maybe.withDefault(loadingPageContent)
  }

  get loadingPageContent : Html {
    <div>
      "LOADING"
    </div>
  }

  fun pageContent (walletInfo : WalletInfo) : Html {
    <div class="row">
      <div class="col-md-12">
        <div/>

        <div class="row">
          <div class="col-md-3">
            <WalletBalances
              address={walletInfo.address}
              readable={walletInfo.readable}
              tokens={walletInfo.tokens}/>
          </div>

          <div class="col-md-9">
            <div class="card">
              <div class="card-body">
                <div>
                  <h6 class="card-title">
                    "Recent Transactions"
                  </h6>
                </div>

                <div class="row">
                  <div class="col-md-12">
                    <RecentTransactionsTable rows={walletInfo.recentTransactions}/>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  }
}
