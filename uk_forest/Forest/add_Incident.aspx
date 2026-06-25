<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="add_Incident.aspx.cs" Inherits="uk_forest.Forest.add_Incident" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:UpdatePanel ID="UpdatePannel1" runat="server">
        <ContentTemplate>
            <div class="card mb-3 shadow-lg">
                <div class="card-header d-flex flex-row align-items-center justify-content-between custom-header">
                    <h3 class="m-0 font-weight-bolder text-uppercase" style="font-size: larger; font-weight: 700;">Wildlife Incident Report</h3>
                </div>

                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <asp:Label ID="lblDateOfIncident" runat="server" CssClass="font-weight-bold"
                                Text='Date of Incident <span class="text-danger">*</span>'></asp:Label>
                            <asp:TextBox ID="txtDateOfIncident" runat="server" TextMode="Date"
                                CssClass="form-control rounded-pill shadow-sm" />
                            <asp:RequiredFieldValidator ID="rfvDateOfIncident" runat="server"
                                ControlToValidate="txtDateOfIncident" ErrorMessage="Required"
                                ForeColor="Red" ValidationGroup="incident" />
                        </div>

                        <div class="col-md-4">
                            <asp:Label ID="lblAnimal" runat="server" CssClass="font-weight-bold"
                                Text='Type/Name of Animal Causing the Damage <span class="text-danger">*</span>'></asp:Label>
                            <asp:TextBox ID="txtAnimal" runat="server"
                                CssClass="form-control rounded-pill shadow-sm"
                                MaxLength="100" placeholder="e.g., Elephant, Leopard" />
                            <asp:RequiredFieldValidator ID="rfvAnimal" runat="server"
                                ControlToValidate="txtAnimal" ErrorMessage="Required"
                                ForeColor="Red" ValidationGroup="incident" />
                        </div>



                        <div class="col-md-4">
                            <asp:Label ID="lblHumanLoss" runat="server" CssClass="font-weight-bold d-block mb-2"
                                Text='Human Loss <span class="text-danger">*</span>'></asp:Label>
                            <asp:RadioButtonList ID="rblHumanLoss" runat="server"
                                RepeatDirection="Horizontal" RepeatLayout="Flow"
                                CssClass="d-flex gap-2 align-items-center mb-2" ValidationGroup="incident">
                                <asp:ListItem Text="Injured" Value="Injured" />
                                <asp:ListItem Text="Deceased" Value="Deceased" />
                            </asp:RadioButtonList>
                            <asp:RequiredFieldValidator ID="rfvHumanLoss" runat="server"
                                ControlToValidate="rblHumanLoss" ErrorMessage="Select an option"
                                InitialValue="" ForeColor="Red" ValidationGroup="incident" />
                        </div>

                        <div class="col-md-4">
                            <asp:Label ID="lblVictimName" runat="server" CssClass="font-weight-bold"
                                Text='Victim Name <span class="text-danger">*</span>'></asp:Label>
                            <asp:TextBox ID="txtVictimName" runat="server"
                                CssClass="form-control rounded-pill shadow-sm"
                                MaxLength="100" placeholder="Full name" />
                            <asp:RequiredFieldValidator ID="rfvVictimName" runat="server"
                                ControlToValidate="txtVictimName" ErrorMessage="Required"
                                ForeColor="Red" ValidationGroup="incident" />
                        </div>



                        <div class="col-md-4">
                            <asp:Label ID="lblGender" runat="server" CssClass="font-weight-bold"
                                Text='Gender <span class="text-danger">*</span>'></asp:Label>
                            <asp:RadioButtonList ID="rblGender" runat="server"
                                RepeatDirection="Horizontal" CssClass="d-flex gap-2" RepeatLayout="Flow" ValidationGroup="incident">
                                <asp:ListItem Text="Male" Value="Male" />
                                <asp:ListItem Text="Female" Value="Female" />
                                <asp:ListItem Text="Other" Value="Other" />
                            </asp:RadioButtonList>
                        </div>

                        <div class="col-md-4">
                            <asp:Label ID="lblAge" runat="server" CssClass="font-weight-bold"
                                Text='Victim Age <span class="text-danger">*</span>'></asp:Label>
                            <div class="input-group">
                                <asp:TextBox ID="txtAge" runat="server"
                                    CssClass="form-control rounded-pill shadow-sm"
                                    TextMode="Number" placeholder="e.g. 35" />
                                <div class="input-group-append">
                                    <span class="input-group-text bg-light border-0">Years</span>
                                </div>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvAge" runat="server"
                                ControlToValidate="txtAge" ErrorMessage="Required"
                                ForeColor="Red" ValidationGroup="incident" />
                        </div>

