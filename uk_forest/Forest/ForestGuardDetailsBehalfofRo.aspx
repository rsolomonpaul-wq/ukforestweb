<%@ Page Language="C#" AutoEventWireup="true" Async="true" MasterPageFile="~/Forest/forestmaster.Master" CodeBehind="ForestGuardDetailsBehalfofRo.aspx.cs" Inherits="uk_forest.Forest.ForestGuardDetailsBehalfofRo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Scoped CSS for ForestGuardDetailsBehalfofRo page */
        .fgd-container {
            margin: 30px auto;
            max-width: 1200px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

            .fgd-container .fgd-header-label {
                font-size: 18px;
                font-weight: bold;
                color: #333;
                margin-bottom: 10px;
                display: block;
            }

            .fgd-container .fgd-dropdown {
                width: 300px;
                padding: 8px;
                font-size: 16px;
                border: 1px solid #ccc;
                border-radius: 4px;
                background-color: #fff;
                margin-bottom: 20px;
            }

                .fgd-container .fgd-dropdown:focus {
                    outline: none;
                    border-color: #007bff;
                    box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
                }

            .fgd-container .fgd-grid-container {
                margin-top: 20px;
            }

            .fgd-container .fgd-grid-header {
                font-size: 24px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 15px;
            }

            .fgd-container .fgd-grid-view {
                width: 100%;
                border-collapse: collapse;
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                overflow: hidden;
            }

                .fgd-container .fgd-grid-view th {
                    background-color: #007bff;
                    color: #fff;
                    font-weight: 600;
                    padding: 12px;
                    text-align: left;
                    border-bottom: 2px solid #0056b3;
                }

                .fgd-container .fgd-grid-view td {
                    padding: 12px;
                    border-bottom: 1px solid #dee2e6;
                    color: #333;
                }

                .fgd-container .fgd-grid-view tr:nth-child(even) {
                    background-color: #f8f9fa;
                }

                .fgd-container .fgd-grid-view tr:hover {
                    background-color: #e9ecef;
                }

                .fgd-container .fgd-grid-view .fgd-no-data {
                    text-align: center;
                    padding: 20px;
                    color: #6c757d;
                    font-style: italic;
                }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <div class="fgd-container">
        <asp:Label ID="lblRO" runat="server" Text="RO ID: " CssClass="fgd-header-label"></asp:Label>
        <asp:DropDownList ID="ddlForestGuard" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlForestGuard_SelectedIndexChanged" CssClass="fgd-dropdown">
            <asp:ListItem Text="Select Forest Guard" Value=""></asp:ListItem>
        </asp:DropDownList>

        <div class="fgd-grid-container">
            <h3 class="fgd-grid-header">Incident Assignment List</h3>
            <asp:GridView ID="gvIncidentAssignments" runat="server" AutoGenerateColumns="False" CssClass="fgd-grid-view" EmptyDataText="No incident assignments found." EmptyDataRowStyle-CssClass="fgd-no-data">
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex + 1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Sno" HeaderText="S.No" Visible="false" />
                    <asp:BoundField DataField="InvestigationId" HeaderText="Investigation ID" />
                    <asp:BoundField DataField="IncidentId" HeaderText="Incident ID" />
                    <%--<asp:BoundField DataField="ForestGuardId" HeaderText="Forest Guard ID" />--%>
                    <asp:BoundField DataField="ForestGuardName" HeaderText="Forest Guard Name" />
                    <asp:BoundField DataField="ForestGuardMobile" HeaderText="Forest Guard Mobile" />
                    <asp:BoundField DataField="ForestGuardEmail" HeaderText="Forest Guard Email" />
                   <%-- <asp:BoundField DataField="RoUserId" HeaderText="RO User ID" />
                    <asp:BoundField DataField="RoName" HeaderText="RO Name" />
                    <asp:BoundField DataField="RoMobile" HeaderText="RO Mobile" />
                    <asp:BoundField DataField="RoEmail" HeaderText="RO Email" />--%>
                    <asp:BoundField DataField="Priority" HeaderText="Priority" />


                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
