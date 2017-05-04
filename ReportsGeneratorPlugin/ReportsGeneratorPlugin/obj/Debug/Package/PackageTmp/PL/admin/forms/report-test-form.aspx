<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="report-test-form.aspx.cs" Inherits="ReportsGeneratorPlugin.PL.admin.forms.report_test_form" %>

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
    <link href="../../UI/js/JQGrid-bootstrap/css/ui.jqgrid-bootstrap.css" rel="stylesheet" />
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
                <input type="hidden" id="hidden_request_url" value="<%=sRequestURL %>" />
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
                                &nbsp</label>
                        </div>
                        <button type="button" id="btn_save_configuration" class="btn btn-warning" onclick="getReport()">
                            <i class="fa fa-bolt"></i>&nbsp Run</button>
                    </div>
                    <div id="simple-clone" class="row col-md-12">
                        <div id="clonable_" class="toclone">
                            <div class="col-md-3 form-group">
                                <div>
                                    <label class="control-label">
                                        Parameter</label>
                                </div>
                                <input type="text" name="parameter[]" id="txt_parameter" class="form-control input-md" />
                            </div>
                            <div class="col-md-1 form-group">
                                <div>
                                    <label class="control-label">
                                        &nbsp</label>
                                </div>
                                <button type="button " id="btnadd_" class="btn btn-info addParameter">
                                    <i class="fa fa-plus"></i>
                                </button>
                                <button type="button " id="btndelete1_" class="btn btn-danger deleteParameter">
                                    <i class="fa fa-times"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12 form-group">
                        <div>
                            <label class="control-label">
                                URL Outputs</label>
                        </div>
                        <div class="bg-warning">
                        <samp>
                            <p>JSON URL</p>
                            <a id="link_json" href="#" target="_blank"></a>
                            <p>Grid URL</p>
                            <a id="link_grid" href="#" target="_blank"></a>
                            <p>Export URL</p>
                            <a id="link_export" href="#" target="_blank"></a>
                        </samp>
                            </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title"><strong>Data Results</strong></h3>
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-md-12">
                        <div id="divDetails">
                            <table id="grid0" class="table table-hover table-condensed">
                            </table>
                            <div id="pager0">
                            </div>
                        </div>
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
    <script src="../../UI/js/jquery-cloneya/js/jquery-cloneya.min.js"></script>
    <script src="../../UI/js/JQGrid-bootstrap/js/i18n/grid.locale-en.js"></script>
    <script src="../../UI/js/JQGrid-bootstrap/js/jquery.jqGrid.min.js"></script>
    <script src="../../UI/js/common-jqGrid.js?v=1"></script>
    <script src="../../UI/js/common-js.js"></script>
    <script src="../../UI/js/reporter-js.js"></script>
    <script src="../js/data-report-test.js?V=1"></script>
    <script src="../js/jqgrid-report-test.js?V=1"></script>
    <script type="text/javascript">
        var REPORTER = '<%=JSON_RAW_URI %>';
        var AJAX_CONTROLLER = '<%=JSON_RAW_CONTROLLER %>';
        var AJAX_PARAMETERS = '<%=JSON_RAW_PARAMETERS %>';
        var JSON_JQGRID_STRUCT_URI = '<%=JSON_JQGRID_STRUCT_URI %>';
        var JSON_JQDATAGRID_URI = '<%=JSON_JQDATAGRID_URI %>';
        var JSON_EXPORT_URI = '<%=JSON_EXPORT_URI %>';
        inputmsg = "<%=lbMessage.ClientID %>";
    </script>
    <script>
        $.jgrid.defaults.responsive = true;
        $.jgrid.defaults.styleUI = 'Bootstrap';
        $('#simple-clone').cloneya({ serializeID: true });
        $(document).ready(function () {
            getConfiguration();
            setGeneratedURL();
        });
    </script>
</body>
</html>
