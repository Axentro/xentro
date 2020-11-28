component CreateCustomTokenTransaction {
  connect WalletStore exposing { currentWallet, currentWalletConfig }

  connect TransactionStore exposing {
    sendError,
    sendSuccess,
    resetStatus,
    resetErrorSuccess,
    reset,
    senderPrivatePublic,
    createCustomTokenTransaction,
    sendTransaction,
    tokenExists,
    setTokenError,
    tokenError
  }

  property senderAddress : String
  property tokens : Array(Token)

  state name : String = ""
  state nameError : String = ""
  state amount : String = ""
  state amountError : String = ""
  state feeError : String = ""
  state speed : String = currentWalletConfig.speed
  state confirmCheck : Bool = false

  fun componentDidMount : Promise(Never, Void) {
    resetErrorSuccess()
  }

  fun componentDidUpdate : Promise(Never, Void) {
    if (reset) {
      sequence {
        next
          {
            name = "",
            amount = "",
            speed = currentWalletConfig.speed,
            confirmCheck = false,
            nameError = ""
          }

        resetStatus(false)
      }
    } else {
      Promise.never()
    }
  }

  fun onName (event : Html.Event) {
    sequence {
      next
        {
          name = value,
          nameError = validateName(value),
          feeError = validateFeeAmount
        }

      setTokenError("")
    }
  } where {
    value =
      Dom.getValue(event.target)
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

  fun onToken (event : Html.Event) {
    tokenExists(currentWalletConfig.node, value)
  } where {
    value =
      Dom.getValue(event.target)
  }

  fun validateAmount (value : String) : String {
    if ((Number.fromString(value)
        |> Maybe.withDefault(0)) <= 0) {
      "Please supply a number greater than 0"
    } else {
      ""
    }
  }

  fun validateName (value : String) : String {
    try {
      regexResult =
        Regexp.create("^[A-Z0-9]{1,20}")
        |> Regexp.match(value)

      allCaps =
        String.toUpperCase(value) == value

      if (regexResult && allCaps) {
        ""
      } else {
        "Please comply with the rules for a name listed above"
      }
    }
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
    String.isEmpty(name) || !confirmCheck || !String.isEmpty(nameError) || !String.isEmpty(tokenError) || !String.isEmpty(feeError)
  }

  get rules : Html {
    <div/>
  }

  fun processSendTransaction (
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
    <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Create Custom Token"
        </h4>

        <div
          class="alert alert-info alert-with-border"
          role="alert">

          <p>"Please select a token name within the following restrictions:"</p>

          <hr/>

          <p class="mb-0">
            <ul class="ml-3">
              <li>"- Can only contain uppercase letters or numbers"</li>

              <li>"- Length must be between 1 and 20 characters"</li>
            </ul>
          </p>

        </div>

        <div>
          <div class="form-row mb-3">
            <div class="col-md-8 mb-6">
              <label for="recipient-address">
                "Name of custom token"
              </label>

              <input
                type="text"
                class="form-control"
                id="address-name"
                placeholder="Token Name"
                onBlur={onToken}
                onInput={onName}
                value={name}/>

              <div class="mt-1">
                <{ UiHelper.errorAlert(nameError) }>
              </div>

              <div class="mt-1">
                <{ UiHelper.errorAlert(tokenError) }>
              </div>

              <div class="mt-1">
                <{ UiHelper.errorAlert(feeError) }>
              </div>
            </div>
          </div>

          <div class="form-row">
            <div class="col-md-3 mb-3">
              <label for="amount-to-create">
                "Amount to create"
              </label>

              <input
                type="text"
                class="form-control"
                id="amount-to-create"
                placeholder="Amount to create"
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
                id="customCheck2"/>

              <label
                class="custom-control-label"
                for="customCheck2">

                "I've double checked everything is correct!"

              </label>
            </div>
          </div>

          <button
            onClick={(e : Html.Event) { processSendTransaction(e, currentWalletConfig.node, senderAddress, senderWif, transaction) }}
            class="btn btn-secondary"
            disabled={buyButtonState}
            type="submit">

            "Create Token"

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
      createCustomTokenTransaction(senderAddress, senderPublicKey, name, amount, speed)
  }
}
