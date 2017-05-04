<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="connection-form.aspx.cs" Inherits="ReportsGeneratorPlugin.PL.admin.forms.connection_form" %>

<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <title>Reporter API</title>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!--[if lt IE 9]>
        <script src="../../UI/js/html5shiv.js"></script>
        <script src="../../UI/js/respond.min.js"></script>
     <![endif]-->
    <link href="../../UI/css/bootstrap.min.css" rel="stylesheet" />
    <link href="../../UI/css/font-awesome.min.css" rel="stylesheet" />
</head>
<body>
    <div id='divError' style="text-align: center;">
        <asp:Label ID="lbMessage" runat="server" Text=""></asp:Label>
    </div>
    <div id="alerts"></div>
    <div class="container-fluid">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title"><strong>Report Configuration</strong></h3>
                <input type="hidden" id="hidden_connection_id" value="<%=sConnectionID %>" />
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-md-2 form-group">
                        <div>
                            <label class="control-label">
                                Connection ID</label>
                        </div>
                        <input type="text" id="txt_id" class="form-control input-md" readonly />
                    </div>
                    <div class="col-md-2 form-group">
                        <div>
                            <label class="control-label">
                                Name</label>
                        </div>
                         <input type="text" id="txt_name" class="form-control input-md" placeholder="Connection nickname" rq="1"/>
                    </div>
                    <div class="col-md-4 form-group">
                        <div>
                            <label class="control-label">
                                Connection String</label>
                        </div>
                         <input type="text" id="txt_connection" class="form-control input-md" placeholder="Oracle connection string"/>
                    </div>
                    <div class="col-md-2 form-group">
                        <div>
                            <label class="control-label">
                                User</label>
                        </div>
                         <input type="password" id="txt_user" class="form-control input-md" placeholder="Connection user"/>
                    </div>
                    <div class="col-md-2 form-group">
                        <div>
                            <label class="control-label">
                                Password</label>
                        </div>
                         <input type="password" id="txt_password" class="form-control input-md" placeholder="Connection password"/>
                    </div>
                    <div class="col-md-2 form-group">
                        <div>
                            <label class="control-label">
                                &nbsp</label>
                        </div>
                        <button type="button" id="btn_save_configuration" class="btn btn-success btn-block " onclick="saveConfiguration()">
                            <i class="fa fa-save"></i>&nbsp Save</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="../../UI/js/jquery.min.js"></script>
    <script src="../../UI/js/bootstrap.min.js"></script>
    <script src="../../UI/js/jquery.blockui.js"></script>
    <script src="../../UI/js/colorbox/js/jquery.colorbox-min.js"></script>
    <script src="../../UI/js/jsDate.js"></script>
    <script src="../../UI/js/common-js.js"></script>
    <script src="../../UI/js/reporter-js.js"></script>
    <script src="../js/data-conns-admin.js?V=1"></script>
    <script type="text/javascript">
        var REPORTER = '<%=JSON_RAW_URI %>';
        var AJAX_CONTROLLER = '<%=JSON_RAW_CONTROLLER %>';
        var AJAX_PARAMETERS = '<%=JSON_RAW_PARAMETERS %>';
        inputmsg = "<%=lbMessage.ClientID %>";
    </script>
    <script>
        $(document).ready(function () {
            getConnection();
        });
    </script>
</body>
</html>