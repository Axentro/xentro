component Tokens {
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
      navigation=[<Navigation current="tokens"/>]
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
    <div class="container col-md-12">
          <div class="row">
          <div class="col-md-3">
            <WalletBalances
              address={walletInfo.address}
              readable={walletInfo.readable}
              tokens={walletInfo.tokens}/>
              <News/>
          </div>

          <div class="col">

             <{ UiHelper.errorAlert(sendError) }>
             <{ UiHelper.successAlert(sendSuccess) }>

             <CreateCustomTokenTransaction
              senderAddress={walletInfo.address}
              tokens={walletInfo.tokens} />
          </div>

        </div>

         <div class="row">
         <div class="col-md-3"></div>
      
           <div class="col">
               <UpdateCustomTokenTransaction
               senderAddress={walletInfo.address}
               tokens={walletInfo.tokens}
               myTokens={unlockedTokens}/>
             </div>

          <div class="col">
               <LockCustomTokenTransaction
               senderAddress={walletInfo.address}
               tokens={walletInfo.tokens}
               myTokens={unlockedTokens}/>
             </div>

          </div>
          </div>
       

  
  } where {
    unlockedTokens = walletInfo.myTokens |> Array.select((t : Token){ !t.isLocked })
  }
}
