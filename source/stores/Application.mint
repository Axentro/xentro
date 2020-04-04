store Application {
  state page : String = ""
  state logs : Array(String) = ["Websocket provider demo..."]
  state walletInfo : Maybe(WalletInfo) = Maybe.nothing()
  state dataError : String = ""

  fun setPage (page : String) : Promise(Never, Void) {
    sequence {
      Http.abortAll()
      next { page = page }
    }
  }

  fun setLog(message : String) : Promise(Never, Void) {
    next { logs = Array.push(message, logs) }
  }

 fun setWalletInfo(data : WalletInfo) : Promise(Never, Void) {
   next { walletInfo = Maybe.just(data)}
 }

fun setDataError(message : String) : Promise(Never, Void) {
  next { dataError = message }
}

}
