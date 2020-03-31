store Application {
  state page : String = ""

  fun setPage (page : String) : Promise(Never, Void) {
    sequence {
      Http.abortAll()
      next { page = page }
    }
  }
}
