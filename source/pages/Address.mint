component Address {
  connect Application exposing { walletInfo }
  connect WalletStore exposing { currentWallet }

  fun componentDidMount : Promise(Never, Void) {
    if (Maybe.isNothing(currentWallet)) {
      Window.navigate("/login")
    } else {
      Promise.never()
    }
  }

  fun render : Html {
    <Layout
      topNavigation=[<TopNavigation/>]
      leftNavigation=[<LeftNavigation current="address"/>]
      content=[renderPageContent]/>
  }

  get renderPageContent : Html {
    walletInfo
    |> Maybe.map(pageContent)
    |> Maybe.withDefault(loadingPageContent)
  }

  get loadingPageContent : Html {
    <div>"LOADING"</div>
  }

  fun pageContent (walletInfo : WalletInfo) : Html {
    <div class="row">
      <div class="col-md-12">
        <div/>

        <div class="row">
          <div class="col-md-3">
          <AccountStatus/>
            <WalletBalances
              address={walletInfo.address}
              readable={walletInfo.readable}
              tokens={walletInfo.tokens}/>

            <News/>
          </div>

          <div class="col-md-9">
            <BuyAddressTransaction
              senderAddress={walletInfo.address}
              readable={walletInfo.readable}
              tokens={walletInfo.tokens}/>
          </div>
        </div>
      </div>
    </div>
  }
}
