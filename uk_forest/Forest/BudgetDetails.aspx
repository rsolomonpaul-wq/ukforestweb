<%@ Page Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" Async="true" CodeBehind="BudgetDetails.aspx.cs" Inherits="uk_forest.Forest.BudgetDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .form-container {
            margin: 40px auto;
            padding: 30px 25px;
            border-radius: 12px;
            background-color: #fff;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            max-width: 1000px;
            border: 1px #8080808a solid;
        }

            .form-container:hover {
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
            }

        .form-label {
            font-weight: 600;
            color: #333;
        }

        .error-message {
            color: red;
            font-size: 0.9rem;
        }

        .grid-container {
            width: 100%;
            margin: 30px auto;
            overflow-x: auto;
            border: 1px #8080808a solid;
            padding: 10px;
            background: white;
            border-radius: 12px;
        }

            .grid-container .table td {
                padding: 10px !important;
                border: 1px #00000040 solid;
            }

        .grid-view th {
            background-color: #068e61 !important;
            color: #fff;
            text-align: center;
            font-weight: 600;
            white-space: nowrap;
        }

        .grid-view td {
            vertical-align: middle;
            white-space: nowrap;
        }

        @media (max-width: 767px) {
            .form-container {
                padding: 20px;
                margin: 20px;
            }

            h2 {
                font-size: 1.5rem;
            }

            .btn {
                width: 100%;
            }

            .grid-view th, .grid-view td {
                font-size: 0.85rem;
                white-space: normal;
            }
        }

        @media (max-width: 480px) {
            .form-container {
                padding: 15px;
            }

            .form-label {
                font-size: 0.9rem;
            }

            small#lblAmountInWords {
                font-size: 0.8rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="form-container">
        <h2 class="text-center mb-4 text-success">Add Budget Details</h2>

        <div class="row g-3">
            <div class="col-lg-6 col-md-6 col-12">
                <label class="form-label">Division</label>
                <asp:Label ID="lblDfoId" runat="server" CssClass="form-control" />
            </div>

            <%--  <div class="col-lg-6 col-md-6 col-12">
                    <label for="ddlYear" class="form-label">Select Year</label>
                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlYear_SelectedIndexChanged">
                    </asp:DropDownList>
                   
                </div>

                <div class="col-lg-6 col-md-6 col-12">
                    <label for="ddlMonth" class="form-label">Select Month</label>
                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlMonth_SelectedIndexChanged">
                    </asp:DropDownList>
                   
                </div>--%>

            <div class="col-lg-6 col-md-6 col-12">
                <label for="txtAmount" class="form-label">Budget Amount</label>
                <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control"
                    placeholder="Enter Budget Amount"
                    oninput="validateAmount(this)"
                    MaxLength="9" />
                <small id="lblAmountInWords" class="form-text" style="color: red; font-weight: 500;"></small>
            </div>

            <div class="col-lg-6 col-md-6 col-12">
    <label for="txtReleaseDate" class="form-label">Budget Release Date</label>
    
    <asp:TextBox 
        ID="txtReleaseDate" 
        runat="server" 
        CssClass="form-control"
        TextMode="Date"
        placeholder="Select Release Date" />
</div>


            <div class="col-12 text-center mt-3">
                <asp:Button ID="btnSubmit" runat="server" Text="Submit"
                    CssClass="btn btn-success px-5 py-2 shadow-sm"
                    data-bs-toggle="tooltip"
                    data-bs-placement="top"
                    title="Click to save the budget details securely"
                    OnClick="btnSubmit_Click" />
            </div>
        </div>
    </div>

    <div class="grid-container">
        <h3 class="text-center mb-3 text-success">Budget Details</h3>
        <div class="table-responsive">
            <asp:GridView ID="gvBudgetDetails" runat="server"
                CssClass="table table-bordered table-hover grid-view"
                AutoGenerateColumns="False"
                EmptyDataText="No budget details found.">
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>

                    <%--     <asp:TemplateField HeaderText="DFO ID">
                            <ItemTemplate><%# Eval("DfoId") %></ItemTemplate>
                        </asp:TemplateField>--%>

                    <%--   <asp:TemplateField HeaderText="Month">
                            <ItemTemplate><%# Eval("Month") %></ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Year">
                            <ItemTemplate><%# Eval("Year") %></ItemTemplate>
                        </asp:TemplateField>--%>

                    <asp:TemplateField HeaderText="Budget Releasing Date">
                        <ItemTemplate><%# Eval("budgetReleasingDate", "{0:dd-MM-yyyy}") %></ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Budget Amount">
                        <ItemTemplate><%# Eval("Amount", "{0:N2}") %></ItemTemplate>
                        <ItemStyle HorizontalAlign="Left" />
                    </asp:TemplateField>

                    
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <script>
        // Tooltip initialization
        document.addEventListener('DOMContentLoaded', () => {
            [...document.querySelectorAll('[data-bs-toggle="tooltip"]')].forEach(el => new bootstrap.Tooltip(el));
        });

        // Numeric + Decimal validation
        function validateAmount(input) {
            let value = input.value.replace(/[^0-9.]/g, '');
            const parts = value.split('.');
            if (parts.length > 2) value = parts[0] + '.' + parts[1];
            if (parts.length === 2) parts[1] = parts[1].substring(0, 2);
            input.value = parts.join('.');

            const label = document.getElementById("lblAmountInWords");
            label.textContent = value ? convertAmountToIndianWords(value) : "";
        }

        // Convert number to words
        function convertAmountToIndianWords(amountStr) {
            const [rupeesStr, paiseStr] = amountStr.split(".");
            const rupees = parseInt(rupeesStr) || 0;
            const paise = parseInt(paiseStr || "0") || 0;
            let words = "";
            if (rupees > 0) words += numberToWords(rupees) + " Rupees";
            if (paise > 0) words += (rupees > 0 ? " and " : "") + numberToWords(paise) + " Paise";
            return (words || "Zero Rupees") + " Only";
        }

        function numberToWords(num) {
            const ones = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"];
            const tens = ["", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"];
            const teens = ["Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"];

            if (num === 0) return "Zero";
            if (num < 10) return ones[num];
            if (num < 20) return teens[num - 10];
            if (num < 100) return tens[Math.floor(num / 10)] + (num % 10 ? " " + ones[num % 10] : "");
            if (num < 1000) return ones[Math.floor(num / 100)] + " Hundred " + numberToWords(num % 100);
            if (num < 100000) return numberToWords(Math.floor(num / 1000)) + " Thousand " + numberToWords(num % 1000);
            if (num < 10000000) return numberToWords(Math.floor(num / 100000)) + " Lakh " + numberToWords(num % 100000);
            return numberToWords(Math.floor(num / 10000000)) + " Crore " + numberToWords(num % 10000000);
        }
    </script>
</asp:Content>
