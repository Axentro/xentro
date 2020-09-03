component Dashboard {
  connect Application exposing { setDataError, setWalletInfo, walletInfo, webSocket, updateWebSocketConnect, shouldWebSocketConnect }
  connect WalletStore exposing { currentWallet, currentWalletConfig }

  fun componentDidMount : Promise(Never, Void) {
    if (Maybe.isNothing(currentWallet)) {
      Window.navigate("/login")
    } else {
      Promise.never()
    }
  }

  fun render : Html {
    <Layout
      navigation=[<Navigation/>]
      content=[renderPageContent]/>
  }

  get renderPageContent : Html {
    try {
      walletInfo
      |> Maybe.map(pageContent)
      |> Maybe.withDefault(loadingPageContent)
    }
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

            <Miner/>
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
