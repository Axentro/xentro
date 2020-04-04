component Dashboard {
  connect Application exposing { logs, walletInfo, dataError }

  fun componentDidMount : Promise(Never, Void) {
    `
    (() => {
     window.requestAnimationFrame(function () {

       
		var preLoder = $("#preloader");
		preLoder.delay(700).fadeOut(500);

    
   
    });
    })()
    `
  }

  fun render : Html {
    <div>
      <div
        id="preloader"
        class="preloader">

        <div class="preloader-icon"/>

      </div>

      <div class="layout-wrapper">
        <div class="header d-print-none">
          <div class="header-left">
            <div class="navigation-toggler">
              <a
                href="#"
                data-action="navigation-toggler">

                <i data-feather="menu"/>

              </a>
            </div>

            <div class="header-logo">
              <a href="index.html">
                <img
                  class="logo"
                  src="/assets/media/image/logo.png"
                  alt="logo"/>

                <img
                  class="logo-light"
                  src="/assets/media/image/logo-light.png"
                  alt="light logo"/>
              </a>
            </div>
          </div>

          <div class="header-body">
            <div class="header-body-left">
              <ul class="navbar-nav">
                <li class="nav-item">
                  <a
                    class="nav-link"
                    href="#">

                    "Send"

                  </a>
                </li>

                <li class="nav-item">
                  <a
                    class="nav-link"
                    href="#">

                    "Receive"

                  </a>
                </li>

                <li class="nav-item">
                  <a
                    class="nav-link"
                    href="#">

                    "Transactions"

                  </a>
                </li>

                <li class="nav-item">
                  <a
                    class="nav-link"
                    href="#">

                    "Tools"

                  </a>
                </li>
              </ul>
            </div>

            <div class="header-body-right">
              <ul class="navbar-nav">
                <li class="nav-item">
                  <a
                    class="nav-link"
                    href="#">

                    "Logout"

                  </a>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <div class="content-wrapper">
          <div class="content-body">
            <div class="content">
              <div class="page-header"/>
              <{ dataError }>
              <{ renderPageContent }>
            </div>
          </div>
        </div>
      </div>
    </div>
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

  fun getSushiAmount (tokens : Array(Token)) : String {
    tokens
    |> Array.find((token : Token) : Bool { token.name == "SUSHI" })
    |> Maybe.map((token : Token) : String { token.amount })
    |> Maybe.withDefault("0")
  }

  fun getWalletAddress (address : String, readable : Array(String)) : Html {
    Array.first(readable)
    |> Maybe.map(
      (domain : String) : Html {
        <div class="badge bg-dribbble">
          <{ domain }>
        </div>
      })
    |> Maybe.withDefault(<div class="small">
      <{ address }>
    </div>)
  }

  fun pageContent (walletInfo : WalletInfo) : Html {
    <div class="row">
      <div class="col-md-12">
        <div/>

        <div class="row">
          <div class="col-md-3">
            <div class="card">
              <div class="card-body">
                <div class="d-flex justify-content-between mb-3">
                  <div>
                    <p class="text-muted">
                      "Wallet Balances"
                    </p>

                    <h2 class="font-weight-bold">
                      <{ getSushiAmount(walletInfo.tokens) }>

                      <span class="small">
                        " SUSHI"
                      </span>
                    </h2>
                  </div>
                </div>

                <{ getWalletAddress(walletInfo.address, walletInfo.readable) }>
              </div>

             <{ tokenTable(walletInfo.tokens)}>
            </div>
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

  fun tokenTable(tokens : Array(Token)) : Html {
      if(Array.isEmpty(tokensWithoutSushi)){
          <span/>
      } else {
       <div class="table-responsive">
                <table class="table table-striped mb-0">
                  <thead>
                    <tr>
                      <th>
                        "Token"
                      </th>

                      <th>
                        "Amount"
                      </th>
                    </tr>
                  </thead>

                  <tbody>
                    for (token of tokens) {
                      <tr>
                        <td>
                          <{ token.name }>
                        </td>

                        <td>
                          <{ token.amount }>
                        </td>
                      </tr>
                    }
                  </tbody>
                </table>
              </div>
      }
  } where {
      tokensWithoutSushi = tokens |> Array.reject((token : Token) : Bool { token.name == "SUSHI"})
  }
}
