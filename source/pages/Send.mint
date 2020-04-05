component Send {
  connect Application exposing { walletInfo }

  fun render : Html {
    <Layout
      navigation=[<Navigation current="send"/>]
      content=[renderPageContent]/>
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

  fun pageContent (walletInfo : WalletInfo) : Html {
    <div class="row">
      <div class="col-md-12">
        <div/>

        <div class="row">
          <div class="col-md-3">
            <WalletBalances
              address={walletInfo.address}
              readable={walletInfo.readable}
              tokens={walletInfo.tokens}/>
          </div>

          <div class="col-md-9">
          <div class="card border-dark mb-3">
  

      <div class="card-body">
        <h4 class="card-title">
          <{ "Send tokens" }>
        </h4>

       <div>
  <div class="form-row mb-3">
    <div class="col-md-8 mb-6">
      <label for="recipient-address">"Recipient address (or human readable address)"</label>
      <input type="text" class="form-control" id="recipient-address" placeholder="Recipient address" value="Mark" />
      <div class="valid-feedback">
        "Looks good!"
      </div>
    </div>
    
    </div>


<div class="form-row">
    <div class="col-md-4 mb-3">
      <label for="amount-to-send">"Amount to send"</label>
      <input type="text" class="form-control" id="amount-to-send" placeholder="Amount to send" value="Otto" />
      <div class="valid-feedback">
        "Looks good!"
      </div>
    </div>
    <div class="col-md-4 mb-3">
      <label for="token-to-send">"Token"</label>


        <input type="text" class="form-control" id="token-to-send" placeholder="SUSHI" />
        <div class="invalid-feedback">
          "Please choose a username."
        </div>
 
    </div>
  </div>
  
  <div class="form-group">
    <div class="form-check">
      <input class="form-check-input" type="checkbox" value="" id="invalidCheck" />
      <label class="form-check-label" for="invalidCheck">
        "Agree to terms and conditions"
      </label>
      <div class="invalid-feedback">
        "You must agree before submitting."
      </div>
    </div>
  </div>
  <button class="btn btn-secondary" type="submit">"Send"</button>
</div>

       
      </div>
    </div>
          </div>
        </div>
      </div>
    </div>
  } 
}
