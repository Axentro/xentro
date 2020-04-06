component Receive {
  connect Application exposing { walletInfo }

  fun render : Html {
    <Layout
      navigation=[<Navigation current="receive"/>]
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

   fun copyAddress(event : Html.Event) : Void {
    `
    (() => {
      var copyText = document.getElementById("my-address");
      copyText.select();
      document.execCommand("copy");
    })()
    `
  }

  fun generateQrCode(address : String) : String {
    `new QRious({value: #{address}, size: 250}).toDataURL()`
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
          <{ "Receive tokens" }>
        </h4>

        <div class="alert alert-info" role="alert">
        <p>"Give the sender your wallet address when they want to send you tokens. You can either provide the address below or scan the QR code."</p>
        <p>"If you have a human readable address you can also provide that. "</p></div>

        <{ domainAddress(domain) }>

        <div id="my-address-qrcode">
         <img src={generateQrCode(walletInfo.address)}/>
        </div>
        <br/>
        <{"Your address is: "}>
        <br/>
        <input id="my-address" size="80" value={walletInfo.address}/>
        <br/>
        <br/>
        <button class="btn btn-outline-info" onClick={copyAddress}><{"Copy address"}></button>
      </div>
    </div>
          </div>
        </div>
      </div>
    </div>
  } where {
    domain = Array.firstWithDefault("",walletInfo.readable)
  }

  fun domainAddress(domain : String) {
    if(String.isEmpty(domain)){
      <span/>
    } else {
   <div>
   <br/>  
   <p>"Your human readable address is:"
   <div class="ml-2 badge bg-dribbble">
          <{ domain }>
        </div>
        </p> 
        </div>
        
    }
  }
}
