<%@ Page Title="" Language="C#" MasterPageFile="~/masterpages/main/main.Master" AutoEventWireup="true" CodeBehind="conns-admin.aspx.cs" Inherits="ReportsGeneratorPlugin.PL.admin.conns_admin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentHead" runat="server">
    <link href="../UI/js/JQGrid-bootstrap/css/ui.jqgrid-bootstrap.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentMenu" runat="server">
        <ul class="nav navbar-nav">
        <li><a href="/PL/admin/reporter-admin.aspx">Reports</a></li>
        <li><a href="/PL/admin/apps-admin.aspx">Applications</a></li>
        <li class="active"><a href="#">Connection Strings</a></li>
    </ul>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentBody" runat="server">
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title"><strong>Connection Strings</strong></h3>
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
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentFooter" runat="server">
    <script src="../UI/js/JQGrid-bootstrap/js/i18n/grid.locale-en.js"></script>
    <script src="../UI/js/JQGrid-bootstrap/js/jquery.jqGrid.min.js"></script>
    <script src="../UI/js/common-jqGrid.js?v=1"></script>
    <script src="js/data-conns-admin.js?v=1"></script>
    <script src="js/jqgrid-conns-admin.js?v=1"></script>
    <script>
        $.jgrid.defaults.responsive = true;
        $.jgrid.defaults.styleUI = 'Bootstrap';
        $(document).ready(function () {
            getJQGridDetail();
        });
    </script>
</asp:Content>