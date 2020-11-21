record ReferralsResponse {
    numberOfPendingReferrals : String using "number_pending_referrals",
    numberOfCompletedReferrals : String using "number_completed_referrals",
    tokensPending : String using "tokens_pending",
    tokensEarned : String using "tokens_earned"
}


component Referrals {

  connect WalletStore exposing { currentWallet, currentWalletConfig }
  connect OrderStore exposing { fetchOrders, toHash, signPrivateSale }

  property senderAddress : String

  state referrals : Maybe(ReferralsResponse) = Maybe.nothing()

  fun componentDidMount : Promise(Never, Void) {
      fetchReferrals(senderAddress, currentWalletConfig, currentWallet)
  }

  fun fetchReferrals(senderAddress : String, currentWalletConfig : WalletConfig, currentWallet : Maybe(Wallet)) : Promise(Never, Void) {
    sequence {


       hexPrivateKey =
                      currentWallet 
                      |> Maybe.map((w : Wallet) { Axentro.Wallet.getPrivateKeyFromWif(w.wif) |> Result.withDefault("error") })
                      |> Maybe.withDefault("error")
        

      publicKey = currentWallet
                  |> Maybe.map((w : Wallet) { w.publicKey })
                  |> Maybe.withDefault("error")


      data = senderAddress + publicKey
      hash = toHash(data)
      signature = signPrivateSale(hash, hexPrivateKey)

      payload = { address = senderAddress, publicKey = publicKey, hash = hash, signature = signature}   
      
      requestBody = encode { call = "private_sale", action = "address_referrals", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

        json = 
          Json.parse(response.body)
          |> Maybe.toResult("Json parsing error with fetch referrals")

        result =
          decode json as ReferralsResponse

      if (response.status == 200) {
           next { referrals = Maybe.just(result) }
      } else {
        Promise.never()
      }
    } catch {
         Promise.never()
    }
  } 

  fun render : Html {
      referrals 
      |> Maybe.map(renderView)
      |> Maybe.withDefault(<div></div>)
  }

  fun renderView(referrals : ReferralsResponse) : Html {
   <div class="card">
      <div class="card-body" style="height:150px;">
       <div>
         

         <div>

         <p>
            <strong>"Referrals"</strong>
         </p>
         
          <p>
           <ul>
             <li>"Number of referrals pending: " <b>"1"</b></li>
             <li>"Number of referrals completed: " <b>"3"</b></li>
             <li>"Tokens pending: " <b>"5"</b></li>
             <li>"Tokens earned: " <b>"12"</b></li>
           </ul>   
         </p>

         </div>
       
        </div>
    </div>
    </div> 
  }

}