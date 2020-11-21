component PrivateSale {
  connect Application exposing { walletInfo }
  connect WalletStore exposing { currentWallet }
  connect TransactionStore exposing { sendError, sendSuccess }

  fun componentDidMount : Promise(Never, Void) {
    if (Maybe.isNothing(currentWallet)) {
      Window.navigate("/login")
    } else {
      Promise.never()
    }
  }

  fun render : Html {
    <Layout
      navigation=[<Navigation current="purchase"/>]
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
    <div class="container-fluid">
          <div class="row">
          <div class="col-md-3">
            <WalletBalances
              address={walletInfo.address}
              readable={walletInfo.readable}
              tokens={walletInfo.tokens}/>
              <Referrals senderAddress={walletInfo.address}/>
          </div>

          <div class="col-md-9">

             <{ UiHelper.errorAlert(sendError) }>
             <{ UiHelper.successAlert(sendSuccess) }>

             <PurchaseTokens
              senderAddress={walletInfo.address}/>
          
                  
          </div>

        </div>

       
          </div>
       

  
  } 
}
