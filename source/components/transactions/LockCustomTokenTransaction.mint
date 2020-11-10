component LockCustomTokenTransaction {
  connect WalletStore exposing { currentWallet, currentWalletConfig }

  connect TransactionStore exposing {
    sendError,
    sendSuccess,
    resetStatus,
    resetErrorSuccess,
    reset,
    senderPrivatePublic,
    lockCustomTokenTransaction,
    sendTransaction,
    tokenError
  }

  property senderAddress : String
  property tokens : Array(Token)
  property myTokens : Array(Token)
  state selectedToken : String = firstCustomToken(myTokens)

  state feeError : String = ""
  state speed : String = currentWalletConfig.speed
  state confirmCheck : Bool = false

  fun firstCustomToken(tokens : Array(Token)) : String {
    tokens |> Array.map((t : Token){ t.name }) |> Array.firstWithDefault("AXNT")
  }

  fun componentDidMount : Promise(Never, Void) {
    resetErrorSuccess()
  }

  fun componentDidUpdate : Promise(Never, Void) {
    if (reset) {
      sequence {
        next
          {
            selectedToken = firstCustomToken(myTokens),
            speed = currentWalletConfig.speed,
            confirmCheck = false,
          }

        resetStatus(false)
      }
    } else {
      Promise.never()
    }
  }

  fun onToken (event : Html.Event) {
    next
      {
        selectedToken = Dom.getValue(event.target),
        feeError = validateFeeAmount
      }
  }

 get tokenOptions : Array(String) {
      myTokens
      |> Array.map(.name)
      |> Array.reject((name : String) { String.toLowerCase(name) == "axnt" })
  }

  fun onCheck (event : Html.Event) {
    next { confirmCheck = !confirmCheck }
  } where {
    value =
      Dom.getValue(event.target)
  }

  get validateFeeAmount : String {
    try {
      tokenAmount =
        tokens
        |> Array.find(
          (token : Token) : Bool {
            String.toLowerCase(token.name) == String.toLowerCase("axnt")
          })
        |> Maybe.map((token : Token) : Maybe(Number) { Number.fromString(token.amount) })
        |> Maybe.flatten
        |> Maybe.withDefault(0)

      if (0.0001 > tokenAmount) {
        "You don't have enough AXNT to pay the transaction fee of 0.0001"
      } else {
        ""
      }
    }
  }

  get buyButtonState : Bool {
    !confirmCheck || !String.isEmpty(feeError)
  }

  fun processSendTransaction(
    event : Html.Event,
    baseUrl : String,
    recipientAddress : String,
    senderWif : String,
    transaction : Transaction
   ) {
     sequence {
      next { confirmCheck = false }
      sendTransaction(event, baseUrl, recipientAddress, senderWif, transaction)
     }
  }

  fun render : Html {
      if (Array.isEmpty(myTokens)){
       <div/>
      } else {
          renderView()
      }
  }

  fun renderView : Html {
    <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Lock Custom Token"
        </h4>

        <{ UiHelper.errorAlert(feeError) }>
        
        <div>
          <div class="form-row mb-3">
           <div class="col-md-3 mb-3">
              <label for="token-to-lock">
                "Token"
              </label>

              <select
                onChange={onToken}
                class="form-control"
                id="token-to-lock">

                <{ UiHelper.selectNameOptions(selectedToken, tokenOptions) }>

              </select>

            </div>
          </div>

          <div class="form-group">
            <div class="custom-control custom-checkbox custom-checkbox-success">
              <input
                type="checkbox"
                onChange={onCheck}
                class="custom-control-input"
                checked={confirmCheck}
                id="customCheckLock"/>

              <label
                class="custom-control-label"
                for="customCheckLock">

                "I've double checked everything is correct!"

              </label>
            </div>
          </div>

          <button
            onClick={(e : Html.Event) { processSendTransaction(e, currentWalletConfig.node, senderAddress, senderWif, transaction) }}
            class="btn btn-secondary"
            disabled={buyButtonState}
            type="submit">

            "Lock Token"

          </button>
        </div>
      </div>
    </div>
  } where {
    senderInfo =
      senderPrivatePublic(currentWallet)

    senderPublicKey =
      senderInfo.publicKey

    senderWif =
      senderInfo.wif

    transaction =
      lockCustomTokenTransaction(senderAddress, senderPublicKey, selectedToken, speed)
  }
}
