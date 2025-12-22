pageextension 50203 "Sales Order Ext" extends "Posted Sales Invoice"
{
    layout
    {
    }
    actions
    {
        addfirst(processing)
        {
            action("Safety Certificate")
            {
                ApplicationArea = All;
                Caption = 'Safety Certificate';
                ToolTip = 'Create Safety Certificate';
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    CertReport: Report "Certificate";
                begin
                    CertReport.Run();
                end;
            }
        }
    }
}