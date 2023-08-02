 
 <%-- <!-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%> -->
<!DOCTYPE html>
<head>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <link
    href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
    rel="stylesheet"
    type="text/css"
  />
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css"
  />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
  <link rel="stylesheet" href="nav-bar.css" />
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body>
 
  <section class="app">
    <aside class="sidebar">
      <header>
        <img src="images/tasLogo.jpg" width="70%" />
      </header>
      <nav class="sidebar-nav">
        <ul>
          <li>
            <a href="overview.jsp"><i class="fa fa-file"></i> <span>Overview</span></a>
          </li>
          <li>
            <a href="#"
              ><i class="fa fa-sliders"></i> <span class="">Status</span></a
            >
            <ul class="nav-flyout">
              <li>
                <a href="logs.jsp"><i class="fa fa-bars"></i>Logs</a>
              </li>
            </ul>
          </li>
          <li>
            <a href="#"
              ><i class="fa fa-cogs"></i>
              <span class="">Lan Settings</span></a
            >
            <ul class="nav-flyout">
              <li>
                <a href="lan.jsp"><i class="fa fa-rss"></i>Lan</a>
              </li>
            </ul>
          </li>
          <li>
            <a href="#"
              ><i class="fa fa-link"></i>
              <span class="">Services</span></a
            >
            <ul class="nav-flyout">
              <li>
                <a href="firewall.jsp"><i class="ion-ios-timer-outline"></i>Firewall</a>
              </li>
              <li>
                <a href="ntp.jsp"><i class="ion-arrow-graph-down-left"></i>Ntp</a>
              </li>
              <li>
                <a href="#"
                  ><i class="fa fa-cloud"></i>Web Services</a
                >
              </li>
            </ul>
          </li>
          <li>
            <a href="#"
              ><i class="ion-ios-paper-outline"></i>
              <span class="">Straton</span></a
            >
            <ul class="nav-flyout">
              <li>
                <a href="#"
                  ><i class="ion-ios-filing-outline"></i>Application</a
                >
              </li>
              <li>
                <a href="#"
                  ><i class="fa fa-quora"></i>Quick Client</a
                >
              </li>
            </ul>
          </li>
          
          <li>
            <a href="#"
              ><i class="ion-ios-paper-outline"></i>
              <span class="">Advait</span></a
            >
            <ul class="nav-flyout">
              <li>
                <a href="mqtt.jsp"
                  ><i class="ion-ios-filing-outline"></i>IIOT Connex</a
                >
              </li>
              <li>
                <a href="jsonbuilder.jsp"
                  ><i class="fa fa-quora"></i>JSON Builder</a
                >
              </li>
            </ul>
          </li>
          
          <li>
            <a href="#"
              ><i class="fa fa-university"></i>
              <span class="">Administration</span></a
            >
            <ul class="nav-flyout">
              <li>
                <a href="user.jsp"
                  ><i class="fa fa-user-secret"></i>User Settings</a
                >
              </li>
              <li>
                <a href="#"
                  ><i class="ion-ios-lightbulb-outline"></i>Firmware</a
                >
              </li>
              <li>
                <a href="#"><i class="fa fa-id-card"></i>License</a>
              </li>
              <li>
                <a href="#"><i class="ion-ios-locked-outline"></i>Backup</a>
              </li>
              <li>
                <a href="#"><i class="ion-ios-navigate-outline"></i>Reboot</a>
              </li>
              <li>
                <a href="certificates.jsp"
                  ><i class="fa fa-certificate"></i>Certificates</a
                >
              </li>
            </ul>
          </li>
        </ul>
      </nav>
    </aside>
  </section>
  
</body>
  --%>
  
  
  
<!-- ---------------------------------------------------------------- -->


<!-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%> -->
<!DOCTYPE html>
<head>
  <link
    href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
    rel="stylesheet"
    type="text/css"
  />
  <link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css"
  />
  <link
    rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css"/>
  <link rel="stylesheet" href="nav-bar.css" />
  <script src="jquery-3.6.0.min.js"></script>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  
  <title>WP500 Web Configuration</title>
