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

  fun feedback {
    `
    (() => {
      window.requestAnimationFrame(function () { 
        var buttons = document.getElementsByClassName("feedback-btn").length;    
        if(buttons === 0){
		      $.feedback({
            endpoint: "https://app.loopinput.com/5f5c9ab7e70b0600173624d3/comments",
            initButtonText: "Give Feedback"
          });
        }
      });
    })()
    `
  }
}
