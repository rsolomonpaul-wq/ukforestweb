<%@ Page Title="" Language="C#" MasterPageFile="~/Forest/forestmaster.Master" AutoEventWireup="true" CodeBehind="upload_data.aspx.cs" Inherits="uk_forest.Forest.upload_data" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="card addRolesBox mb-3">
        <div class="card-header d-flex flex-row align-items-center justify-content-between">
            <h3 runat="server" id="heading_add" class="m-0 font-weight-bolder text-uppercase text-white" style="font-size: larger; font-weight: 700;">Upload Data
            </h3>
        </div>


        <div class="card-body uploadData">
            <%--     <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>--%>
            <div class="row">

                <div class="col-md-3">
                    <asp:Label ID="lbl_user_name" runat="server" CssClass="font-weight-bold">User Name:</asp:Label>
                    <asp:DropDownList ID="ddl_user_name" AutoPostBack="true" runat="server" CssClass="form-control ddl-with-icon" OnSelectedIndexChanged="ddl_user_name_SelectedIndexChanged"></asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <asp:Label ID="Label1" runat="server" CssClass="font-weight-bold">File Type: 
                             </asp:Label>

                    <asp:DropDownList ID="ddlfiletype" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlfiletype_SelectedIndexChanged" CssClass="form-control ddl-with-icon">
                        <asp:ListItem>Vector</asp:ListItem>
                        <asp:ListItem>Raster</asp:ListItem>
                        <asp:ListItem>KML</asp:ListItem>
                       <%-- <asp:ListItem>GeoJson</asp:ListItem>
                        <asp:ListItem>Excel</asp:ListItem>
                        <asp:ListItem>PDF</asp:ListItem>
                        <asp:ListItem>Image</asp:ListItem>--%>
                    </asp:DropDownList>

                </div>

            <%--    <div class="col-md-3">
                    <asp:Label ID="datatype" runat="server" CssClass="font-weight-bold">Data Type 
                              <span style="color:red;">*</span>
                              </asp:Label>

                    <asp:DropDownList ID="ddldatatype" AutoPostBack="true" OnSelectedIndexChanged="ddldatatype_SelectedIndexChanged" runat="server" CssClass="form-control ddl-with-icon">
                    </asp:DropDownList>

                </div>

                <div class="col-md-3">
                    <asp:Label ID="lbllayergroupname" runat="server" CssClass="font-weight-bold">Layer Group Name 
                              <span style="color:red;">*</span>
                              </asp:Label>

                    <asp:DropDownList ID="ddllayergroupname" runat="server" OnSelectedIndexChanged="ddllayergroupname_SelectedIndexChanged" AutoPostBack="true" CssClass="form-control ddl-with-icon">
                    </asp:DropDownList>

                </div>--%>


                <div class="col-md-3">
                    <asp:Label ID="Label3" runat="server" CssClass="font-weight-bold">Display Name: <span style="color:red;">*</span></asp:Label>
                    <asp:TextBox ID="fileUploadTextBox" runat="server" CssClass="form-control" MaxLength="80"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="fileUploadTextBox" ForeColor="Red" ValidationGroup="up"></asp:RequiredFieldValidator>
                </div>
                <%--<div class="col-md-3">
                            <asp:Label ID="Label2" runat="server" CssClass="font-weight-bold">Data add to all users' map TOC:</asp:Label>
                           <asp:DropDownList ID="ddl_toc" runat="server" CssClass="form-control ddl-with-icon">
                              
                            </asp:DropDownList>

                        </div>--%>

             <%--   <div class="col-md-3">
                    <asp:Label ID="Label6" runat="server" CssClass="font-weight-bold">File Status:</asp:Label>
                    <asp:DropDownList ID="ddl_file_status" runat="server" CssClass="form-control ddl-with-icon">
                    </asp:DropDownList>
                </div>--%>

                <div class="col-md-3">
                    <asp:Label ID="Label4" runat="server" CssClass="font-weight-bold">Upload Data: <span style="color:red;">*</span></asp:Label>
                    <asp:FileUpload ID="upload_shape_file" runat="server"></asp:FileUpload>
                </div>

                <div class="col-md-3">
                    <asp:Label ID="lbluploadstyle" runat="server" CssClass="font-weight-bold">Upload Style: <span style="color:red;">*</span></asp:Label>
                    <asp:FileUpload ID="upload_style" runat="server"></asp:FileUpload>

                </div>
                <div class="col-md-3">
                    <asp:Button ID="btnUploadData" OnClick="btn_uploaddata_Click" runat="server" ValidationGroup="up" Text="Upload Data" CssClass="btn-success btn-sm rounded my-4" />

                </div>

                <div class="modal fade" id="exampleModal" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">You can browse for one the following file types:</h5>
                                <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <li style="font-size: 16px">A Shapefile (Must be .zip, ZIP archive containing all shapefile files). 
                                </li>
                                <li style="font-size: 16px">A Shapefile (Must be .rar, RAR archive containing all shapefile files). 
                                </li>
                                <li style="font-size: 16px">A KML File (.kml) or KMZ File (.kmz)
                                </li>
                                <li>A Raster file as tiff (.tiff)</li>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <%-- </ContentTemplate>
            </asp:UpdatePanel>--%>





            <%-- <div class="row">
                <div class="col-md-4">
                </div>

                <div class="col-md-4 d-flex align-items-center justify-content-center">
                  
                </div>

                <div class="col-md-4">
                </div>
            </div>--%>
        </div>
    </div>


    <div class="card addRolesBox mb-3 shadow-lg">
        <div class="card-header d-flex flex-row align-items-center justify-content-between">
            <h3 class="m-0 font-weight-bolder text-uppercase text-white" style="font-size: larger; font-weight: 700;">Data List
            </h3>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <asp:Label ID="lbl_msg_alert" runat="server" ForeColor="Red" Visible="false"></asp:Label>
                <asp:GridView ID="grid_Modules" AutoGenerateColumns="false" DataKeyNames="sno" runat="server" Width="100%" EmptyDataText="No Data Found !!!">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="sno" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lbl_sno" runat="server" Text='<%# Eval("sno") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="User Id">
                            <ItemTemplate>
                                <asp:Label ID="lbl_user_id" runat="server" Text='<%# Eval("user_id") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                           <asp:TemplateField HeaderText="User Name">
                            <ItemTemplate>
                                <asp:Label ID="lbl_user_name" runat="server" Text='<%# Eval("name") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Layer Group">
                            <ItemTemplate>
                                <asp:Label ID="lbl_module_name" runat="server" Text='<%# Eval("module_name") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Sub Module Id" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lbl_sub_module_id" runat="server" Text='<%# Eval("sub_module_id") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Display / File Name">
                            <ItemTemplate>
                                <asp:Label ID="lbl_sub_module_name" runat="server" Text='<%# Eval("sub_module_name") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Document" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lbl_layer_path" runat="server" Text='<%# Eval("layer_path") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="File Type">
                            <ItemTemplate>
                                <asp:Label ID="lbl_layer_type" runat="server" Text='<%# Eval("layer_type") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="File Status">
                            <ItemTemplate>
                                <asp:Label ID="lbl_file_status" runat="server" Text='<%# Eval("file_status") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddl_status_approved" OnSelectedIndexChanged="ddl_status_approved_SelectedIndexChanged" runat="server" AutoPostBack="true" CssClass="form-control ddl-with-icon" Style="width: 50%;" EnableViewState="true" CausesValidation="true" ValidationGroup="complete">
                                    <asp:ListItem Value="">Select</asp:ListItem>
                                    <asp:ListItem Value="Download">Download</asp:ListItem>
                                    <asp:ListItem Value="Publish">Publish On Map</asp:ListItem>
                                    <asp:ListItem Value="Delete">Delete</asp:ListItem>
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