<link
      rel="icon"  
      type="image/png"
      sizes="32x32"
      href="favicon.png"
    /> 
</head>
<body>
  <!-- <section class="header">
    <header>
      
      
    </header>
  </section> -->
  <section class="app">
    <aside class="sidebar">
      <header>
        <img src="images/tasm2m.png" width="70%" />
      </header>
      <nav class="sidebar-nav">
        <ul id="tabs">
          <li class="nav-item">
            <a href="#">
              <div class="sidebar-title">
                <img src="icons/system_white.png" />
                <div class="sidebar-title">System</div>
              </div>
            </a>
            <ul id="tabs1" class="nav-flyout">
            
            <li class="nav-item">
                <a href="overview.jsp">Overview</a>
              </li>
              <li class="nav-item">
                <a href="user.jsp">User Settings</a>
              </li>
              <li class="nav-item">
                <a href="#">Firmware</a>
              </li>
              <li class="nav-item">
                <a href="#">License</a>
              </li>
              <li class="nav-item">
                <a href="#">Backup</a>
              </li>
              <li class="nav-item">
                <a href="#">Reboot</a>
              </li>
              <li class="nav-item">
                <a href="#">Certificates</a>
              </li>
            </ul>
          </li>

          <li class="nav-item">
            <a href="#">
              <div class="sidebar-title">
                <img src="icons/network_white.png" />
                <div>Network</div>
              </div>
            </a>
            <ul class="nav-flyout">
              <li class="nav-item">
                <a href="lan.jsp">LAN</a>
              </li>
              <!-- <li class="nav-item">
                <a href="#">Application</a>
              </li>
              <li class="nav-item">
                <a href="#">Quick Client</a>
              </li> -->
              <li class="nav-item">
                <a href="firewall.jsp">Firewall</a>
              </li>
              <li class="nav-item">
                <a href="ntp.jsp">NTP</a>
              </li>
              
              
              
             
            </ul>
          </li>

          <li class="nav-item">
            <a href="#">
              <div class="sidebar-title">
                <img src="icons/settings_white.png" />
                <div>Services</div>
              </div>
            </a>
            <ul class="nav-flyout">
              
              <!-- <li class="nav-item">
                <a href="#">Web Services</a>
              </li> -->
              <li class="nav-item">
                <a href="mqtt.jsp">MQTT Server</a>
              </li>
              <li class="nav-item">
                <a href="jsonbuilder.jsp">JSON Builder</a>
              </li>
              <li class="nav-item">
                <!-- <a href="http://192.168.1.102:8081/webmon/index.html" target="_blank">Straton</a> -->
                <a onclick="openExtLink()">Straton Variable</a>
              </li>
              <li class="nav-item">
                <!-- <a href="http://192.168.1.102:8081/webmon/index.html" target="_blank">Straton</a> -->
                <a onclick="openExtLink()">Straton Live Data</a>
              </li>
            </ul>
          </li>

          <li class="nav-item">
            <a href="#">
              <div class="sidebar-title">
                <img src="icons/status_white.png" />
                <div>Status</div>
              </div>
            </a>
            <ul class="nav-flyout">
              <li class="nav-item">
                <a href="logs.jsp">Logs</a>
              </li>
            </ul>
          </li>

          
        </ul>
      </nav>
    </aside>
  </section>
  <!-- <section class="footer">
    <footer>
      <span>COPYRIGHT © TAS INDIA PVT LTD, 2023</span>
    </footer>
  </section> -->

  <script>
  
  function openExtLink() {

	  let url = window.location.protocol + "//" + window.location.host+"/webmon/index.html";

      window.open(url, '_blank').focus();
    }
  
    $(document).ready(function () {
      $("ul li > a").on("click", function () {
        $("ul").find(".active").removeClass("active");
        $(this).addClass("active");
      });

      $("ul li ul li> a").on("click", function () {
        $("ul").find(".active").addClass("active");
        $("ul li ul").find(".active").removeClass("active");
        $(this).addClass("active");
        $(this).parents("li").last().addClass("active");
      });
    });
  </script>
</body>