<div class="col-md-4">
    <asp:Label ID="Label1" runat="server" CssClass="font-weight-bold"
        Text='Time of Incident <span class="text-danger">*</span>'></asp:Label>

    <div class="d-flex align-items-center gap-2">
        <asp:TextBox ID="txtTimeOfIncident" runat="server"
            CssClass="form-control rounded-pill shadow-sm"
            Placeholder="hh:mm AM/PM" />

    </div>

    <asp:RequiredFieldValidator ID="rfvTimeOfIncident" runat="server"
        ControlToValidate="txtTimeOfIncident" ErrorMessage="Time is required"
        ForeColor="Red" ValidationGroup="incident" Display="Dynamic" />

    <asp:RegularExpressionValidator ID="revTimeOfIncident" runat="server"
        ControlToValidate="txtTimeOfIncident"
        ValidationExpression="^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(AM|PM|am|pm)$"
        ErrorMessage="Enter a valid time in hh:mm AM/PM format"
        ForeColor="Red" ValidationGroup="incident" Display="Dynamic" />
</div>

                        <div class="col-md-4">
                            <asp:Label ID="lblActivity" runat="server" CssClass="font-weight-bold"
                                Text='Person Activity at the Time of Incident <span class="text-danger">*</span>'></asp:Label>
                            <asp:TextBox ID="txtActivity" runat="server"
                                CssClass="form-control rounded-pill shadow-sm"
                                MaxLength="200" placeholder="e.g., Collecting firewood, Farming" />
                            <asp:RequiredFieldValidator ID="rfvActivity" runat="server"
                                ControlToValidate="txtActivity" ErrorMessage="Required"
                                ForeColor="Red" ValidationGroup="incident" />
                        </div>

                        <div class="col-md-4">
                            <asp:Label ID="lblPlace" runat="server" CssClass="font-weight-bold"
                                Text='Place/Region <span class="text-danger">*</span>'></asp:Label>
                            <asp:TextBox ID="txtPlace" runat="server"
                                CssClass="form-control rounded-pill shadow-sm"
                                MaxLength="200" placeholder="e.g., Village name, Region" />
                            <asp:RequiredFieldValidator ID="rfvPlace" runat="server"
                                ControlToValidate="txtPlace" ErrorMessage="Required"
                                ForeColor="Red" ValidationGroup="incident" />
                        </div>
                    
                        <div class="col-md-4">
                            <asp:Label ID="lblLatitude" runat="server" CssClass="font-weight-bold"
                                Text='Latitude'></asp:Label>
                            <asp:TextBox ID="txtLatitude" runat="server"
                                CssClass="form-control rounded-pill shadow-sm"
                                MaxLength="50" placeholder="Latitude" />
                        </div>

                        <div class="col-md-4">
                            <asp:Label ID="lblLongitude" runat="server" CssClass="font-weight-bold"
                                Text='Longitude'></asp:Label>
                            <asp:TextBox ID="txtLongitude" runat="server"
                                CssClass="form-control rounded-pill shadow-sm"
                                MaxLength="50" placeholder="Longitude" />
                        </div>

                          <%--<div class="col-md-4">
                            <asp:Label ID="lblCertificate" runat="server" CssClass="font-weight-bold"
                                Text='Village Head Certificate'></asp:Label>
                          <asp:FileUpload ID="fileCertificate" runat="server"  CssClass="form-control rounded-pill shadow-sm"/>
                        </div>--%>


                        <div class="col-md-12">
                            <asp:Label ID="lblSummary" runat="server" CssClass="font-weight-bold"
                                Text='Incident Summary <span class="text-danger">*</span>'></asp:Label>
                            <asp:TextBox ID="txtSummary" runat="server" TextMode="MultiLine" Rows="4"
                                CssClass="form-control shadow-sm rounded" placeholder="Describe what happened..." />
                            <asp:RequiredFieldValidator ID="rfvSummary" runat="server"
                                ControlToValidate="txtSummary" ErrorMessage="Required"
                                ForeColor="Red" ValidationGroup="incident" />
                        </div>


                        <div class="row">
                            <div class="col-md-4">
                                <asp:Button ID="btn_add_incident" runat="server" ValidationGroup="incident"
                                    Text="Submit" OnClick="btn_add_incident_Click"
                                    CssClass="btn btn-success rounded-pill shadow-sm px-4 py-2 btn-bubble"
                                    Style="font-weight: 600; letter-spacing: 0.5px;" />
                            </div>
                        </div>

                    </div>
                </div>
        </ContentTemplate>
    </asp:UpdatePanel>
   <%-- <script type="text/javascript">
        function validateTimeDropdowns(sender, args) {
            var hour = document.getElementById('<%= ddlHour.ClientID %>').value;
        var minute = document.getElementById('<%= ddlMinute.ClientID %>').value;
            args.IsValid = (hour !== "" && minute !== "");
        }
    </script>--%>

</asp:Content>
