pageextension 50203 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    actions
    {
        addfirst(processing)
        {

            action("Line Certificate")
            {
                ApplicationArea = All;
                Caption = 'Safety Certificate for Item';
                ToolTip = 'Create Safety Certificate for selected item';
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesInvLine: Record "Sales Invoice Line";
                    CertReport: Report "Certificate";
                    Item: Record Item;
                begin
                    CurrPage.SalesInvLines.Page.GetRecord(SalesInvLine);

                    if SalesInvLine.Type <> SalesInvLine.Type::Item then
                        Error('Please select an item line.');

                    if not Item.Get(SalesInvLine."No.") then
                        Error('Item not found.');

                    if Item.CertificateNo = '' then
                        Error('This item does not have a certificate.');

                    SalesInvHeader.Get(Rec."No.");
                    CertReport.SetTableView(SalesInvHeader);
                    CertReport.SetItemNo(SalesInvLine."No.");
                    CertReport.Run();
                end;
            }
        }
    }
}
