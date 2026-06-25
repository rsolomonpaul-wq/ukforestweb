<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Forest/masterpage.Master" CodeBehind="vitimAllDetails.aspx.cs" Inherits="uk_forest.Forest.vitimAllDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
      <style>
       .stepper {
           display: flex;
           justify-content: space-between;
           margin: 20px 0;
       }
       .step {
           text-align: center;
           width: 20%;
       }
       .step .circle {
           width: 30px;
           height: 30px;
           border-radius: 50%;
           background: #28a745;
           color: #fff;
           display: inline-flex;
           align-items: center;
           justify-content: center;
           margin-bottom: 5px;
       }
       .doc-row {
           display: flex;
           justify-content: space-between;
           align-items: center;
           padding: 8px 12px;
           border: 1px solid #ddd;
           border-radius: 6px;
           margin-bottom: 8px;
           background: #fff;
       }
   </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <div class="container mt-4">

         <!-- Header -->
         <div class="d-flex justify-content-between align-items-center">
             <h4 class="text-success">Track Your Application</h4>
             <span class="badge bg-success">Application Status : Open</span>
         </div>

         <!-- Stepper -->
         <div class="stepper">
             <div class="step">
                 <div class="circle">1</div>
                 <small>Application Submitted</small>
             </div>
             <div class="step">
                 <div class="circle">2</div>
                 <small>Advance Payment Release</small>
             </div>
             <div class="step">
                 <div class="circle">3</div>
                 <small>Inspection Report Submission</small>
             </div>
             <div class="step">
                 <div class="circle">4</div>
                 <small>Final Approval</small>
             </div>
             <div class="step">
                 <div class="circle">5</div>
                 <small>Final Payment</small>
             </div>
         </div>
         <p class="text-center text-muted">40 days left until payment disbursement</p>

         <!-- Submitted Application -->
         <div class="card shadow-sm mb-3">
             <div class="card-header bg-success text-white d-flex justify-content-between">
                 <span>Submitted Application</span>
                 <asp:Button ID="btnPreview" runat="server" Text="Preview" CssClass="btn btn-light btn-sm" />
             </div>
             <div class="card-body">
                 <table class="table table-bordered mb-0">
                     <tr>
                         <th>Applicant ID</th>
                         <td>454354</td>
                         <th>Victim Name</th>
                         <td>Ramajkais</td>
                     </tr>
                     <tr>
                         <th>Age</th>
                         <td>45 Years</td>
                         <th>Claim Category</th>
                         <td>Human Death/Injury</td>
                     </tr>
                     <tr>
                         <th>Date of Incident</th>
                         <td>2/03/2025</td>
                         <th>Incident Occurred By</th>
                         <td>Leopard</td>
                     </tr>
                 </table>
             </div>
         </div>

         <!-- Uploaded Documents -->
         <div class="card shadow-sm">
             <div class="card-header bg-success text-white">Uploaded Documents</div>
             <div class="card-body">

                 <div class="doc-row">
                     <span>Aadhar_card.jpg</span>
                     <div>
                         <asp:Button runat="server" Text="Preview" CssClass="btn btn-outline-success btn-sm me-2" />
                         <asp:Button runat="server" Text="Download" CssClass="btn btn-success btn-sm" />
                     </div>
                 </div>

                 <!-- Repeat for other documents -->

             </div>
         </div>

     </div>

</asp:Content>

