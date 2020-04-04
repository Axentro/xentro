component Layout {
  connect Application exposing { dataError }
  property content : Array(Html) = []
  property navigation : Array(Html) = []

  fun componentDidMount : Promise(Never, Void) {
    `
    (() => {
      window.requestAnimationFrame(function () {     
		var preLoder = $("#preloader");
		preLoder.delay(700).fadeOut(500);
      });
    })()
    `
  }

  get preloader : Html {
    <div
      id="preloader"
      class="preloader">

      <div class="preloader-icon"/>

    </div>
  }

  fun render : Html {
    <div>
      <{ preloader }>

      <div class="layout-wrapper">
        <div class="header d-print-none">
          <div class="header-left">
            <div class="header-logo">
              <a href="index.html">
                <img
                  class="logo"
                  src="/assets/media/image/logo.png"
                  alt="logo"/>

                <img
                  class="logo-light"
                  src="/assets/media/image/logo-light.png"
                  alt="light logo"/>
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
