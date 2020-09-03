store Application {
  state page : String = ""
  state logs : Array(String) = ["Websocket provider demo..."]
  state walletInfo : Maybe(WalletInfo) = Maybe.nothing()
  state dataError : String = ""
  state webSocket : Maybe(WebSocket) = Maybe.nothing()
  state minerWebSocket : Maybe(WebSocket) = Maybe.nothing()
  state connectionStatus : ConnectionStatus = ConnectionStatus::Initial
  state minerConnectionStatus : ConnectionStatus = ConnectionStatus::Initial
  state shouldWebSocketConnect : Bool = false
  state webSocketUrl : String = NodeHelper.webSocketUrl("http://testnet.sushichain.io:3000")

  state shouldMinerWebSocketConnect : Bool = false
  state minerWebSocketUrl : String = NodeHelper.minerWebSocketUrl("http://testnet.sushichain.io:3000")

  fun updateMinerWebSocketConnect (nodeUrl : String) {
    sequence {
     next
        {
          minerWebSocketUrl = NodeHelper.minerWebSocketUrl(nodeUrl),
          shouldMinerWebSocketConnect = false,
          minerConnectionStatus = ConnectionStatus::Initial
        }
      
      next { shouldMinerWebSocketConnect = canMinerConnect() }
    }
  }

  fun canMinerConnect() : Bool {
    numberProcesses > 0
  }

  state numberProcesses : Number = 0
 
  fun setNumberProcesses (value : Number) {
    sequence {
      next { numberProcesses = value }
      Timer.timeout(2000, updateMinerWebSocketConnect(minerWebSocketUrl))
    }
  }
 
  fun getNumberProcesses {
      numberProcesses
  }

  fun initMinerSlider {
    `
    (() => {
      requestAnimationFrame(function(){
      
        $("#number-processes").ionRangeSlider({
          min: 0,
          max: 100,
          from: 0,
          to: 100,
          skin: "round",
          grid: true,
          onFinish: function(data){
            #{setNumberProcesses(`data.from`)}
          }
        });
     
        var range = $("#number-processes").data("ionRangeSlider")
        range.update({from: #{getNumberProcesses()}})
      })
    })()
    `
  }


  fun updateWebSocketConnect (nodeUrl : String) {
    sequence {
      next
        {
          webSocketUrl = NodeHelper.webSocketUrl(nodeUrl),
          shouldWebSocketConnect = false
        }

      next { shouldWebSocketConnect = true }
    }
  }

  fun setConnectionstatus (status : ConnectionStatus) : Promise(Never, Void) {
    next { connectionStatus = status }
  }

   fun setMinerConnectionstatus (status : ConnectionStatus) : Promise(Never, Void) {
    next { minerConnectionStatus = status }
  }

  fun setPage (page : String) : Promise(Never, Void) {
    sequence {
      Http.abortAll()
      next { page = page }
    }
  }

  fun setLog (message : String) : Promise(Never, Void) {
    next { logs = Array.push(message, logs) }
  }

  fun setWalletInfo (data : WalletInfo) : Promise(Never, Void) {
    sequence {
      next { walletInfo = Maybe.just(data) }
    }
  }

  fun setDataError (message : String) : Promise(Never, Void) {
    next { dataError = message }
  }

  fun resetWalletInfo : Promise(Never, Void) {
    next { walletInfo = Maybe.nothing() }
  }

  fun setWebSocket (s : WebSocket) : Promise(Never, Void) {
    next { webSocket = Maybe.just(s) }
  }

  fun resetWebSocket : Promise(Never, Void) {
    next { webSocket = Maybe.nothing() }
  }

   fun setMinerWebSocket (s : WebSocket) : Promise(Never, Void) {
    next { minerWebSocket = Maybe.just(s) }
  }

  fun resetMinerWebSocket : Promise(Never, Void) {
    next { minerWebSocket = Maybe.nothing() }
  }
}
