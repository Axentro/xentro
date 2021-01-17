store NavigationStore {
  state isOpen : Bool = false

 fun setNav(value : Bool) : Promise(Never, Void) {
    next { isOpen = value }
  }

}