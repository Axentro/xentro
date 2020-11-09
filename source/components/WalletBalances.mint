component WalletBalances {
  property tokens : Array(Token) = []
  property address : String = ""
  property readable : Array(String) = []

  fun render : Html {
    <div class="card">
      <div class="card-body">
        <div class="d-flex justify-content-between mb-3">
          <div>
            <p class="text-muted">
              "Wallet Balances"
            </p>

            <h2 class="font-weight-bold">
              <{ getAxeAmount(tokens) }>

              <span class="small">
                " AXNT"
              </span>
            </h2>
          </div>
        </div>

        <{ getWalletAddress(address, readable) }>
      </div>

      <{ tokenTable(tokens) }>
    </div>
  }

  fun getAxeAmount (tokens : Array(Token)) : String {
    tokens
    |> Array.find((token : Token) : Bool { token.name == "AXNT" })
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
    |> Maybe.withDefault(
      <div class="small">
        <{ address }>
      </div>)
  }

  fun isMineStyle(isMine : Bool) : Html {
      if (isMine) {
        <span class="text-primary ti-user"/>
      } else {
        <span/>
      }
  }

    fun isLockedStyle(isLocked : Bool) : Html {
      if (isLocked) {
        <span class="text-danger ti-lock"/>
      } else {
         <span class="text-success ti-key"/>
      }
  }

  fun tokenTable (tokens : Array(Token)) : Html {
    if (Array.isEmpty(tokensWithoutAxe)) {
      <span/>
    } else {
      <div class="table-responsive">
        <table class="table table-striped mb-0">
          <thead>
            <tr>
              <th>
                "Token"
              </th>

              <th></th>

              <th>
                "Amount"
              </th>
            </tr>
          </thead>

          <tbody>
            for (token of tokensWithoutAxe) {
              <tr>
                <td>
                  <{ token.name }> 
                </td>
                <td>
                <{isLockedStyle(token.isMine)}> <{isMineStyle(token.isMine)}>
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
    tokensWithoutAxe =
      tokens
      |> Array.reject(
        (token : Token) : Bool {
          (token.name
          |> String.toLowerCase()) == "axnt"
        })
  }
}
