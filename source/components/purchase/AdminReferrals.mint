record AllReferralsResponse {
  id : String,
  address : String
  }

record CreateReferralRequest {
  referral : String,
  address : String,
  publicKey : String using "public_key",
  hash : String,
  signature : String
}

component AdminReferrals {
  connect WalletStore exposing { currentWallet, currentWalletConfig }
  connect OrderStore exposing { toHash, signPrivateSale}

  property senderAddress : String
  state selectedAddress : String = "Choose"
  state updateError : String = ""
  state allOrders : Array(AllOrdersResponse) = []
  state allReferrals : Array(AllReferralsResponse) = []

  fun componentDidMount : Promise(Never, Void) {
      sequence {
        fetchAllOrders(senderAddress, currentWalletConfig, currentWallet)
        fetchAllReferrals(senderAddress, currentWalletConfig, currentWallet)
      }
  }
  
   fun onAddress (event : Html.Event) {
    next
      {
        selectedAddress = Dom.getValue(event.target), updateError = ""
      }
  
}

fun fetchAllOrders(senderAddress : String, currentWalletConfig : WalletConfig, currentWallet : Maybe(Wallet)) {
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
      
      requestBody = encode { call = "private_sale", action = "all_orders", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

        json = 
          Json.parse(response.body)
          |> Maybe.toResult("Json parsing error with fetch orders")

        result =
          decode json as Array(AllOrdersResponse)

      if (response.status == 200) {
           next { allOrders = result }
      } else {
       Promise.never()
      }
    } catch {
       Promise.never()
    }
  } 

fun fetchAllReferrals(senderAddress : String, currentWalletConfig : WalletConfig, currentWallet : Maybe(Wallet)) {
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
      
      requestBody = encode { call = "private_sale", action = "all_referrals", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

        json = 
          Json.parse(response.body)
          |> Maybe.toResult("Json parsing error with fetch all referrals")

        result =
          decode json as Array(AllReferralsResponse)

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

  fun renderReferralRow(referral : AllReferralsResponse) : Html {
       <tr>
      <td>
        <{ referral.id }>
      </td>
       <td>
        <{ referral.address }>
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
          "Admin Referrals"
        </h4>

     <{ UiHelper.errorAlert(updateError) }>


     <{ referralTable }>
    
     <{ createReferral() }>
      
      </div>
    </div>
  }

  fun createReferral() : Html {
    if (Array.isEmpty(allReferrals)) {
       <div></div>
    } else {
       renderCreateReferral()
    }
  } 

    get validateCreateReferralButton : Bool {
    selectedAddress == "Choose"
    }

 fun postCreateReferral(event : Html.Event) {
    sequence {
      
       hexPrivateKey =
                      currentWallet 
                      |> Maybe.map((w : Wallet) { Axentro.Wallet.getPrivateKeyFromWif(w.wif) |> Result.withDefault("error") })
                      |> Maybe.withDefault("error")
        

      publicKey = currentWallet
                  |> Maybe.map((w : Wallet) { w.publicKey })
                  |> Maybe.withDefault("error")


      data = senderAddress + selectedAddress + publicKey
      hash = toHash(data)
      signature = signPrivateSale(hash, hexPrivateKey)

      payload = {  referral = selectedAddress, address = senderAddress, publicKey = publicKey, hash = hash, signature = signature }

      requestBody = encode { call = "private_sale", action = "create_referral", payload = payload }
      baseUrl = currentWalletConfig.node

      response =
        Http.post(baseUrl + "/rpc")
        |> Http.jsonBody(requestBody)
        |> Http.send()

      if (response.status == 200) {
        sequence {
          next { selectedAddress = "Choose" }
          fetchAllOrders(senderAddress, currentWalletConfig, currentWallet)
          fetchAllReferrals(senderAddress, currentWalletConfig, currentWallet)
        }
      } else {
        next { updateError = "Unable to update order" }
      }
    } catch {
        next { updateError = "Unable to update order" }
    }
  } 

  fun renderCreateReferral() : Html {
    if (Array.isEmpty(allReferrals)){
       <div></div>
    } else {
      <div>
      <hr/>

<div class="form-group">
              <div class="col">
              <label for="referral-id-update">
                "Create referral for address"
              </label>

              <select
                onChange={onAddress}
                class="form-control"
                id="referral-id-update">

                <{ UiHelper.selectNameOptions(selectedAddress, addressOptions) }>

              </select>
            </div>
            </div>

        
          <button
            class="btn btn-secondary"
            onClick={postCreateReferral}
            disabled={validateCreateReferralButton}
            type="submit">

            "Create"

          </button>
          <br/><br/>
         
      </div>
    }
  } where {
      orderAddresses = allOrders
                 |> Array.map((o : AllOrdersResponse) { o.address })
      referralAddresses = allReferrals 
                 |> Array.map((r : AllReferralsResponse) { r.address })           
      addresses = orderAddresses
                 |> Array.reject((a : String) { Array.contains(a, referralAddresses) })           
      addressOptions = Array.append(["Choose"], addresses)           
  }

 
}
