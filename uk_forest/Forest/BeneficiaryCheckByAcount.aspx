<%@ Page Language="C#" Async="true" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="BeneficiaryCheckByAcount.aspx.cs" Inherits="uk_forest.Forest.BeneficiaryCheckByAcount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        @media (min-width: 1200px) {
            .container {
                max-width: 1580px;
            }
        }

        .tab-content-wrapper {
            margin-top: 12px;
            background: #fff;
            border-radius: 5px;
            max-width: 1557px;
            margin-left: auto;
            margin-right: auto;
            padding: 20px;
            box-shadow: 0 0 11px rgb(167 167 167 / 13%);
        }


        .form-row {
            display: flex;
            gap: 20px;
            padding: 10px;
            background: #e8f5e9;
            border-radius: 6px;
            margin-bottom: 35px !important;
            width: 100%;
        }

        label {
            font-weight: 500;
            display: block;
            margin-bottom: 3px;
            float: left;
            font-size: 16px;
            color: #222;
        }

        input[type="text"], select {
            width: 100%;
            padding: 6px;
            margin-bottom: 6px;
            border-radius: 3px;
            border: 1px solid #b6b6b6;
        }

        .form-control {
            display: block;
            width: 100%;
            padding: .375rem .75rem;
            font-size: 1rem;
            line-height: 1.5;
            color: #495057;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ced4da;
            border-radius: .25rem;
            transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out;
        }

        .submit-btn {
            background-color: #12450b;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            margin-bottom: 25px;
            transition: background-color 0.3s ease, opacity 0.3s ease;
        }

        .submitNowBtn {
            border-bottom: 1px solid #dddddd9e;
        }

        .grid-container .table {
            width: 100%;
            border-collapse: collapse;
        }

            .grid-container .table th,
            .grid-container .table td {
                padding: 8px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            .grid-container .table th {
                background-color: #f2f2f2;
                font-weight: bold;
            }

        .btn-edit {
            background-color: #12450b;
            color: white;
            border: none;
            padding: 5px 10px;
            margin-right: 5px;
            border-radius: 3px;
            cursor: pointer;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="grid_item text-center">
        <div class="container divtab">
            <div class="tab-content-wrapper">
                <div class="form-container">
                    <h3 class="font-weight-bold titleHeading">Add Beneficiary Details</h3>

                    <!-- First Row: Bank Details -->
                    <div class="form-row my-4">
                        <div style="flex: 1">
                            <asp:Label ID="lblFullName" runat="server" Text="Bank Account Holder Name" AssociatedControlID="txtFullName"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                                    ControlToValidate="txtFullName"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" 
    onkeyup="toTitleCase(this)" onkeypress="return onlyAlphabets(event)">
</asp:TextBox>

                        </div>

                        <div style="flex: 1">
                            <asp:Label ID="lblAccountNumber" runat="server" Text="Bank Account Number" AssociatedControlID="txtAccountNumber"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvAccountNumber" runat="server"
                                    ControlToValidate="txtAccountNumber"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txtAccountNumber" runat="server" CssClass="form-control" MaxLength="18" onkeypress="return isNumberKey(event)"></asp:TextBox>
                        </div>

                        <div style="flex: 1">
                            <asp:Label ID="lblBankName" runat="server" Text="Bank Name" AssociatedControlID="txtBankName"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvBankName" runat="server"
                                    ControlToValidate="txtBankName"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txtBankName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>

                    <!-- Second Row: IFSC and PAN -->
                    <div class="form-row my-4">
                        <div style="flex: 1">
                            <asp:Label ID="lblIFSC" runat="server" Text="IFSC Code" AssociatedControlID="txtIFSC"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvIFSC" runat="server"
                                    ControlToValidate="txtIFSC"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                           <asp:TextBox ID="txtIFSC" runat="server" CssClass="form-control"
    onkeypress="return isAlphaNumeric(event)" 
    onkeyup="toUpperCaseText(this)">
</asp:TextBox>
                        </div>

                        <div style="flex: 1">
                            <asp:Label ID="lblPanNumber" runat="server" Text="PAN Number (Optional)" AssociatedControlID="txtPanNumber"></asp:Label>

                            <!-- Optional, so no validator needed -->
                           <asp:TextBox ID="txtPanNumber" runat="server" CssClass="form-control" 
    MaxLength="10" onkeyup="toUpperCaseText(this)" 
    onkeypress="return validatePAN(event, this)">
</asp:TextBox>
                        </div>
                    </div>

                    <!-- Third Row: Aadhar -->
                    <div class="form-row my-4">
                        <div style="flex: 2">
                            <asp:Label ID="lblAadhar" runat="server" Text="Aadhar Number" AssociatedControlID="txtAadhar"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvAadhar" runat="server"
                                    ControlToValidate="txtAadhar"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:TextBox ID="txtAadhar" runat="server" CssClass="form-control" MaxLength="12" onkeypress="return isNumberKey(event)"></asp:TextBox>
                        </div>

                        <div style="flex: 2; position: relative;">
                            <asp:Label ID="lblAadharFile" runat="server" Text="Upload Aadhar File" AssociatedControlID="fileBeneficiary"></asp:Label>
                            <span style="color: red;">
                                <asp:RequiredFieldValidator ID="rfvAadharFile" runat="server"
                                    ControlToValidate="fileBeneficiary"
                                    ErrorMessage="*"
                                    ForeColor="Red"
                                    ValidationGroup="a"
                                    Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </span>
                            <asp:FileUpload ID="filebeneficiary" runat="server" CssClass="form-control" />
                            <asp:LinkButton ID="btnPreview" runat="server" Text="Preview" OnClientClick="return false;" CssClass="btn btn-link mt-2" Style="display: none;"></asp:LinkButton>
                        </div>
                    </div>


                    <div class="submitNowBtn">
                        <asp:Button runat="server" ID="btn_submit_beneficiary_details"  CssClass="submit-btn" Text="Submit" ValidationGroup="a" />
                    </div>

                    <asp:HiddenField ID="hfId" runat="server" />
                    <asp:HiddenField ID="hfBeneficiaryId" runat="server" />

                </div>



              
            </div>
        </div>
    </div>

   

 
</asp:Content>

