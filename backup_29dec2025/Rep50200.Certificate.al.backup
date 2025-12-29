report 50200 "Certificate"
{
    Caption = 'Safety Certificate';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = WordLayout;

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Type = const(Item));

                column(SalesOrderNo; SalesInvoiceHeader."No.") { }
                column(CustomerNo; SalesInvoiceHeader."Sell-to Customer No.") { }
                column(CustomerName; SalesInvoiceHeader."Sell-to Customer Name") { }
                column(DateOfSale; SalesInvoiceHeader."Posting Date") { }
                column(ProductName; ItemRec.Description) { }
                column(Manufacturer; ItemRec.Brand) { }
                column(CertificateNo; ItemRec.CertificateNo) { }
                column(ValidTo; ItemRec.CertExpireDate) { }

                trigger OnAfterGetRecord()
                begin
                    // Se foi especificado um item, processar apenas esse
                    if SpecificItemNo <> '' then begin
                        if SalesInvoiceLine."No." <> SpecificItemNo then
                            CurrReport.Skip();
                    end;

                    if not ItemRec.Get(SalesInvoiceLine."No.") then
                        CurrReport.Skip();

                    if ItemRec.CertificateNo = '' then
                        CurrReport.Skip();

                    // Se nenhum item específico foi definido, processar apenas o primeiro
                    if (SpecificItemNo = '') and CertificateProcessed then
                        CurrReport.Skip();

                    CertificateProcessed := true;
                end;
            }
        }
    }

    rendering
    {
        layout(WordLayout)
        {
            Type = Word;
            LayoutFile = 'Certificate.docx';
        }
    }

    var
        ItemRec: Record Item;
        SpecificItemNo: Code[20];
        CertificateProcessed: Boolean;

    procedure SetItemNo(ItemNo: Code[20])
    begin
        SpecificItemNo := ItemNo;
    end;
}
