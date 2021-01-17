component LeftNavigation {

  connect NavigationStore exposing { isOpen, setNav }

  property current : String = "home"

    fun activeStyle (item : String) : String {
    if (item == current) {
      "btn-info"
    } else {
      "btn-outline-info"
    }
  }

  get openClass : String {
      if (isOpen) {
        "open"
      } else {
        ""
      }
  }

  fun go(e : Html.Event, location : String) : Promise(Never, Void) {
      sequence {
        Html.Event.preventDefault(e)
        setNav(false)
        Window.navigate(location)
      }
  }

  fun render : Html {
      <div class={"navigation " + openClass}>
            <div class="navigation-menu-tab">
                <ul>
                    <li>
                       <a
              class={"mr-2 btn " + activeStyle("home")}
              href="/dashboard"
              onClick={(e : Html.Event) { go(e, "dashboard") }}
              >

              "Home"

            </a>
                    </li>
                    <li>
                       <a
              class={"mr-2 btn " + activeStyle("send")}
              href="/send"
              onClick={(e : Html.Event) { go(e, "send") }}>
              
              "Send"

            </a>
                    </li>
                    <li>
                       <a
              class={"mr-2 btn " + activeStyle("receive")}
              href="/receive"
              onClick={(e : Html.Event) { go(e, "receive") }}
              >

              "Receive"

            </a>

           
                    </li>
                    <li>
                       <a
              class={"mr-2 btn " + activeStyle("address")}
              href="/address"
              onClick={(e : Html.Event) { go(e, "address") }}
              >

              "Address"

            </a>

           
                    </li>
                    <li>
                       <a
             class={"mr-2 btn " + activeStyle("tokens")}
              href="/tokens"
              onClick={(e : Html.Event) { go(e, "tokens") }}
              >

              "Tokens"

            </a>

          
                    </li>
                    <li>
                       <a
              class={"mr-2 btn " + activeStyle("transactions")}
              href="/transactions"
              onClick={(e : Html.Event) { go(e, "transactions") }}
              >

              "Rejections"

            </a>

          
                    </li>
                    <li>
                       <a
              class={"mr-2 btn " + activeStyle("tools")}
              href="/tools"
              onClick={(e : Html.Event) { go(e, "tools") }}
              >

              "Tools"

            </a>

           
                    </li>
                    <li>
                       <a
              class={"mr-2 btn " + activeStyle("settings")}
              href="/settings"
              onClick={(e : Html.Event) { go(e, "settings") }}
              >

              "Settings"

            </a>

           
                    </li>
            
             
                    
                </ul>
            </div>
          </div>


          
  }

}