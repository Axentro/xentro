record PrivateSaleRequest {
  call : String,
  action : String,
  payload : String
}

record ReferralRequest {
  code : String  
}

record ReferralResponse {
    referral : String,
    valid : Bool
}

record RatesResponse {
    eth : String using "ETH",
    btc : String using "BTC"
}

record CreateOrder {
  address : String, 
  referral : String,
  amount : String,
  tokenAmount : String using "token_amount",
  paymentMethod : String using "payment_method",
  agree : String,
  publicKey : String using "public_key",
  hash : String,
  signature : String
}

component PurchaseTokens {
  connect WalletStore exposing { currentWallet, currentWalletConfig }
  connect OrderStore exposing { fetchOrders, toHash, signPrivateSale }

  property senderAddress : String

  state sendError : String = ""
  state sendSuccess : String = ""

  state referralCode : String = ""
  state hasValidReferral = false
  state referralValidationComplete = false
  state rates : Maybe(RatesResponse) = Maybe.nothing()
  state selectedPaymentType : String = "Choose"
  state selectedAmount : String = "Choose"
  state selectedAgree : String = "Choose"

  fun componentDidMount : Promise(Never, Void) {
    fetchRates()
  }

  fun onReferralCode (event : Html.Event) {
      next
        {
          referralCode = value
        }
  } where {
    value =
      Dom.getValue(event.target)
  }

  get validateReferralCodeButton : Bool {
    String.isEmpty(referralCode)
  }

    get validatePurchaseButton : Bool {
    selectedAmount == "Choose" || selectedPaymentType == "Choose" || selectedAgree == "Choose" || selectedAgree == "I disagree"
  }

  fun fetchRates() {
    sequence {
      payload = { code = "" }   
      
      requestBody = encode { call = "private_sale", action = "rates", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

        json = 
          Json.parse(response.body)
          |> Maybe.toResult("Json parsing error with rates")

        result =
          decode json as RatesResponse

      if (response.status == 200) {
           next { rates = Maybe.just(result) }
      } else {
        next { sendError = "Could not fetch rates", rates = Maybe.nothing()  } 
      }
    } catch {
        next { sendError = "Could not validate referral code", rates = Maybe.nothing() } 
    }
  } 

   fun postRequestValidateReferral(event : Html.Event) {
    sequence {
      
      payload = { code = referralCode}

      requestBody = encode { call = "private_sale", action= "referral", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

        json =
          Json.parse(response.body)
          |> Maybe.toResult("Json parsing error with referral validation")

        result =
          decode json as ReferralResponse

      if(result.valid){
        next { hasValidReferral = true, referralValidationComplete = true }
      } else {
        next { hasValidReferral = false, referralValidationComplete = true, sendError = "Referral code was invalid!"  } 
      }
    } catch {
        next { sendError = "Could not validate referral code" } 
    }
  } 

     fun postMakeOrder(event : Html.Event) {
    sequence {
      
       hexPrivateKey =
                      currentWallet 
                      |> Maybe.map((w : Wallet) { Axentro.Wallet.getPrivateKeyFromWif(w.wif) |> Result.withDefault("error") })
                      |> Maybe.withDefault("error")
        

      publicKey = currentWallet
                  |> Maybe.map((w : Wallet) { w.publicKey })
                  |> Maybe.withDefault("error")

      totalAmount = 
                   rates
                   |> Maybe.map((r : RatesResponse) { totalToPay(r) } )
                   |> Maybe.withDefault("0")

      data = senderAddress + referralCode + totalAmount + selectedPaymentType + selectedAmount + selectedAgree + publicKey
      hash = toHash(data)
      signature = signPrivateSale(hash, hexPrivateKey)

      payload = {  address = senderAddress, referral = referralCode, tokenAmount = selectedAmount, amount = totalAmount, 
                   paymentMethod = selectedPaymentType, agree = selectedAgree, publicKey = publicKey, hash = hash, signature = signature
      }

      requestBody = encode { call = "private_sale", action = "create_order", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

      if (response.status == 200) {
        sequence {
          next { selectedAmount = "Choose", selectedPaymentType = "Choose", selectedAgree = "Choose" }
          fetchOrders(senderAddress, currentWalletConfig, currentWallet)
        }
      } else {
        next { sendError = "Unable to create order"  } 
      }
    } catch {
        next { sendError = "Unable to create order" } 
    }
  } 

fun onPaymentType (event : Html.Event) {
    next
      {
        selectedPaymentType = Dom.getValue(event.target)
      }
  }

 fun onAgree (event : Html.Event) {
    next
      {
        selectedAgree = Dom.getValue(event.target)
      }
  }

  fun onAmount (event : Html.Event) {
    next
      {
        selectedAmount = Dom.getValue(event.target)
      }
  }

   get paymentOptions : Array(String) {
    ["Choose","ETH","BTC","Alternative"] 
   }

   get agreeOptions : Array(String) {
     ["Choose", "I agree", "I disagree"]
   }

   get amountOptions : Array(String) {
       ["Choose","20","30","50","70","100","200","300","500","1000"]
   }

   fun renderViews : Html {
     rates 
     |> Maybe.map((r : RatesResponse) { renderInnerView(r) })
     |> Maybe.withDefault(noFundRaising)
   }

   get noFundRaising : Html {
     <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Private Fund Raising"
        </h4>

        <div
          class="alert alert-info alert-with-border"
          role="alert">

          <p>"Private fund raising functions are not available at the moment - try again later!"</p>
        </div>
      </div>
    </div>
   }

   fun renderInnerView(currentRates : RatesResponse) : Html {
      if (referralValidationComplete && hasValidReferral) {
        renderPurchaseToken(currentRates)
      } else {
        renderValidateReferral()
      }
   }

  fun render : Html {
      <div>
     <{ renderViews() }>
     <{ renderOrdersForWallet() }>
      </div>
  }

  fun renderOrdersForWallet : Html {
     if (Maybe.isJust(rates)){
       <div>
       <Orders senderAddress={senderAddress}/>
       <AdminOrders senderAddress={senderAddress}/>
       <AdminReferrals senderAddress={senderAddress}/>
       </div>
     } else {
       <div></div>
     }
  }

  fun renderPurchaseToken(currentRates : RatesResponse) : Html {
       <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Private Fund Raising"
        </h4>

         <{ UiHelper.errorAlert(sendError) }>

        <div
          class="alert alert-info alert-with-border"
          role="alert">

          <p>"We are aiming to raise " <strong>"£50,000 GBP"</strong> " and as such the maximum amount of tokens you can buy is set at " <b>"50,000"</b> " costing " <b>"£1"</b> " per token."</p>
          <p>
            "You can purchase tokens using ETH or BTC by filling out the form below. After placing your order by clicking 'Purchase' you will be asked to make a transaction to our wallet address for the specified amount and then enter the transaction id into the form."
          </p>
          <p>"If you wish to pay using more than one transaction then just put a comma separated list of transaction ids into the box."</p>
          <p>"If you wish to pay using an alternative method please select the Alternative option and contact " <span class="btn btn-sm btn-info">"kingsleyh"</span> " in the Official Telegram channel: " <span class="btn btn-sm btn-primary">"https://t.me/axentro"</span> " with the order number to proceed."</p>
          <p>"At any time if you have a query please contact " <span class="btn btn-sm btn-info">"kingsleyh"</span> " in the Official Telegram channel mentioned above."</p>

        </div>

        <div>
          <div class="form-group">
            <div class="col">
              <label for="payment-type">
                "Payment Type"
              </label>

              <select
                onChange={onPaymentType}
                class="form-control"
                id="payment-type">

                <{ UiHelper.selectNameOptions(selectedPaymentType, paymentOptions) }>

              </select>
            </div>
            </div>

          <div class="form-group">
            <div class="col">
              <label for="agree">
                "I Agree to the conditions of the private fund raising"
              </label>

              <div
          class="alert alert-danger alert-with-border"
          role="alert">

          <p>"By selecting "<b>"I agree"</b>" from the select box below, you agree that you are not a citizen of America, China or any other country in which making a purchase is illegal."</p>
          <p>"You may cancel an order within 30 days of the initial order date for a full refund upon return of the purchased tokens."</p>
          <p>"By selecting "<b>"I agree"</b>" you acknowledge that you are making this purchase at your own risk and that the value of your purchase may go up or down and is not intended as an investment of any kind."</p>
         
        </div>

              <select
                onChange={onAgree}
                class="form-control"
                id="agree">

                <{ UiHelper.selectNameOptions(selectedAgree, agreeOptions) }>

              </select>
            </div>
            </div>


           <div class="form-group">
              <div class="col">
              <label for="amount-to-buy">
                "Amount of AXNT to buy"
              </label>

              <select
                onChange={onAmount}
                class="form-control"
                id="amount-to-buy">

                <{ UiHelper.selectNameOptions(selectedAmount, amountOptions) }>

              </select>
            </div>
          </div>

          <{ amountToPayTable(currentRates) }>

          <button
            class="btn btn-secondary"
            onClick={postMakeOrder}
            disabled={validatePurchaseButton}
            type="submit">

            "Purchase"

          </button>
        </div>
      </div>
    </div>
  }

  fun rateForPaymentType(currentRates : RatesResponse) : String {
      try {
          if (selectedPaymentType == "ETH"){
              currentRates.eth  
          } else if (selectedPaymentType == "BTC") {
              currentRates.btc
          } else {
           "N/A"
          }
       }
  }

  fun totalToPay(currentRates : RatesResponse) : String {
     try {
          if (selectedPaymentType == "ETH"){
              try {
              ((Number.fromString(selectedAmount) |> Maybe.withDefault(0)) * (Number.fromString(currentRates.eth) |> Maybe.withDefault(0))) |> Number.toFixed(8)  
              }
          } else if (selectedPaymentType == "BTC") {
             ((Number.fromString(selectedAmount) |> Maybe.withDefault(0)) * (Number.fromString(currentRates.btc) |> Maybe.withDefault(0))) |> Number.toFixed(8)    
          } else {
           ((Number.fromString(selectedAmount) |> Maybe.withDefault(0)) * 1) |> Number.toFixed(2)  
          }
       }  
  }
  

  fun amountToPayTable(currentRates : RatesResponse) : Html {
         <div class="table-responsive">
        <table
          id="amount-to-pay-table"
          class="table table-striped table-bordered">

          <thead>
            <tr>
               <th>
                  "Amount to buy"
                </th>
                <th>
                "Cost per token"
                </th>   
                <th>
                  "Payment method"
                </th>
                <th>
                "Rate"
                </th>
                <th>
                "Total"
                </th>
            </tr>
          </thead>

          <tbody>
           <td><{ selectedAmount }></td>
           <td>"£1 GBP"</td>
           <td><{ selectedPaymentType }></td>
           <td><{ rateForPaymentType(currentRates) }></td>
           <td><{ totalToPay(currentRates) }></td>
          </tbody>

        </table>
      </div>
  }

  fun renderValidateReferral : Html {
       <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Private Fund Raising"
        </h4>

         <{ UiHelper.errorAlert(sendError) }>

        <div
          class="alert alert-info alert-with-border"
          role="alert">

          <p>"You must be invited to take part in this private fundraising and have recieved a referral code."</p>
        </div>

        <div>
          <div class="form-row mb-3">
            <div class="col-md-8 mb-6">
              <label for="referral-code">
                "Referral Code"
              </label>

              <input
                type="text"
                class="form-control"
                id="referral-code"
                onInput={onReferralCode}
                value={referralCode}
                placeholder="Referral code"/>
            </div>
          </div>

        
          <button
            class="btn btn-secondary"
            onClick={postRequestValidateReferral}
            disabled={validateReferralCodeButton}
            type="submit">

            "Verify Code"

          </button>
        </div>
      </div>
    </div>
  }

 
}
