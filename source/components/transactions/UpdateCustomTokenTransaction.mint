component UpdateCustomTokenTransaction {
  connect WalletStore exposing { currentWallet, currentWalletConfig }

  connect TransactionStore exposing {
    sendError,
    sendSuccess,
    resetStatus,
    resetErrorSuccess,
    reset,
    senderPrivatePublic,
    updateCustomTokenTransaction,
    sendTransaction,
    tokenError
  }

  property senderAddress : String
  property tokens : Array(Token)
  property myTokens : Array(Token)
  state selectedToken : String = firstCustomToken(myTokens)

  state amount : String = ""
  state amountError : String = ""
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
            amount = "",
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

   fun onAmount (event : Html.Event) : Promise(Never, Void) {
    next
      {
        amount = value,
        amountError = validateAmount(value)
      }
  } where {
    value =
      Dom.getValue(event.target)
  }


  fun validateAmount(value : String) : String {
      if((Number.fromString(value) |> Maybe.withDefault(0)) <= 0) {
       "Please supply a number greater than 0"
      } else {
          ""
      }
  }

  fun onToken (event : Html.Event) {
    next
      {
        selectedToken = Dom.getValue(event.target),
        amount = "",
        amountError = ""
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
    !confirmCheck || String.isEmpty(amount) || !String.isEmpty(feeError)
  }

  get rules : Html {
    <div/>
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
          "Update Custom Token"
        </h4>

        <div>
          <div class="form-row mb-3">
           <div class="col-md-3 mb-3">
              <label for="token-to-update">
                "Token"
              </label>

              <select
                onChange={onToken}
                class="form-control"
                id="token-to-update">

                <{ UiHelper.selectNameOptions(selectedToken, tokenOptions) }>

              </select>
            </div>
        
            <div class="col-md-3 mb-3">
              <label for="amount-to-update">
                "Update amount"
              </label>

              <input
                type="text"
                class="form-control"
                id="amount-to-update"
                placeholder="Update amount"
                onInput={onAmount}
                value={amount}/>

              <div class="mt-2">
                <{ UiHelper.errorAlert(amountError) }>
              </div>
            </div>
          </div>

          <div class="form-group">
            <div class="custom-control custom-checkbox custom-checkbox-success">
              <input
                type="checkbox"
                onChange={onCheck}
                class="custom-control-input"
                checked={confirmCheck}
                id="customCheckUpdate"/>

              <label
                class="custom-control-label"
                for="customCheckUpdate">

                "I've double checked everything is correct!"

              </label>
            </div>
          </div>

          <button
            onClick={(e : Html.Event) { processSendTransaction(e, currentWalletConfig.node, senderAddress, senderWif, transaction) }}
            class="btn btn-secondary"
            disabled={buyButtonState}
            type="submit">

            "Update Token"

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
      updateCustomTokenTransaction(senderAddress, senderPublicKey, selectedToken, amount, speed)
  }
}
