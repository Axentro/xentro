record AllCompleteReferralsResponse {
  id : String,
  address : String,
  bonus : String
  }

component AdminCompleteReferrals {
  connect WalletStore exposing { currentWallet, currentWalletConfig }
  connect OrderStore exposing { toHash, signPrivateSale}

  property senderAddress : String
  state allReferrals : Array(AllCompleteReferralsResponse) = []

  fun componentDidMount : Promise(Never, Void) {
        fetchAllCompleteReferrals(senderAddress, currentWalletConfig, currentWallet)
  }
 

fun fetchAllCompleteReferrals(senderAddress : String, currentWalletConfig : WalletConfig, currentWallet : Maybe(Wallet)) {
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
      
      requestBody = encode { call = "private_sale", action = "all_completed_referrals", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

        json = 
          Json.parse(response.body)
          |> Maybe.toResult("Json parsing error with fetch all completed referrals")

        result =
          decode json as Array(AllCompleteReferralsResponse)

      if (response.status == 200) {
           next { allReferrals = result }
      } else {
       Promise.never()
      }
    } catch {
       Promise.never()
    }
  } 

  fun render : Html {
      if (Array.isEmpty(allReferrals)) {
        <div></div>
      } else {
        renderReferrals()
      }
  }

  fun renderReferralRow(referral : AllCompleteReferralsResponse) : Html {
       <tr>
      <td>
        <{ referral.id }>
      </td>
       <td>
        <{ referral.address }>
      </td>
        <td>
        <{ referral.bonus }>
      </td>
     </tr>
  }

  get referralTable : Html {
         <div class="table-responsive">
        <table
          id="order-table"
          class="table table-striped table-bordered">

          <thead>
            <tr>
               <th>
                  "Referral Code"
                </th>
                 <th>
                  "Address"
                </th> 
                <th>
                  "Bonus"
                </th>   
            </tr>
          </thead>

          <tbody>
              for (referral of allReferrals) {
              renderReferralRow(referral)
            }
          </tbody>

        </table>
      </div>
  }

  fun renderReferrals : Html {
       <div class="card border-dark mb-3">
      <div class="card-body">
        <h4 class="card-title">
          "Admin Complete Referrals"
        </h4>

     <{ referralTable }>
    
     
      </div>
    </div>
  }


}
