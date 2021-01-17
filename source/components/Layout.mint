component Layout {
  connect Application exposing { dataError }
  connect NavigationStore exposing { isOpen, setNav}
  property content : Array(Html) = []
  property topNavigation : Array(Html) = []
  property leftNavigation : Array(Html) = []

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      LayoutHelper.preLoad()
      LayoutHelper.feedback()
    }
  }

  fun toggleNav(event : Html.Event) : Promise(Never, Void) {
    if (isOpen){
      setNav(false)
    } else {
      setNav(true)
    }
  }

  fun render : Html {
    <div>
      <div class="layout-wrapper">
        <div class="header d-print-none">
          <div class="header-left">

          <div class="navigation-toggler">
                <a  onClick={toggleNav} data-action="navigation-toggler">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="feather feather-menu"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
                </a>
            </div>

            <div class="header-logo">
              <a href="/dashboard">
                <img
                  class="logo"
                  src="/assets/media/image/axentro-logo-h.svg"
                  width="150"
                  alt="logo"/>

                <span style="margin-left:6px;padding-top:12px;">
                  <Version/>
                </span>
              </a>
            </div>
          </div>

          <{ topNavigation }>
        </div>

        <div class="content-wrapper">
           <{ leftNavigation }>
          <div class="content-body">
            <div class="content">
              <div class="page-header"/>
              <{ dataError }>
              <{ content }>
            </div>
          </div>
        </div>
      </div>
    </div>
  }
}
