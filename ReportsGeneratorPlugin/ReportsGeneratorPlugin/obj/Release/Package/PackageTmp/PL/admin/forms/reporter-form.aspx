<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="reporter-form.aspx.cs" Inherits="ReportsGeneratorPlugin.PL.admin.forms.reporter_form" %>

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
                <input type="hidden" id="hidden_report_uuid" value="<%=sReportUUID %>" />
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-md-3 form-group">
                        <div>
                            <label class="control-label">
                                UUID</label>
                        </div>
                        <input type="text" id="txt_uuid" class="form-control input-md" />
                    </div>
                    <div class="col-md-2 form-group">
                        <div>
                            <label class="control-label">
                                Application</label>
                        </div>
                        <select id="combo_application" class="form-control input-md">
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="col-md-2 form-group">
                        <div>
                            <label class="control-label">
                                Connection</label>
                        </div>
                        <select id="combo_connection" class="form-control input-md">
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="col-md-4 form-group">
                        <div>
                            <label class="control-label">
                                Stored Procedure</label>
                        </div>
                        <input type="text" id="txt_source" class="form-control input-md" />
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
    <script src="../js/data-reporter-admin.js?V=1"></script>
    <script type="text/javascript">
        var REPORTER = '<%=JSON_RAW_URI %>';
        var AJAX_CONTROLLER = '<%=JSON_RAW_CONTROLLER %>';
        var AJAX_PARAMETERS = '<%=JSON_RAW_PARAMETERS %>';
        inputmsg = "<%=lbMessage.ClientID %>";
    </script>
    <script>
        $(document).ready(function () {
            getComboApplications();
        });
    </script>
</body>
</html>
