<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/wildlife.Master" AutoEventWireup="true" CodeBehind="AddApplicantDetails.aspx.cs" Inherits="uk_forest.Forest.AddApplicantDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .modal-backdrop {
            --bs-backdrop-opacity: 1 !important;
            background-color: #000000e6 !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <h1 class="text-center mt-1 text-primary">Applicant Details</h1>
        <hr />

        <div class="col-lg-4 col-md-4 col-12 border p-2">
            <asp:Label ID="label1" runat="server" Text="Applicant ID:" Style="font-weight: 700; font-size: 15px;"></asp:Label>
            <asp:Label ID="lblapplicantid" runat="server" Style="color: red; font-weight: 600; font-size: 15px;"></asp:Label>
        </div>

        <div class="col-lg-4 col-md-4 col-12 border p-2">
            <asp:Label ID="Label2" runat="server" Text="Name:" Style="font-weight: 700; font-size: 15px;"></asp:Label>
            <asp:Label ID="lblapplicantname" runat="server" Style="color: red; font-weight: 600; font-size: 15px;"></asp:Label>
        </div>

        <div class="col-lg-4 col-md-4 col-12 border p-2">
            <asp:Label ID="Label4" runat="server" Text="Mobile No:" Style="font-weight: 700; font-size: 15px;"></asp:Label>
            <asp:Label ID="lblapplicantmobileno" runat="server" Style="color: red; font-weight: 600; font-size: 15px;"></asp:Label>
        </div>

        <div class="col-lg-12 border mt-2 p-2">
            <div class="row">
                <div class="col-lg-6 col-md-6 col-12 border mt-1 p-1">
                    <h3 class="text-center text-primary">Basic Details</h3>
                    <hr />

                    <asp:Label ID="Label3" runat="server" Text="Gender:" Style="font-weight: 700;"></asp:Label>
                    <asp:RadioButtonList ID="GenderRadioButtonList" runat="server" RepeatDirection="Horizontal" CssClass="form-control" Style="border: none; padding-left: 0;">
                        <asp:ListItem Text="Male" Value="Male" Selected="True" style="margin-right: 30px;"></asp:ListItem>
                        <asp:ListItem Text="Female" Value="Female" style="margin-right: 30px;"></asp:ListItem>
                        <asp:ListItem Text="Other" Value="Other" style="margin-right: 30px;"></asp:ListItem>
                    </asp:RadioButtonList>
                    <br />
                    <asp:Label ID="Label5" runat="server" Text="Address:" Style="font-weight: 700;"></asp:Label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label6" runat="server" Text="Aadhar No:" Style="font-weight: 700;"></asp:Label>
                    <asp:TextBox ID="txtaadharno" runat="server" CssClass="form-control" MaxLength="12" onkeypress="return isNumberKey(event)"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label7" runat="server" Text="Aadhar Doc:" Style="font-weight: 700;"></asp:Label>
                    <asp:FileUpload ID="fileaadhardocss" runat="server" CssClass="form-control"></asp:FileUpload>
                    <asp:HyperLink ID="lnk_aadhar" runat="server"
                        Text="View Image"
                        Target="_blank"
                        CssClass="btn btn-link"
                        Visible="false" />
                    <br />

                    <div class="row text-center">
                        <div class="col-lg-5">
                        </div>

                        <div class="col-lg-2">
                            <asp:Button ID="btn_submit_basic_details" runat="server" Text="Submit" CssClass="btn btn-success rounded" OnClick="btn_submit_basic_details_Click" />
                        </div>

                        <div class="col-lg-5">
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 col-md-6 col-12 border mt-1 p-1">
                    <h3 class="text-center text-primary">Bank Details</h3>
                    <hr />

                    <asp:Label ID="Label8" runat="server" Text="Bank Name:" Style="font-weight: 700;"></asp:Label>
                    <asp:TextBox ID="txtbankname" runat="server" CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label9" runat="server" Text="Ifsc Code:" Style="font-weight: 700;"></asp:Label>
                    <asp:TextBox ID="txtifsc" runat="server" CssClass="form-control" onkeyup="convertToUppercase(this)"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label10" runat="server" Text="Account No:" Style="font-weight: 700;"></asp:Label>
                    <asp:TextBox ID="txtaccountno" runat="server" CssClass="form-control"></asp:TextBox>
                    <br />

                    <asp:Label ID="lblconfirm_accountno" runat="server" Text="Confirm Account No:" Style="font-weight: 700;"></asp:Label>
                    <asp:TextBox ID="txtconfirm_accountno" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                    <br />

                    <asp:Label ID="Label11" runat="server" Text="Account Holder Name:" Style="font-weight: 700;"></asp:Label>
                    <asp:TextBox ID="txtaccountholdername" runat="server" CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:Label ID="Label12" runat="server" Text="Passbook copy:" Style="font-weight: 700;"></asp:Label>
                    <asp:FileUpload ID="txtfileupload" runat="server" CssClass="form-control"></asp:FileUpload>
                    <asp:HyperLink ID="lnk_show" runat="server"
                        Text="View Image"
                        Target="_blank"
                        CssClass="btn btn-link"
                        Visible="false" />

                    <br />

                    <div class="row text-center">
                        <div class="col-lg-5">
                        </div>

                        <div class="col-lg-2">
                            <asp:Button ID="btn_submit_bank_details" runat="server" Text="Submit" CssClass="btn btn-success rounded" OnClick="btn_submit_bank_details_Click" />
                        </div>

                        <div class="col-lg-5">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- Add these references before your custom script -->
    

   

    <script type="text/javascript">
        function convertToUppercase(textbox) {
            textbox.value = textbox.value.toUpperCase();
        }
    </script>

    <script type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        // Optional: Prevent pasting non-numeric content
        document.getElementById('<%= txtaadharno.ClientID %>').addEventListener('paste', function (e) {
            e.preventDefault();
            var pasteData = e.clipboardData.getData('text/plain');
            var numericData = pasteData.replace(/[^0-9]/g, '');
            document.execCommand('insertText', false, numericData.substring(0, 12));
        });
    </script>

    <script type="text/javascript">
        // Allow only numbers (0-9) and block other characters
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }


    </script>
</asp:Content>
