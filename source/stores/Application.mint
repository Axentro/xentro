store Application {
  state page : String = ""
  state logs : Array(String) = ["Websocket provider demo..."]
  state walletInfo : Maybe(WalletInfo) = Maybe.nothing()
  state dataError : String = ""
  state webSocket : Maybe(WebSocket) = Maybe.nothing()
  state connectionStatus : ConnectionStatus = ConnectionStatus::Initial

  fun setConnectionstatus (status : ConnectionStatus) : Promise(Never, Void) {
    next { connectionStatus = status }
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
}
