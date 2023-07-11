<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Certificates</title>
<link rel="stylesheet" type="text/css" href="user_styles.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%@ include file="header.jsp"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style type="text/css">
h2 {
	margin-left: 250px;
	margin-top: 70px;
}


/* Style the tab */
.tab {
  overflow: hidden;
  border: 1px solid #ccc;
  background-color: #f1f1f1;
  margin-left: 250px;
}

/* Style the buttons inside the tab */
.tab button {
  background-color: inherit;
  float: left;
  border: none;
  outline: none;
  cursor: pointer;
  padding: 14px 16px;
  transition: 0.3s;
  font-size: 17px;
}

.edit-btn{
      width: 20px;
      height: 20px;
      cursor: pointer;
      margin-left: 10px;
      
      }
      
      .fa-pen{
      color: #1E90FF;
      margin-left: -5px;
      }
      
      .fa-close{
      color: #1E90FF;
      margin-left: -2px;
      }
      
      .delete-btn{
      width: 20px;
      height: 20px;
      cursor: pointer;
      margin-top: 15px;
      margin-left: 10px;
      }
      
      .fa-plus{
      color: #1E90FF;
      font-size: 13px;
      }
      

/* Change background color of buttons on hover */
.tab button:hover {
  background-color: #ddd;
}

/* Create an active/current tablink class */
.tab button.active {
  background-color: #ccc;
}

