<!DOCTYPE html>
<html>
  <head>
    <title>WPConnex Web Configuration</title>
<link
      rel="icon"  
      type="image/png"
      sizes="32x32"
      href="images/WP_Connex_logo_favicon.png"
    /> 
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css"
    />
    <link
      href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
      rel="stylesheet"
      type="text/css"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css"
    />
    <link rel="stylesheet" href="nav-bar.css" />
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  </head>
  
  <style>
  h3{
margin-top: 68px;
}

  </style>
  <body>
    <div class="sidebar">
      <%@ include file="common.jsp"%>
    </div>
    <div class="header">
        <%@ include file="header.jsp"%>
    </div>
    <div class="content">
      <section style="margin-left: 1em">
        <h3>OVERVIEW</h3><hr>
        <div style="display:flex;justify-content:left;width:100%;">
        <img src="images/rut_image.jpg" width="500" height="400" />

        <div class="container" style="width: 60%;margin-left: 1%;height: 400;" >
          <table >
            <tr>
              <th colspan="2">General data</th>
            </tr>

            <tr>
              <td>Manufactured by</td>
              <td>TAS INDIA PRIVATE LIMITED</td>
            </tr>

            <tr>
              <td>Manufacturing address</td>
              <td>PUNE, INDIA</td>
            </tr>

            <tr>
              <td>Web address</td>
              <td>http://www.tasm2m.com</td>
            </tr>

            <tr>
              <td>Model number</td>
              <td>WP500</td>
            </tr>

            <tr>
              <td>Customer order number</td>
              <td>2404267</td>
            </tr>

            <tr>
              <td>Serial no.</td>
              <td>1364211569</td>
            </tr>

            <tr>
              <td>Firmware revision</td>
              <td>2022.6.0(22.6.0.43)</td>
            </tr>

            <tr>
              <td>Hardware revision</td>
              <td>02</td>
            </tr>

            <tr>
              <td>Web app version</td>
              <td>1.0</td>
            </tr>
          </table>
        </div>
         </div>
      </section>
      <!-- <footer>
        <span>COPYRIGHT � TAS INDIA PVT LTD, 2023</span>
      </footer> -->
     
    </div>
    <div class="footer">
      <%@ include file="footer.jsp"%>
 </div>
  </body>
</html>
