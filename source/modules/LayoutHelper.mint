module LayoutHelper {
  fun preLoad {
    `
    (() => {
      window.requestAnimationFrame(function () {     
		var preLoder = $("#preloader");
		preLoder.delay(700).fadeOut(500);
      });
    })()
    `
  }
}
