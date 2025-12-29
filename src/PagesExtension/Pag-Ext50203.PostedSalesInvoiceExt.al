pageextension 50203 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    actions
    {
        addfirst(processing)
        {

            action("Certificate")
            {
                ApplicationArea = All;
                Caption = 'Safety Certificate';
                ToolTip = 'Create Safety Certificate for all items with certificates';
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesInvLine: Record "Sales Invoice Line";
                    CertReport: Report "Certificate";
                    Item: Record Item;
                    HasCertificate: Boolean;
                    ExpiredItems: Text;
                begin
                    // Verificar se existe pelo menos um item com certificado e validar validade
                    SalesInvLine.SetRange("Document No.", Rec."No.");
                    SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
                    if SalesInvLine.FindSet() then
                        repeat
                            if Item.Get(SalesInvLine."No.") then begin
                                if Item.CertificateNo <> '' then begin
                                    HasCertificate := true;

                                    // Validar se o certificado está dentro da validade
                                    if Item.CertExpireDate < Today then begin
                                        if ExpiredItems <> '' then
                                            ExpiredItems += ', ';
                                        ExpiredItems += Item."No." + ' (' + Item.Description + ')';
                                    end;
                                end;
                            end;
                        until SalesInvLine.Next() = 0;

                    if not HasCertificate then
                        Error('No items with certificates found in this invoice.');

                    if ExpiredItems <> '' then
                        Error('Certificate expired for: %1', ExpiredItems);

                    SalesInvHeader.Reset();
                    SalesInvHeader.SetRange("No.", Rec."No.");
                    if SalesInvHeader.FindFirst() then begin
                        CertReport.SetTableView(SalesInvHeader);
                        CertReport.Run();
                    end;
                end;
            }
        }
    }
}
