component Dashboard {

 fun componentDidMount : Promise(Never, Void) {
        `
    (() => {
     window.requestAnimationFrame(function () {

       
		var preLoder = $("#preloader");
		preLoder.delay(700).fadeOut(500);

         $('#recent-transactions').DataTable();
   
    });
    })()
    `
  }

  fun render : Html {
    <div>


<div id="preloader" class="preloader">
    <div class="preloader-icon"></div>
</div>






<div class="layout-wrapper">

  
    <div class="header d-print-none">

        <div class="header-left">
            <div class="navigation-toggler">
                <a href="#" data-action="navigation-toggler">
                    <i data-feather="menu"></i>
                </a>
            </div>
            <div class="header-logo">
                <a href="index.html">
                    <img class="logo" src="/assets/media/image/logo.png" alt="logo"/>
                    <img class="logo-light" src="/assets/media/image/logo-light.png" alt="light logo"/>
                </a>
            </div>
        </div>

        <div class="header-body">
            <div class="header-body-left">
             <ul class="navbar-nav">
            <li class="nav-item">
              <a class="nav-link" href="#">"Send"</a>
            </li>
             <li class="nav-item">
              <a class="nav-link" href="#">"Receive"</a>
            </li>
              <li class="nav-item">
              <a class="nav-link" href="#">"Transactions"</a>
            </li>
              <li class="nav-item">
              <a class="nav-link" href="#">"Tools"</a>
            </li>
             
            </ul>    
            </div>
            <div class="header-body-right">    
            <ul class="navbar-nav">
                <li class="nav-item">
              <a class="nav-link" href="#">"Logout"</a>
            </li>
            </ul>
           
            </div>
        </div>

    </div>
 

    <div class="content-wrapper">

       
      
      

        <div class="content-body">

            <div class="content">

                
    <div class="page-header">
   
    </div>

    <div class="row">
        <div class="col-md-12">

            <div class="row">
                <div class="col-md-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-3">
                                <div>
                                    <p class="text-muted">"Wallet Balances"</p>
                                    <h2 class="font-weight-bold">"58,000"  <span class="small">" SUSHI"</span></h2>
                                   
                                </div>
                          
                            </div>
                            <div class="small">
                               "VDBjMjI1ZmE0MmQzYTAwYWJlZGNjMTFkNzQ5YjMxZGFkNGVhYjU2N2YwNzFmYjFk"
                               <span class="ml-2 badge bg-dribbble">
                              "KINGS.sc"
                            </span>
                            </div>
                            
                        </div>
                  
                 
                   <div class="table-responsive">
                    <table class="table table-striped mb-0">
                        <thead>
                        <tr>
                            <th>"Token"</th>
                            <th>"Amount"</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>
                                "KINGS"
                            </td>
                            <td>"0.001"</td>
                        </tr>
                        <tr>
                            <td>
                                "XCURRENCY"
                            </td>
                            <td>"897"</td>
                        </tr>
                        <tr>
                            <td>
                                "EAGLE"
                            </td>
                            <td>"1,200,000"</td>
                        </tr>
                        </tbody>
                    </table>
                   </div>
                 </div>
                </div>
                 <div class="col-md-9">
                    <div class="card">
        <div class="card-body">
            <div>
                <h6 class="card-title">"Recent Transactions"</h6>
            </div>
            <div class="row">
                <div class="col-md-12">
                  <div class="table-responsive">
                        <table id="recent-transactions" class="table table-striped table-bordered">
                            <thead>
                            <tr>
                                <th>"Date"</th>
                                <th>"Amount"</th>
                                <th>"Token"</th>
                                <th>"To"</th>
                                <th>"From"</th>
                                <th>"Category"</th>
                                <th>"Status"</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                             <td>
                                "2020-03-29 16:43:14 UTC"
                                </td>
                                <td>
                                  "0.00345"
                                </td>
                                <td>"SUSHI"</td>
                                <td></td>
                                <td>"KINGS.sc"</td>
                                <td>
                                <span class="badge bg-secondary-bright">"Mining reward"</span>
                                <span class="text-success pl-2 ti-arrow-up"></span>
                                 
                                </td>
                                <td>
                                <span class="badge bg-success-bright">"Completed"</span>
                                </td>
                            </tr>
                             <tr>
                             <td>
                                "2020-03-29 16:43:14 UTC"
                                </td>
                                <td>
                                  "0.00345"
                                </td>
                                <td>"SUSHI"</td>
                                <td>"KINGS.sc"</td>
                                <td></td>
                                <td>
                                <span class="badge bg-info-bright">"Payment"</span>
                                <span class="text-warning pl-2 ti-arrow-down"></span>
                                 
                                </td>
                                <td>
                                 <span class="badge bg-success-bright">"Completed"</span>
                                 </td>
                            </tr>
                            </tbody>
                        </table>
                  
                </div>
                </div>
            </div>
        </div>
    </div>
                </div>
            </div>

        </div>
    </div>

  

   

  


            </div>

          

         

        </div>

    </div>

</div>

</div>
  }

}