/* Style the tab content */
.tabcontent {
  display: none;
  padding: 6px 12px;
  border: 1px solid #ccc;
  border-top: none;
  margin-left: 250px;
}
</style>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<%@ include file="common.jsp"%></div>

	</div>

	<div class="content">
		<h2>Certificates</h2>

		<div class="tab">
			<button class="tablinks" onclick="openCity(event, 'trust_store')">Trust Store</button>
			<button class="tablinks" onclick="openCity(event, 'identity_store')">Identity Store</button>
		</div>

		<div id="trust_store" class="tabcontent" style="display:block">
			<table>
          <tr>
            <th>Trust Stores</th>
            <th class="th1">Content</th>
            <th class="th2"></th>
          </tr>
          <tr>
            <td rowspan="4">Empty</td>
            <td>Certificates :</td>
            <td rowspan="4"></td>
          </tr>
          <tr>
            <td>
              <table class="table2">
                <tr>
                  <th class="no"></th>
                  <th class="no">No .</th>
                  <th>Type</th>
                  <th>Subject(Common Name)</th>
                  <th>Issuer(Common Name)</th>
                  <th>Valid until</th>
                  <th>Details</th>
                  <th class="no"></th>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>CRL Lists :</td>
          </tr>
          <tr>
            <td>
              <table class="table2">
                <tr>
                  <th class="no"></th>
                  <th class="no">No .</th>
                  <th>Type</th>
                  <th>Issuer(Common Name)</th>
                  <th>This Update</th>
                  <th>Next Update</th>
                  <th>Details</th>
                  <th class="no"></th>
                </tr>
              </table>
            </td>
          </tr>

          <tr>
            <td rowspan="6">OPC UA-configurable</td>
            <td>Certificates :</td>
            <td rowspan="6">
              <button class="edit-btn"><i class="fas fa-pen" style="font-size:18px"></i></button>
              &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
              <button class="delete-btn"><i class="fa fa-close" style="font-size:18px"></i></button>
            </td>
          </tr>
          <tr>
            <td>
              <table class="table2">
                <tr>
                  <th class="no"></th>
                  <th class="no">No .</th>
                  <th>Type</th>
                  <th>Subject(Common Name)</th>
                  <th>Issuer(Common Name)</th>
                  <th>Valid until</th>
                  <th>Details</th>
                  <th class="no"></th>
                </tr>
                <tr>
                  <td class="no"><button><i class="fa fa-plus"></i></button></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>CRL Lists :</td>
           </tr>
          <tr>
            <td>
              <table class="table2">
                <tr>
                  <th class="no"></th>
                  <th class="no">No .</th>
                  <th>Type</th>
                  <th>Issuer(Common Name)</th>
                  <th>This Update</th>
                  <th>Next Update</th>
                  <th>Details</th>
                  <th class="no"></th>
                </tr>
                <tr>
                  <td class="no"><button><i class="fa fa-plus"></i></button></td>
                </tr>               
              </table>
            </td>
          </tr>
          
        </table>
		</div>

		<div id="identity_store" class="tabcontent" style="display:none">
			<table>
          <tr>
            <th>Identity Store</th>
            <th class="th1">Content</th>
            <th class="th2"></th>
          </tr>
          <tr>
            <td rowspan="2">IDevID</td>
          </tr>
          <tr>
            <td>
              <table class="table2">
                <tr>
                  <th class="th2">Icons--</th>
                  <th class="th2">No .</th>
                  <th class="element">Element</th>
                  <th class="element">Type</th>
                  <th class="description">Description</th>
                  <th>Details</th>
                  <th class="no">Download--</th>
                </tr>
                <tr>
                  <td class="th2"></td>
                  <td class="th2">1</td>
                  <td>Key Pair</td>
                  <td>RSA TPM 2048</td>
                  <td>RSA key Pair</td>
                  <td><i class="fa fa-print" style="font-size:18px"></i></td>
                   <td><i class="fa fa-download" style="font-size:18px"></i></td>
                 
                </tr>
                <tr>
                  <td class="th2"></td>
                  <td class="th2">2</td>
                  <td>Certificate</td>
                  <td>Key Certificate</td>
                  <td>Common Name: AxC F 2152</td>
                  <td><i class="fa fa-print" style="font-size:18px"></i></td>
                  <td><i class="fa fa-download" style="font-size:18px"></i></td>
                </tr>
                <tr>
                  <td class="th2"></td>
                  <td class="th2">3</td>
                  <td>Issuer Certificate</td>
                  <td>Common Name: PLCnext Device Signing CA</td>
                  <td>RSA key Pair</td>
                  <td><i class="fa fa-print" style="font-size:18px"></i></td>
                  <td><i class="fa fa-download" style="font-size:18px"></i></td>
                </tr>
              </table>
            </td>
            <td></td>
          </tr>

          <tr>
            <td rowspan="2">OPC UA-self-signed</td>
          </tr>
          <tr>
            <td>
              <table class="table2">
                <tr>
                  <th class="th2">Icons--</th>
                  <th class="th2">No .</th>
                  <th class="element">Element</th>
                  <th class="element">Type</th>
                  <th class="description">Description</th>
                  <th>Details</th>
                  <th class="no">Download--</th>
                </tr>
                <tr>
                  <td class="th2"></td>
                  <td class="th2">1</td>
                  <td>Key Pair</td>
                  <td>RSA TPM 2048</td>
                  <td>RSA key Pair</td>
                  <td><i class="fa fa-print" style="font-size:18px"></i></td>
                  <td><i class="fa fa-download" style="font-size:18px"></i></td>
                </tr>
                <tr>
                  <td class="th2"></td>
                  <td class="th2">2</td>
                  <td>Certificate</td>
                  <td>Key Certificate</td>
                  <td>Common Name: AxC F 2152</td>
                  <td><i class="fa fa-print" style="font-size:18px"></i></td>
                  <td><i class="fa fa-download" style="font-size:18px"></i></td>
                </tr>
                <tr>
                  <td class="th2"></td>
                  <td class="th2">3</td>
                  <td>Issuer Certificate</td>
                  <td>Common Name: PLCnext Device Signing CA</td>
                  <td>RSA key Pair</td>
                  <td><i class="fa fa-print" style="font-size:18px"></i></td>
                  <td><i class="fa fa-download" style="font-size:18px"></i></td>
                </tr>
                <tr>
                  <td class="th2"><button><i class="fa fa-plus"></i></button></td>
                </tr>
              </table>
            </td>
            <td>
              <button class="edit-btn"><i class="fas fa-pen" style="font-size:18px"></i></button
              >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <button class="delete-btn"><i class="fa fa-close" style="font-size:18px"></i></button>
            </td>
          </tr>

          <tr>
            <td rowspan="2">HTTPS-self-signed</td>
          </tr>
          <tr>
            <td>
              <table class="table2">
                <tr>
                  <th class="th2">Icons--</th>
                  <th class="th2">No .</th>
                  <th class="element">Element</th>
                  <th class="element">Type</th>
                  <th class="description">Description</th>
                  <th>Details</th>
                  <th class="no">Download--</th>
                </tr>
                <tr>
                  <td class="th2"></td>
                  <td class="th2">1</td>
                  <td>Key Pair</td>
                  <td>RSA TPM 2048</td>
                  <td>RSA key Pair</td>
                  <td><i class="fa fa-print" style="font-size:18px"></i></td>
                  <td><i class="fa fa-download" style="font-size:18px"></i></td>
                </tr>
                <tr>
                  <td class="th2"></td>
                  <td class="th2">2</td>
                  <td>Certificate</td>
                  <td>Key Certificate</td>
                  <td>Common Name: AxC F 2152</td>
                  <td><i class="fa fa-print" style="font-size:18px"></i></td>
                  <td><i class="fa fa-download" style="font-size:18px"></i></td>
                </tr>
                <tr>
                  <td class="th2"><button><i class="fa fa-plus"></i></button></td>
                </tr>
              </table>
            </td>
            <td>
              <button class="edit-btn"><i class="fas fa-pen" style="font-size:18px"></i></button
              >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <button class="delete-btn"><i class="fa fa-close" style="font-size:18px"></i></button>
            </td>
          </tr>
        </table>
		</div>
	</div>
	<%@ include file="footer.jsp"%>

	<script>
		function openCity(evt, cityName) {
			var i, tabcontent, tablinks;
			tabcontent = document.getElementsByClassName("tabcontent");
			for (i = 0; i < tabcontent.length; i++) {
				tabcontent[i].style.display = "none";
			}
			tablinks = document.getElementsByClassName("tablinks");
			for (i = 0; i < tablinks.length; i++) {
				tablinks[i].className = tablinks[i].className.replace(
						" active", "");
			}
			document.getElementById(cityName).style.display = "block";
			evt.currentTarget.className += " active";
		}
	</script>
</body>
</html>