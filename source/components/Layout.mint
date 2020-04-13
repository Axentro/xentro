component Layout {
  connect Application exposing { dataError }
  
  property content : Array(Html) = []
  property navigation : Array(Html) = []

  fun componentDidMount : Promise(Never, Void) {
    LayoutHelper.preLoad()
  }

  fun render : Html {
    <div>
      <div class="layout-wrapper">
        <div class="header d-print-none">
          <div class="header-left">
            <div class="header-logo">
              <a href="/dashboard">
                <img
                  class="logo"
                  src="/assets/media/image/sushichain_logo_light.png"
                  alt="logo"/>
              </a>
            </div>
          </div>

          <{ navigation }>
        </div>

        <div class="content-wrapper">
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
