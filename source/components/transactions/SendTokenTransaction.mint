component SendTokenTransaction {
  connect WalletStore exposing { currentWallet, currentWalletConfig }

  connect TransactionStore exposing {
    sendError,
    sendSuccess,
    resetStatus,
    resetErrorSuccess,
    reset,
    senderPrivatePublic,
    createTokenTransaction,
    sendTransaction,
    domainDoesNotExist,
    setDomainError,
    domainError
  }

  property senderAddress : String
  property tokens : Array(Token)

  state recipientAddress : String = ""
  state amount : String = ""
  state amountError : String = ""
  state recipientError : String = ""
  state fee : String = "0.0001"
  state selectedToken : String = "AXE"
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
            recipientAddress = "",
            amount = "",
            selectedToken = "AXE",
            speed = currentWalletConfig.speed,
            confirmCheck = false
          }

        resetStatus(false)
      }
    } else {
      Promise.never()
    }
  }

  fun onDomain (event : Html.Event) {
    if (NodeHelper.isDomain(value)) {
      domainDoesNotExist(currentWalletConfig.node, value)
    } else {
      Promise.never()
    }
  } where {
    value =
      Dom.getValue(event.target)
  }

  fun onToken (event : Html.Event) {
    next
      {
        selectedToken = Dom.getValue(event.target),
        amount = "",
        amountError = ""
      }
  }

  fun onCheck (event : Html.Event) {
    next { confirmCheck = !confirmCheck }
  } where {
    value =
      Dom.getValue(event.target)
  }

  fun onRecipientAddress (event : Html.Event) {
    sequence {
      next
        {
          recipientAddress = value,
          recipientError = validateRecipientAddress(value)
        }

      setDomainError("")
    }
  } where {
    value =
      Dom.getValue(event.target)
  }

  fun onAmount (event : Html.Event) : Promise(Never, Void) {
    next
      {
        amount = value,
        amountError = validateAmount(value, tokens, selectedToken, fee)
      }
  } where {
    value =
      Dom.getValue(event.target)
  }

  fun validateRecipientAddress (value : String) : String {
    if (NodeHelper.isDomain(value)) {
      ""
    } else {
      try {
        valid =
          Axentro.Wallet.isValidAddress(value)

        if (valid) {
          ""
        } else {
          "The address you supplied is invalid!"
        }
      } catch {
        "The address you supplied is invalid!"
      }
    }
  }

  fun validateAmount (
    value : String,
    tokens : Array(Token),
    currentToken : String,
    currentFee : String
  ) : String {
    try {
      amt =
        Number.fromString(value)
        |> Maybe.withDefault(0)

      fee =
        Number.fromString(currentFee)
        |> Maybe.withDefault(0.0001)

      tokenAmount =
        tokens
        |> Array.find(
          (token : Token) : Bool {
            String.toLowerCase(token.name) == String.toLowerCase(currentToken)
          })
        |> Maybe.map((token : Token) : Maybe(Number) { Number.fromString(token.amount) })
        |> Maybe.flatten
        |> Maybe.withDefault(0)

      if (amt + fee > tokenAmount) {
        "You don't have enough " + currentToken + " to send"
      } else if (amt <= 0) {
        "you must supply an amount greater than 0"
      } else {
        ""
      }
    }
  }

  get tokenOptions : Array(String) {
    Array.insertAt("AXE", 0, otherTokens)
  } where {
    otherTokens =
      tokens
      |> Array.map(.name)
      |> Array.reject((name : String) { String.toLowerCase(name) == "axe" })
  }

  get sendButtonState : Bool {
    String.isEmpty(recipientAddress) || String.isEmpty(amount) || !String.isEmpty(amountError) || !String.isEmpty(recipientError) || !confirmCheck || !String.isEmpty(domainError)
  }

  fun render : Html {
    <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Send tokens"
        </h4>

        <{ UiHelper.errorAlert(sendError) }>
        <{ UiHelper.successAlert(sendSuccess) }>

        <div>
          <div class="form-row mb-3">
            <div class="col-md-8 mb-6">
              <label for="recipient-address">
                "Recipient address (or human readable address)"
              </label>

              <input
                type="text"
                class="form-control"
                id="recipient-address"
                placeholder="Recipient address"
                onInput={onRecipientAddress}
                onBlur={onDomain}
                value={recipientAddress}/>

              <div class="mt-2">
                <{ UiHelper.errorAlert(recipientError) }>
              </div>

              <div class="mt-1">
                <{ UiHelper.errorAlert(domainError) }>
              </div>
            </div>
          </div>

          <div class="form-row">
            <div class="col-md-3 mb-3">
              <label for="amount-to-send">
                "Amount to send"
              </label>

              <input
                type="text"
                class="form-control"
                id="amount-to-send"
                placeholder="Amount to send"
                onInput={onAmount}
                value={amount}/>

              <div class="mt-2">
                <{ UiHelper.errorAlert(amountError) }>
              </div>
            </div>

            <div class="col-md-3 mb-3">
              <label for="token-to-send">
                "Token"
              </label>

              <select
                onChange={onToken}
                class="form-control"
                id="token">

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
                id="customCheck2"/>

              <label
                class="custom-control-label"
                for="customCheck2">

                "I've double checked everything is correct!"

              </label>
            </div>
          </div>

          <button
            onClick={(e : Html.Event) { sendTransaction(e, currentWalletConfig.node, recipientAddress, senderWif, transaction) }}
            class="btn btn-secondary"
            disabled={sendButtonState}
            type="submit">

            "Send"

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
      createTokenTransaction(senderAddress, senderPublicKey, amount, fee, recipientAddress, selectedToken, speed)
  }
}
